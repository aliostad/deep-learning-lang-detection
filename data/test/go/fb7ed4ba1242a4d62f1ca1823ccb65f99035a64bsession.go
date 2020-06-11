package session

import (
	"errors"
	"github.com/simbory/mego/assert"
)

var defaultManager *Manager

// UseAsDefault use the given session manager as the default
func UseAsDefault(manager *Manager) {
	assert.NotNil("manager", manager)
	defaultManager = manager
}

func CreateManager(config *Config, provider Provider) *Manager {
	assert.NotNil("provider", provider)
	if config == nil {
		config = new(Config)
		config.HTTPOnly = true
	}
	if len(config.CookieName) == 0 {
		config.CookieName = "SESSION_ID"
	}
	if config.GcLifetime <= 0 {
		config.GcLifetime = 3600
	}
	if config.MaxLifetime <= 0 {
		config.MaxLifetime = 3600
	}
	if len(config.CookiePath) == 0 {
		config.CookiePath = "/"
	}

	if config.MaxLifetime < config.GcLifetime {
		config.MaxLifetime = config.GcLifetime
	}
	config.EnableSetCookie = true

	m := &Manager{
		provider:  provider,
		config:    config,
		managerID: newGuidStr(),
	}
	return m
}

func Default() *Manager {
	if defaultManager == nil {
		panic(errors.New("You need to call UseDefault() first when you get the default session manager"))
	}
	return defaultManager
}
