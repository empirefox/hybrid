package ipfs

import (
	"context"

	files "github.com/ipfs/go-ipfs-files"
	"github.com/ipfs/interface-go-ipfs-core/options"
	"github.com/ipfs/interface-go-ipfs-core/path"
)

func (hi *Ipfs) Get(ctx context.Context, p string) (files.Node, error) {
	api, err := hi.coreAPI()
	if err != nil {
		return nil, err
	}

	c, cancel := context.WithCancel(hi.ctx)
	defer cancel()

	go func() {
		select {
		case <-ctx.Done():
			cancel()
		}
	}()

	return api.Unixfs().Get(c, path.New(p))
}

func (hi *Ipfs) Add(ctx context.Context, file files.File, settings options.UnixfsAddSettings) (path.Resolved, error) {
	api, err := hi.coreAPI()
	if err != nil {
		return nil, err
	}

	c, cancel := context.WithCancel(hi.ctx)
	defer cancel()

	go func() {
		select {
		case <-ctx.Done():
			cancel()
		}
	}()

	return api.Unixfs().Add(c, file, func(target *options.UnixfsAddSettings) error {
		if settings.CidVersion == 0 {
			settings.CidVersion = target.CidVersion
		}
		*target = settings
		return nil
	})
}
