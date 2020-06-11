package orchestrator

import (
	"errors"
	"path/filepath"
)

// ---------------------------------------------------------------------------------
// BrokerRegistry
// ---------------------------------------------------------------------------------

// BrokerRegistry keeps references to all registered plugin brokers.
type BrokerRegistry []*PluginBroker

// NewBrokerRegistry returns an empty initialized registry
func NewBrokerRegistry() *BrokerRegistry {
	return &BrokerRegistry{}
}

// RegisterBroker takes the file system path to a plugin, initializes a new plugin broker and
// adds the broker to the registry itself.
func (r *BrokerRegistry) RegisterBroker(plugin string) error {
	name := filepath.Base(plugin)
	for _, b := range *r {
		if b.Name == name {
			return errors.New("Broker of plugin '" + name + "' is already registered, plugin '" + plugin + "' not registered. ")
		}
	}
	b, _ := NewPluginBroker(name, plugin)
	*r = append(*r, b)
	return nil
}

// GetBrokerByName finds a registred plugin broker by its name.
func (r *BrokerRegistry) GetBrokerByName(name string) *PluginBroker {
	for _, b := range *r {
		if b.Name == name {
			return b
		}
	}
	return nil
}
