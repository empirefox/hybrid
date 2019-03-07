package config

import (
	"os"
	"path/filepath"

	"github.com/BurntSushi/toml"
	"github.com/caarlos0/env"
	"github.com/creasty/defaults"
	"github.com/golang/protobuf/proto"
	validator "gopkg.in/go-playground/validator.v9"
)

func SaveConfig(rootPath string, c *Config) error {
	if rootPath == "" {
		homedir, err := os.UserHomeDir()
		if err != nil {
			return err
		}
		rootPath = filepath.Join(homedir, ".hybrid")
	}

	c.SetTree(nil)
	err := c.InitTree(rootPath)
	if err != nil {
		return err
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

	err = os.MkdirAll(c.Tree().RootPath, 0666)
	if err != nil {
		return err
	}

	out, err := os.Create(c.Tree().ConfigPath)
	if err != nil {
		return err
	}
	defer out.Close()

	tosave.Basic.Version = ConfigVersion
	return toml.NewEncoder(out).Encode(tosave)
}
