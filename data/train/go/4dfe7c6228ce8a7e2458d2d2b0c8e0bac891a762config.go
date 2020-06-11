package config

import (
	"os"

	"github.com/cloudfoundry-incubator/candiedyaml"
)

// Config overall configuration
type Config struct {
	BrokerConfiguration BrokerConfiguration `yaml:"pagerduty_service_broker"`
}

// BrokerConfiguration service broker specific configuration
type BrokerConfiguration struct {
	Token string `yaml:"token"`
}

// ParseConfig parse config file
func ParseConfig(path string) (Config, error) {
	file, err := os.Open(path)
	if err != nil {
		return Config{}, err
	}

	var decodedConfig Config
	if err := candiedyaml.NewDecoder(file).Decode(&decodedConfig); err != nil {
		return Config{}, err
	}
	return decodedConfig, nil
}
