package main

import (
	"crypto/sha256"
	"encoding/base64"
	"fmt"
)

// Key : key
func Key(category string, typ string) string {
	sha := sha256.New()
	sha.Write([]byte(category))
	sha.Write([]byte(typ))
	sha.Write([]byte("ga:x"))
	sha.Write([]byte(":"))
	sha.Write([]byte("search"))
	sha.Write([]byte("ga:y"))
	sha.Write([]byte(":"))
	sha.Write([]byte("yahoo"))
	sha.Write([]byte("ga:z"))
	sha.Write([]byte(":"))
	sha.Write([]byte("yahoo_camp_ydn"))
	return base64.URLEncoding.EncodeToString(sha.Sum(nil))
}

func main() {
	fmt.Println(Key("paidSearch", "gaDimensions"))
}
