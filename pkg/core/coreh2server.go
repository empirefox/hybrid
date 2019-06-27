package core

import (
	"net"
	"net/http"
	"strings"

	"golang.org/x/net/http2"

	"github.com/empirefox/hybrid/pkg/netutil"
)

const (
	HostHttpPrefix  byte = 'H'
	HostHttpsPrefix byte = 'S'
)

func (core *Core) Serve(listener net.Listener) error {
	s1 := &http.Server{Handler: core}
	s2 := &http2.Server{}
	http2.ConfigureServer(s1, s2)

	go func() {
		select {
		case <-core.done:
			s1.Close()
		}
	}()
	return netutil.SimpleServe(listener, func(c net.Conn) {
		s2.ServeConn(c, &http2.ServeConnOpts{BaseConfig: s1})
		core.Log.Debug("ServeConn end")
	})
}

func (core *Core) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	if r.Method != "CONNECT" {
		r.URL.Scheme = "http"
		r.URL.Host = strings.TrimSuffix(r.Host, ":80")
	}

	r.ProtoMajor = 1
	r.ProtoMinor = 1
	r.Host = r.URL.Host

	c, err := NewContextFromHandler(core.ContextConfig, w, r)
	if err != nil {
		he := HttpErr{
			Code:       http.StatusBadRequest,
			ClientType: "Hybrid",
			ClientName: "CTX",
			TargetHost: r.URL.Host,
			Info:       err.Error(),
		}
		he.WriteResponse(w)
		return
	}
	core.Proxy(c)
}
