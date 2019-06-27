package main

import (
	"encoding/hex"
	"flag"
	"fmt"
	"log"
	"strings"

	"golang.org/x/crypto/ed25519"
)

var seedHex = flag.String("seed", "", "private seed in hex, generate new key pair if not set")

func main() {
	flag.Parse()

	if *seedHex == "" {
		_, privkey, err := ed25519.GenerateKey(nil)
		if err != nil {
			log.Fatal(err)
		}
		printJson(privkey)
		return
	}

	seed, err := hex.DecodeString(*seedHex)
	if err != nil {
		log.Fatal(err)
	}
	if len(seed) != ed25519.SeedSize {
		log.Fatalf("seed should be a 64 size hex, but got %d", len(seed))
	}

	privkey := ed25519.NewKeyFromSeed(seed)
	printJson(privkey)
}

func printJson(privkey ed25519.PrivateKey) {
	pubkey := privkey.Public()
	fmt.Printf(`{
  "Seed": "%x",
  "Pubkey": "%x"
}
`, privkey.Seed(), pubkey)
}

func literal(b []byte) string {
	var sb strings.Builder
	for _, o := range b {
		sb.WriteString(fmt.Sprintf(`\x%02x`, o))
	}
	return sb.String()
}
