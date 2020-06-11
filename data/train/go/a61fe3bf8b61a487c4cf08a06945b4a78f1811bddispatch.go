package configanywhere

import (
	"errors"
	
	"github.com/MatthewJWalls/configanywhere/formats"
	"github.com/MatthewJWalls/configanywhere/providers"	
)

// Dispatch and the convenience methods in this file
// allow us to support an API in the short format:
//
//     configanywhere.Json(xs).FromFile(ys)
//
// which due to Go's lack of support for Traits means
// we have to do this somewhat clumsily as below.

type Provider interface {
	GetBytes() ([]byte, error)
}

type Format interface {
	Using([]byte)
}

type Dispatch struct {
	F Format
}

// Convenience methods for providers

func (this Dispatch) FromProvider(p Provider) error {
	
	bytes, err := p.GetBytes()

	if err == nil {
		this.F.Using(bytes)
	}

	return err
	
}

func (this Dispatch) FromFile(filename string) error {
	return this.FromProvider(providers.NewFileProvider(filename))
}

func (this Dispatch) FromZookeeper(servers []string, nodePath string) error {
	return this.FromProvider(providers.NewZookeeperProvider(servers, nodePath))
}

func (this Dispatch) FromString(text string) error {
	return this.FromProvider(providers.NewStringProvider(text))
}

func (this Dispatch) FromEnvironment() error {
	return this.FromProvider(providers.NewEnvironmentProvider())
}

// convenience methods for formats

func Json(target interface{}) Dispatch {
	return Dispatch{ formats.NewJsonFormat(target) }
}

func KeyValue(target interface{}) Dispatch {
	return Dispatch{ formats.NewKeyValueFormat(target) }
}

func XML(target interface{}) Dispatch {
	return Dispatch{ formats.NewXMLFormat(target) }
}

func Yaml(target interface{}) Dispatch {
	return Dispatch{ formats.NewYamlFormat(target) }
}

// other utils

func (this Dispatch) Choose(providers ...Provider) error {

	for _, p := range providers {

		if bytes, err := p.GetBytes(); err == nil {
			this.F.Using(bytes)
			return nil
		} else {
			continue
		}
	}

	return errors.New("All providers returned an error")

}
