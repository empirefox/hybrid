package config

import (
	"fmt"
	"io/ioutil"
	"os"

	"github.com/BurntSushi/toml"
	"github.com/caarlos0/env"
	"github.com/creasty/defaults"
	version "github.com/hashicorp/go-version"
	"github.com/tidwall/gjson"
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
	if tags&LoadTagEnv == 1 {
		err = env.Parse(c)
		if err != nil {
			return nil, err
		}
	}

	// 2. load default
	if tags&LoadTagDefault == 1 {
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

	// 3. check config version
	if tags&LoadTagCheckVersion == 1 {
		ver, err := version.NewVersion(gjson.GetBytes(configContent, "Version").String())
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
	err = toml.Unmarshal(configContent, c)
	if err != nil {
		return nil, err
	}

	// 5. do struct validate
	if tags&LoadTagValidate == 1 {
		validate := validator.New()
		err = validate.Struct(c)
		if err != nil {
			return nil, err
		}
	}

	return c, nil
}
