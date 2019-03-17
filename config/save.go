package config

import (
	"os"

	"github.com/BurntSushi/toml"
	"github.com/caarlos0/env"
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

	err = os.MkdirAll(tree.RootPath, 0666)
	if err != nil {
		return err
	}

	out, err := os.Create(tree.ConfigPath)
	if err != nil {
		return err
	}
	defer out.Close()

	tosave.Basic.Version = ConfigVersion
	return toml.NewEncoder(out).Encode(tosave)
}
