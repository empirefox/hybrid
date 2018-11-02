package hybridipfs

import (
	"context"
	"net"
	"net/http"
	"strings"

	core "github.com/ipsn/go-ipfs/core"
	"github.com/ipsn/go-ipfs/core/corehttp"
	namesys "github.com/ipsn/go-ipfs/namesys"
	nsopts "github.com/ipsn/go-ipfs/namesys/opts"

	isd "github.com/jbenet/go-is-domain"
)

// IPNSHostnameOption rewrites an incoming request if its Host: header contains
// an IPNS name.
// The rewritten request points at the resolved name on the gateway handler.
func IPNSHostnameOption(exclude func(host string) bool) corehttp.ServeOption {
	return func(n *core.IpfsNode, _ net.Listener, mux *http.ServeMux) (*http.ServeMux, error) {
		childMux := http.NewServeMux()
		mux.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
			ctx, cancel := context.WithCancel(n.Context())
			defer cancel()

			host := strings.SplitN(r.Host, ":", 2)[0]
			if len(host) > 0 && isd.IsDomain(host) && !exclude(host) {
				name := "/ipns/" + host
				_, err := n.Namesys.Resolve(ctx, name, nsopts.Depth(1))
				if err == nil || err == namesys.ErrResolveRecursion {
					r.Header.Set("X-Ipns-Original-Path", r.URL.Path)
					r.URL.Path = name + r.URL.Path
				}
			}
			childMux.ServeHTTP(w, r)
		})
		return childMux, nil
	}
}
