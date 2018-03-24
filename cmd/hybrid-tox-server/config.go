package main

import (
	"encoding/json"
	"io/ioutil"
	"os"

	"github.com/caarlos0/env"
	defaults "github.com/mcuadros/go-defaults"
	validator "gopkg.in/go-playground/validator.v9"
)

// tox-account
//{
//  "Address": "8FD5F4939584F3D56EAA15113483FE5F91CC5ACAE1CEBCFB63F771C9CE16E83201676F096037",
//  "Secret": "9421F0FC2E2D08D8250D8EAE551AAB6151B8948457B0D29CD21565853F0898F2",
//  "Pubkey": "8FD5F4939584F3D56EAA15113483FE5F91CC5ACAE1CEBCFB63F771C9CE16E832",
//  "Nospam": 23555849
//}

// hybrid-issuer
//ed25519 PrivateKey: ffa8b9066badac5d416b68132d6da5efbb495713ddc672b62e598919944faaebff1bc7523faa933eb936d7f127188b50894271b94e15a9e97d51516e1b06b6c6
//ed25519 PublicKey: ff1bc7523faa933eb936d7f127188b50894271b94e15a9e97d51516e1b06b6c6

type Verifier [32]byte

func (v *Verifier) VerifyKey(id uint32) ([]byte, bool) { return v[:], true }
func (v *Verifier) Revoked(id []byte) bool             { return false }

type Config struct {
	SecretHex    string `validate:"len=64,hexadecimal"`
	Nospam       uint32 `validate:"required"`
	VerifyKeyHex string `validate:"len=64,hexadecimal"`
	Config       string `env:"HYBRID_TOX_SERVER_CONFIG" validate:"required" default:"$HOME/.hybrid/tox-server.json" json:"-" yaml:"-" toml:"-"`
	Dev          bool   `env:"HYBRID_TOX_SERVER_DEV"`
}

func LoadConfig() (*Config, error) {
	c := new(Config)
	err := env.Parse(c)
	if err != nil {
		return nil, err
	}

	defaults.SetDefaults(c)

	configContent, err := ioutil.ReadFile(os.ExpandEnv(c.Config))
	if err != nil {
		return nil, err
	}

	err = json.Unmarshal(configContent, c)
	if err != nil {
		return nil, err
	}

	validate := validator.New()
	err = validate.Struct(c)
	if err != nil {
		return nil, err
	}

	return c, nil
}
