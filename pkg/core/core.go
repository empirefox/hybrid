package core

import (
	"context"
	"net/http"
	"sync"

	"go.uber.org/zap"
)

type Core struct {
	Log           *zap.Logger
	ContextConfig *ContextConfig
	Routers       []Router
	Proxies       map[string]Proxy
	LocalServers  map[string]http.Handler
	HijackServers map[string]http.Handler

	done     chan struct{}
	doneOnce sync.Once
	initOnce sync.Once
}

func (core *Core) Proxy(c *Context) {
	if c.ResponseWriter != nil {
		req := c.Request
		ctx := req.Context()
		if cn, ok := c.ResponseWriter.(http.CloseNotifier); ok {
			var cancel context.CancelFunc
			ctx, cancel = context.WithCancel(ctx)
			defer cancel()
			notifyChan := cn.CloseNotify()
			go func() {
				select {
				case <-notifyChan:
					cancel()
				case <-ctx.Done():
				}
			}()
		}
		req.WithContext(ctx)
	}

	if core.HijackServers != nil {
		handler, ok := core.HijackServers[c.Domain.DialHostname]
		if ok {
			core.Log.Debug("hijack", zap.String("HostPort", c.HostPort))
			handler.ServeHTTP(c.ResponseWriterOrWrapOne(), c.Request)
			return
		}
	}

	if c.Domain.IsHybrid {
		if c.Domain.IsEnd {
			// xxx.over.-a.hybrid, xxx.with.hybrid, xxx.over.hybrid
			// DialHostname=xxx
			if core.LocalServers != nil {
				handler, ok := core.LocalServers[c.Domain.DialHostname]
				if ok {
					core.Log.Debug("hybrid end", zap.String("HostPort", c.HostPort))
					handler.ServeHTTP(c.ResponseWriterOrWrapOne(), c.Request)
					return
				}
			}
			// dial: c.DialHostPort
			if c.Domain.IsOver {
				core.routeProxy(c)
				return
			}

			core.Log.Debug("hybrid not found", zap.String("HostPort", c.HostPort))
			c.HybridHttpErr(http.StatusNotFound, "")
			return
		}

		p, ok := core.Proxies[c.Domain.Next]
		if !ok {
			core.Log.Debug("hybrid next not found", zap.String("HostPort", c.HostPort))
			c.HybridHttpErr(http.StatusNotFound, c.Domain.Next)
			return
		}

		core.Log.Debug("core",
			zap.String("HostPort", c.HostPort),
			zap.String("Next", c.Domain.Next),
			zap.String("proxy", p.Name()))
		c.proxy(p)
		return
	}

	core.routeProxy(c)
}

func (core *Core) routeProxy(c *Context) {
	for _, rc := range core.Routers {
		if rc.Disabled() {
			continue
		}

		p := rc.Route(c)
		if p == nil {
			continue
		}

		core.Log.Debug("core",
			zap.String("HostPort", c.HostPort),
			zap.String("router", rc.Name()),
			zap.String("proxy", p.Name()))
		c.proxy(p)
		return
	}

	core.Log.Debug("core",
		zap.String("HostPort", c.HostPort),
		zap.String("proxy", DirectProxy.Name()))
	c.proxy(DirectProxy)
}

func (core *Core) Init()  { core.initOnce.Do(func() { core.done = make(chan struct{}) }) }
func (core *Core) Close() { core.doneOnce.Do(func() { close(core.done) }) }
