package config

import (
	"errors"
	"fmt"
	"io/ioutil"
	"os"

	"github.com/caarlos0/env/v6"
	"github.com/creasty/defaults"
	version "github.com/hashicorp/go-version"
	"github.com/naoina/toml"
	validator "gopkg.in/go-playground/validator.v9"
)

// TODO Need add config version migration func

const (
	ConfigVersion           = "1"
	ConfigVersionConstraint = "=1"
)

const (
	LoadTagEnv int = 1 << iota
	LoadTagDefault
	LoadTagCheckVersion
	LoadTagValidate

	// LoadTagsDefault used to start the node.
	LoadTagsDefault = LoadTagEnv | LoadTagDefault | LoadTagCheckVersion | LoadTagValidate

	// LoadTagsRead used to read raw config content.
	LoadTagsRead = 0

	// LoadTagsNoErr likes LoadTagsDefault without any validations.
	LoadTagsNoErr = LoadTagEnv | LoadTagDefault
)

var ErrNoVersion = errors.New("no Basic.Version found")

func LoadConfig(tree *ConfigTree, tags int, c *Config) (*Config, error) {
	var err error
	if tree == nil {
		tree, err = NewDefaultTree()
		if err != nil {
			return nil, err
		}
	}

	if c == nil {
		c = new(Config)
	}

	// 1. load env
	if tags&LoadTagEnv != 0 {
		err = env.Parse(c)
		if err != nil {
			return nil, err
		}
	}

	// 2. load default
	if tags&LoadTagDefault != 0 {
		err = defaults.Set(c)
		if err != nil {
			return nil, err
		}
	}

	_, err = os.Stat(tree.ConfigPath)
	if err != nil {
		return nil, err
	}

	configContent, err := ioutil.ReadFile(tree.ConfigPath)
	if err != nil {
		return nil, err
	}

	tt, err := toml.Parse(configContent)
	if err != nil {
		return nil, err
	}

	// 3. check config version
	if tags&LoadTagCheckVersion != 0 {
		ver, err := version.NewVersion(readVersion(tt))
		if err != nil {
			return nil, err
		}

		constraints, err := version.NewConstraint(ConfigVersionConstraint)
		if err != nil {
			return nil, err
		}

		if !constraints.Check(ver) {
			return nil, fmt.Errorf("Current config version is v%s, need version '%s', but got v%s",
				ConfigVersion, ConfigVersionConstraint, ver)
		}
	}

	// 4. unmarshal toml
	err = tc.UnmarshalTable(tt, c)
	if err != nil {
		return nil, err
	}

	// 5. do struct validate
	if tags&LoadTagValidate != 0 {
		validate := validator.New()
		err = validate.Struct(c)
		if err != nil {
			return nil, err
		}
	}

	return c, nil
}
