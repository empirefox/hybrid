package table

import (
	"testing"

	"github.com/empirefox/hybrid/pkg/ipfs/ipfs-6-to-7/gx/ipfs/QmbBhyDKsY4mbY6xsKt3qu9Y7FPvMJ6qbD8AMjYYvPRw1g/goleveldb/leveldb/testutil"
)

func TestTable(t *testing.T) {
	testutil.RunSuite(t, "Table Suite")
}
