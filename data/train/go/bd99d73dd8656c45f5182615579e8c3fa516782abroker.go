// Package broker allows to get static data of a list of brokers defined in the brokers.json file.
// This data can be used e.g. to calculate order prices with github.com/MaximilianMeister/asset/order
package broker

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"os"
	"path/filepath"

	"github.com/shopspring/decimal"
)

// Broker contains static broker data
type Broker struct {
	Name           string          `json:"name"`
	BasicPrice     decimal.Decimal `json:"basic_price"`
	CommissionRate decimal.Decimal `json:"commission_rate"`
	MinRate        decimal.Decimal `json:"min_rate"`
	MaxRate        decimal.Decimal `json:"max_rate"`
}

// Brokers represents a map of all brokers and their static data
type Brokers map[string]Broker

// NewBrokers returns a map of type Brokers which contains all static broker data
// defined in brokers.json
func NewBrokers() (Brokers, error) {
	// please note that the static data can be outdated and does not contain all
	// brokers.
	// if your broker and it's rates are missing please add it, and don't hesitate
	// to send a pull request to https://github.com/MaximilianMeister/asset
	brokers := &Brokers{}
	path, err := filepath.Abs("../broker/broker.json")
	if err != nil {
		fmt.Printf("File path error: %v\n", err)
		os.Exit(1)
	}
	file, err := ioutil.ReadFile(path)
	if err != nil {
		fmt.Printf("File error: %v\n", err)
		os.Exit(1)
	}

	if err = json.Unmarshal(file, brokers); err != nil {
		return nil, err
	}

	return *brokers, nil
}

// IsBroker returns bool if broker is available
func IsBroker(brokerAlias string) error {
	register, err := NewBrokers()
	if err != nil {
		return err
	}

	for b := range register {
		if b == brokerAlias {
			return nil
		}
	}

	return &InvalidBrokerError{brokerAlias}
}

// FindBroker returns a Broker type with all static data about a single broker
func FindBroker(brokerAlias string) (Broker, error) {
	err := IsBroker(brokerAlias)
	if err != nil {
		return Broker{}, err
	}

	register, err := NewBrokers()
	if err != nil {
		return Broker{}, err
	}

	for b := range register {
		if b == brokerAlias {
			return register[b], nil
		}
	}

	return Broker{}, nil
}
