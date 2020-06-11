package jlog

import (
	"reflect"
)

var (
	defaultManager *Manager
)

func createDefaultManager() {
	var err error
	defaultManager, err = NewManager(LoadConfig(""))

	if err != nil {
		panic(err)
	}
}

func ApplyConfig(cfg *Config) error {
	if defaultManager == nil {
		createDefaultManager()
	}
	return defaultManager.ApplyConfig(cfg)
}

func ReloadConfig() error {
	if defaultManager == nil {
		createDefaultManager()
	}
	return defaultManager.ReloadConfig()
}

func GetNamedLogger(name string) *logger {
	if defaultManager == nil {
		createDefaultManager()
	}
	return defaultManager.GetNamedLogger(name)
}

func GetPackageLogger() *logger {
	if defaultManager == nil {
		createDefaultManager()
	}
	return defaultManager.getPackageLoggerSkip(3)
}

func GetObjectLogger(obj interface{}) *logger {
	if defaultManager == nil {
		createDefaultManager()
	}
	return defaultManager.GetObjectLogger(obj)
}

func GetTypeLogger(t reflect.Type) *logger {
	if defaultManager == nil {
		createDefaultManager()
	}
	return defaultManager.GetTypeLogger(t)
}
