package sm_yamux

import (
	"testing"

	test "github.com/empirefox/hybrid/pkg/ipfs/ipfs-6-to-7/gx/ipfs/QmY9JXR3FupnYAYJWK9aMr9bCpqWKcToQ1tz8DVGTrHpHw/go-stream-muxer/test"
)

func TestYamuxTransport(t *testing.T) {
	test.SubtestAll(t, DefaultTransport)
}
