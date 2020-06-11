package main

import "github.com/kelseyhightower/envconfig"

type BrokerConfig struct {
	BrokerUsername string `envconfig:"broker_username" required:"true"`
	BrokerPassword string `envconfig:"broker_password" required:"true"`
	LogLevel       string `envconfig:"log_level" default:"INFO"`
	Port           string `envconfig:"port" default:"3000"`
}

func brokerConfigLoad() (BrokerConfig, error) {
	var config BrokerConfig
	err := envconfig.Process("", &config)
	if err != nil {
		return BrokerConfig{}, err
	}
	return config, nil
}
