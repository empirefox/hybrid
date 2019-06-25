package node

import (
	"context"
	"encoding/base64"
	"io"
	"os"
	"path/filepath"

	files "github.com/ipfs/go-ipfs-files"
	"go.uber.org/zap"
)

type IpfsTomlFile struct {
	Path   string `toml:",omitempty"`
	Base64 bool   `toml:",omitempty"`
}

type IpfsTomlFiles struct {
	Ipfs []IpfsTomlFile `toml:",omitempty"`
}

type readCloser struct {
	io.Reader
	io.Closer
}

// OpenIntentFile open file or files.
// *.b64 is base64 encoded.
// *.ipfs is fetched from ipfs network.
// ipfs file is of toml format:
//   [[Ipfs]]
//   Path = "Qmxxx..xA"
//   Base64 = true
//
//   [[Ipfs]]
//   Path = "Qmxxx..xB"
func (n *Node) OpenIntentFile(dir, name string) ([]io.ReadCloser, error) {
	rcs, err := n.openIntentFile(dir, name)
	if err != nil && rcs != nil {
		for _, rc := range rcs {
			rc.Close()
		}
		return nil, err
	}
	return rcs, err
}

func (n *Node) openIntentFile(dir, name string) ([]io.ReadCloser, error) {
	path := filepath.Join(dir, name)
	ext := filepath.Ext(name)

	f, err := os.Open(path)
	if err != nil {
		n.log.Error("os.Open", zap.Error(err))
		return nil, err
	}

	if ext == ".ipfs" {
		defer f.Close()
		var itfs IpfsTomlFiles
		err = tc.NewDecoder(f).Decode(&itfs)
		if err != nil {
			n.log.Error("decode toml", zap.Error(err))
			return nil, err
		}

		rcs := make([]io.ReadCloser, 0, len(itfs.Ipfs))
		for _, itf := range itfs.Ipfs {
			fnode, err := n.ipfs.Get(context.Background(), itf.Path)
			if err != nil {
				n.log.Error("ipfs.Get", zap.String("path", itf.Path), zap.Error(err))
				return rcs, err
			}

			uf, ok := fnode.(files.File)
			if !ok {
				uf.Close()
				n.log.Error("ipfs path is dir", zap.String("path", itf.Path))
				return rcs, os.ErrNotExist
			}

			rcs = append(rcs, toReadCloser(uf, itf.Base64))
		}
		return rcs, nil
	}

	return []io.ReadCloser{toReadCloser(f, ext == ".b64")}, nil
}

func toReadCloser(rc io.ReadCloser, b64 bool) io.ReadCloser {
	if b64 {
		return &readCloser{
			Reader: base64.NewDecoder(base64.StdEncoding, rc),
			Closer: rc,
		}
	}
	return rc
}
