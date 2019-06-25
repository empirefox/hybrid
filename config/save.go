package config

import (
	"os"

	"github.com/caarlos0/env/v6"
	"github.com/creasty/defaults"
	"github.com/golang/protobuf/proto"
	validator "gopkg.in/go-playground/validator.v9"
)

func SaveConfig(tree *ConfigTree, c *Config) error {
	var err error
	if tree == nil {
		tree, err = NewDefaultTree()
		if err != nil {
			return err
		}
	}

	tosave := proto.Clone(c).(*Config)

	// 1. load env
	err = env.Parse(c)
	if err != nil {
		return err
	}

	// 2. load default
	err = defaults.Set(c)
	if err != nil {
		return err
	}

	// 3. do struct validate
	validate := validator.New()
	err = validate.Struct(c)
	if err != nil {
		return err
	}

	// 0700 is ok for android
	err = os.MkdirAll(tree.RootPath, 0700)
	if err != nil {
		return err
	}

	// 0701 is ok for android
	out, err := os.OpenFile(tree.ConfigPath, os.O_WRONLY|os.O_CREATE|os.O_TRUNC, 0701)
	if err != nil {
		return err
	}
	defer out.Close()

	tosave.Basic.Version = ConfigVersion
	return tc.NewEncoder(out).Encode(tosave)
}
