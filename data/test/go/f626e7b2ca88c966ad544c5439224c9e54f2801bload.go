package load

import (
	"crypto/rsa"
	"encoding/gob"
	"log"
	"os"
)

func LoadFile(fileName string, loadTo interface{}) error {
	keyFile, err := os.Open(fileName)
	defer keyFile.Close()
	if err != nil {
		log.Println("ERROR: load.LoadFile reading: ", err)
		return err
	}

	decoder := gob.NewDecoder(keyFile)
	err = decoder.Decode(loadTo)
	if err != nil {
		log.Println("ERROR: load.LoadFile decoding: ", err)
		return err
	}
	return nil
}

func LoadPrivate(fileName string) (*rsa.PrivateKey, error) {
	var privateKey rsa.PrivateKey
	err := LoadFile(fileName, &privateKey)
	if err != nil {
		log.Println("ERROR: load.LoadPrivate while loading file: ", err)
		return nil, err
	}
	return &privateKey, nil
}

func LoadPublic(fileName string) (*rsa.PublicKey, error) {
	var publicKey rsa.PublicKey
	err := LoadFile(fileName, &publicKey)
	if err != nil {
		log.Println("ERROR: load.LoadPublic while loading file: ", err)
		return nil, err
	}
	return &publicKey, nil
}
