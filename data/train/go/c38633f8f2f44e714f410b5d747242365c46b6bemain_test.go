package main

import (
	"os"
	"testing"

	"github.com/bmizerany/assert"
	"github.com/spf13/viper"
)

func TestConfig(t *testing.T) {
	assert.Equal(t, viper.AllSettings(), map[string]interface{}{
		"debug":         false,
		"addr":          "localhost:5002",
		"neo4j":         "http://localhost:7474/db/data/",
		"email_from":    "noreply@example.com",
		"smtp_addr":     "localhost:25",
		"smtp_user":     "",
		"smtp_password": "",
	})
}

func TestEnvConfig(t *testing.T) {
	os.Setenv("ORIGINS_DISPATCH_ADDR", "localhost:5003")
	os.Setenv("ORIGINS_DISPATCH_DEBUG", "1")

	assert.Equal(t, viper.GetString("addr"), "localhost:5003")
	assert.Equal(t, viper.GetBool("debug"), true)
}
