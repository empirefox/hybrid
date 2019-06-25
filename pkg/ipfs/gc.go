package ipfs

import (
	cid "github.com/ipfs/go-cid"
	"github.com/ipfs/go-ipfs/core/corerepo"
	mh "github.com/multiformats/go-multihash"
)

func (hi *Ipfs) GC() ([]mh.Multihash, error) {
	gcOutChan := corerepo.GarbageCollectAsync(hi.getAnyNode(), hi.ctx)
	killed := make([]mh.Multihash, 0, 8)

	// CollectResult blocks until garbarge collection is finished:
	err := corerepo.CollectResult(hi.ctx, gcOutChan, func(k cid.Cid) {
		killed = append(killed, k.Hash())
	})

	if err != nil {
		return nil, err
	}

	return killed, nil
}
