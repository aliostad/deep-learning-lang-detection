package main

import (
	"os"
	"testing"
)

func TestDefaultConfigs(t *testing.T) {
	os.Setenv("BROKER_USERNAME", "broker")
	os.Setenv("BROKER_PASSWORD", "password")
	os.Unsetenv("PORT")
	os.Unsetenv("LOG_LEVEL")

	config, err := brokerConfigLoad()
	if err != nil {
		t.Error("Error loading config: ", err.Error())
	}

	if config.BrokerPassword != "password" {
		t.Error("Expected BROKER_PASSWORD to be 'password' but got: " + config.BrokerPassword)
	}

	if config.BrokerPassword != "password" {
		t.Error("Expected BROKER_USERNAME to be 'broker' but got: " + config.BrokerUsername)
	}

	if config.Port != "3000" {
		t.Error("Expected default PORT to be 3000 but got:" + config.Port)
	}

	if config.LogLevel != "INFO" {
		t.Error("Expected default LOG_LEVEL to be INFO but got:" + config.LogLevel)
	}
}

func TestRequiredUsername(t *testing.T) {
	os.Unsetenv("BROKER_USERNAME")
	os.Setenv("BROKER_PASSWORD", "password")

	_, err := brokerConfigLoad()
	if err == nil {
		t.Error("No error was thrown while required config BROKER_USERNAME was not set.")
	}
}

func TestRequiredPassword(t *testing.T) {
	os.Setenv("BROKER_USERNAME", "broker")
	os.Unsetenv("BROKER_PASSWORD")

	_, err := brokerConfigLoad()
	if err == nil {
		t.Error("No error was thrown while required config BROKER_USERNAME was not set.")
	}
}
