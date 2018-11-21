package proxy

import (
	"errors"
	"io"
	"sync"
	"time"

	"go.uber.org/zap"

	"github.com/cbednarski/hostess"
	"github.com/pmezard/adblock/adblock"

	"github.com/empirefox/hybrid/pkg/core"
)

var (
	ErrEmptyAdpRules = errors.New("empty adp rules loaded")
)

type AdpRouterConfig struct {
	Log       *zap.Logger
	Disabled  bool
	Blocked   core.Proxy
	Unblocked core.Proxy
	Rules     []io.ReadCloser

	EtcHostsIpAsBlocked bool
	Dev                 bool
}

type AdpRouter struct {
	log          *zap.Logger
	config       AdpRouterConfig
	adpMatcher   *adblock.RuleMatcher
	blockedIps   map[string]bool
	blockedIpsMu sync.RWMutex
}

func NewAdpRouter(config AdpRouterConfig) (*AdpRouter, error) {
	r := &AdpRouter{
		log:        config.Log,
		config:     config,
		adpMatcher: adblock.NewMatcher(),
		blockedIps: make(map[string]bool),
	}
	err := r.init()
	if err != nil {
		return nil, err
	}
	return r, nil
}

func (r *AdpRouter) Route(c *core.Context) core.Proxy {
	if blocked := r.blocked(c); blocked {
		return r.config.Blocked
	}
	return r.config.Unblocked
}

func (r *AdpRouter) blocked(c *core.Context) bool {
	r.blockedIpsMu.RLock()
	if r.blockedIps[c.HostNoPort] {
		r.blockedIpsMu.RUnlock()
		return true
	}
	r.blockedIpsMu.RUnlock()

	schema := c.Request.URL.Scheme
	if schema == "" {
		schema = "https"
	}
	blocked := r.AdpMatch(schema + "://" + c.HostNoPort)
	if blocked {
		r.blockedIpsMu.Lock()
		r.blockedIps[c.HostNoPort] = true
		r.blockedIpsMu.Unlock()
	}
	return blocked
}

func (r *AdpRouter) init() error {
	added, err := LoadAbpRules(r.adpMatcher, r.config.Rules)
	if err != nil {
		r.log.Error("LoadAbpRules", zap.Error(err))
	}

	if added == 0 {
		return ErrEmptyAdpRules
	}
	if r.config.Dev {
		r.log.Info("AdpList rules loaded", zap.Int("total", added))
	}

	// init blockedIps only after adpMatcher
	if r.config.EtcHostsIpAsBlocked {
		hf, errs := hostess.LoadHostfile()
		if errs != nil {
			if r.config.Dev {
				r.log.Debug("hosts errors")
				for _, err := range errs {
					r.log.Debug("hosts entry", zap.Error(err))
				}
			}
		}

		for _, hostname := range hf.Hosts {
			if hostname.Enabled && hostname.IsValid() && r.AdpMatch("http://"+hostname.Domain) {
				r.blockedIps[hostname.IP.String()] = true
			}
		}
	}

	return nil
}

func (r *AdpRouter) Disabled() bool { return r.config.Disabled }

func (r *AdpRouter) AdpMatch(u string) bool {
	rq := &adblock.Request{
		URL:          u,
		Domain:       "",
		OriginDomain: "",
		ContentType:  "",
		Timeout:      5 * time.Second,
	}
	matched, _, err := r.adpMatcher.Match(rq)
	if err != nil {
		r.log.Error("AdpMatch", zap.Error(err))
		return false // No Block here
	}

	return matched
}

// just copy
func LoadAbpRules(m *adblock.RuleMatcher, rcs []io.ReadCloser) (int, error) {
	defer func() {
		for _, rc := range rcs {
			rc.Close()
		}
	}()

	added := 0
	for _, r := range rcs {
		parsed, err := adblock.ParseRules(r)
		if err != nil {
			return 0, err
		}
		for _, rule := range parsed {
			err := m.AddRule(rule, 0)
			if err == nil {
				added++
			}
		}
	}
	return added, nil
}
