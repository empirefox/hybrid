package ipfs

import (
	"fmt"
	"io/ioutil"
	"strconv"
	"sync"

	mg6 "github.com/empirefox/hybrid/pkg/ipfs/ipfs-6-to-7/migration"
	gomigrate "github.com/ipfs/fs-repo-migrations/go-migrate"
	mg0 "github.com/ipfs/fs-repo-migrations/ipfs-0-to-1/migration"
	mg1 "github.com/ipfs/fs-repo-migrations/ipfs-1-to-2/migration"
	mg2 "github.com/ipfs/fs-repo-migrations/ipfs-2-to-3/migration"
	mg3 "github.com/ipfs/fs-repo-migrations/ipfs-3-to-4/migration"
	mg4 "github.com/ipfs/fs-repo-migrations/ipfs-4-to-5/migration"
	mg5 "github.com/ipfs/fs-repo-migrations/ipfs-5-to-6/migration"
	mfsr "github.com/ipfs/fs-repo-migrations/mfsr"
	"github.com/ipfs/fs-repo-migrations/stump"
	"github.com/ipfs/go-ipfs/repo/fsrepo"
)

var migrations = []gomigrate.Migration{
	&mg0.Migration{},
	&mg1.Migration{},
	&mg2.Migration{},
	&mg3.Migration{},
	&mg4.Migration{},
	&mg5.Migration{},
	&mg6.Migration{},
}

var migrationMu sync.Mutex

func init() {
	if len(migrations) != fsrepo.RepoVersion {
		panic("Migration version must eq fsrepo.RepoVersion")
	}
	stump.LogOut = ioutil.Discard
	stump.ErrOut = ioutil.Discard
}

// MigrateDirectly require hack on:
// github.com/empirefox/hybrid/pkg/ipfs/ipfs-6-to-7
func MigrateDirectly(repoPath string, to int) error {
	migrationMu.Lock()
	defer migrationMu.Unlock()

	if to > len(migrations) {
		return fmt.Errorf("Unknown migration to version %d", to)
	}

	from, err := GetRepoVersion(repoPath)
	if err != nil {
		return err
	}

	for cur := from; cur < to; cur++ {
		err = doMigrateOneStep(repoPath, cur)
		if err != nil {
			return err
		}
	}
	return nil
}

func GetRepoVersion(repoPath string) (int, error) {
	ver, err := mfsr.RepoPath(repoPath).Version()
	if _, ok := err.(mfsr.VersionFileNotFound); ok {
		// No version file in repo == version 0
		return 0, nil
	}

	if err != nil {
		return 0, err
	}

	vnum, err := strconv.Atoi(ver)
	if err != nil {
		return 0, err
	}

	return vnum, nil
}

// doMigrateOneStep migrate n => n+1
func doMigrateOneStep(repoPath string, n int) error {
	opts := gomigrate.Options{}
	opts.Path = repoPath
	opts.Verbose = true

	err := migrations[n].Apply(opts)
	if err != nil {
		return fmt.Errorf("migration %d to %d failed: %s", n, n+1, err)
	}
	return nil
}
