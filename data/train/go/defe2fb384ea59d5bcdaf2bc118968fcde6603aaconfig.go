package base

import (
	"bytes"

	"fmt"

	"github.com/ineiti/cybermind/broker"
	"gopkg.in/dedis/onet.v1/log"
)

const ModuleConfig = "config"

var ModuleIDConfig = []byte{0, 0, 0, 0}

var ConfigSpawn = broker.SubDomain("spawn", "config")
var ConfigData = broker.SubDomain("data", "config")
var ConfigModule = broker.SubDomain("module", "config")

type Config struct {
	Broker *broker.Broker
}

func RegisterConfig(b *broker.Broker) error {
	err := b.RegisterModule(ModuleConfig, NewConfig)
	if err != nil {
		return err
	}
	_, err = b.SpawnModule(ModuleConfig, ModuleIDConfig, nil)
	return err
}

func NewConfig(b *broker.Broker, id broker.ModuleID, msg *broker.Message) broker.Module {
	return &Config{
		Broker: b,
	}
}

func (c *Config) ProcessMessage(m *broker.Message) ([]broker.Message, error) {
	if m == nil {
		log.Lvl2("Reading config and spawning modules")
		msg := StorageSearchObject(broker.NewKeyValue("module_id", fmt.Sprintf("X'%x'", ModuleIDConfig)))
		err := c.Broker.BroadcastMessage(&msg)
		if err != nil {
			return nil, err
		}
	} else {
		log.Lvl3("Got message", m)
		if m.Action.Command == ConfigSpawn {
			err := c.ConfigSpawn(m)
			if err != nil {
				return nil, err
			}
		} else {
			c.SpawnModules(m.Objects)
		}
	}
	return nil, nil
}

func (c *Config) ConfigSpawn(msg *broker.Message) error {
	obj := broker.NewObject(ModuleIDConfig, broker.NewModuleID())
	obj.Tags = broker.Tags{broker.NewTag(ConfigData, msg.Action.Arguments["config"]),
		broker.NewTag(ConfigModule, msg.Action.Arguments["module"])}
	newMsg := &broker.Message{
		ID:      broker.NewMessageID(),
		Objects: []broker.Object{*obj},
	}
	log.Lvl2("Processing stored configuration-message:", newMsg)
	return c.Broker.BroadcastMessage(newMsg)
}

func (c *Config) SpawnModules(objs []broker.Object) {
	for _, obj := range objs {
		if bytes.Compare(obj.ModuleID, ModuleIDConfig) == 0 {
			module := obj.Tags.GetLastValue(ConfigModule)
			if module != nil {
				log.Lvl2("Spawning new module", module)
				msg := &broker.Message{
					ID:   broker.NewMessageID(),
					Tags: broker.Tags{*obj.Tags.GetLastValue(ConfigData)},
				}
				m, err := c.Broker.SpawnModule(module.Value, obj.Data, msg)
				if err != nil {
					log.Error("While spawning module", msg, err)
				} else {
					msgs, err := m.ProcessMessage(nil)
					if err != nil {
						log.Error("Couldn't process nil-message", err)
					} else {
						if err := c.Broker.BroadcastMessages(msgs); err != nil {
							log.Error("Broadcasting messages:", err, msgs)
						}
					}
				}
			}
		}
	}
}

func SpawnModule(b *broker.Broker, module, config string) error {
	return b.BroadcastMessage(&broker.Message{
		ID: broker.NewMessageID(),
		Action: broker.Action{
			Command: ConfigSpawn,
			Arguments: map[string]string{
				"module": module,
				"config": config,
			},
		},
	})
}
