// Copyright 2015 The PowerUnit Authors. All rights reserved.
// Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

// Package config ...
package config

import (
	"fmt"

	"github.com/powerunit-io/platform/utils"
)

// ConfigManagers -
var ConfigManager map[string]interface{}

// ConfigManagerExists -
func ConfigManagerExists(manager string) bool {
	return utils.KeyInSlice(manager, ConfigManager)
}

// GetConfigManager - Will retreive config back in case it's discovered. If not
// error will be returned.
func GetConfigManager(managerName string) (*Config, error) {

	if !ConfigManagerExists(managerName) {
		return nil, fmt.Errorf("Could not discover configuration (manager: %s). Forgot to load it?", managerName)
	}

	manager := ConfigManager[managerName].(Config)
	return &manager, nil
}

// SetConfigManager - Will create and assign new configuration manager based on
// provided name and cofiguration data
func SetConfigManager(managerName string, configData map[string]interface{}) (*Config, error) {
	if !ConfigManagerExists(managerName) {
		ConfigManager[managerName] = Config{
			Config: configData,
		}
	}

	return GetConfigManager(managerName)
}

// -----------------------------------------------------------------------------

// NewConfigManager -
func NewConfigManager(managerName string, configData map[string]interface{}) (*Config, error) {
	return SetConfigManager(managerName, configData)
}
