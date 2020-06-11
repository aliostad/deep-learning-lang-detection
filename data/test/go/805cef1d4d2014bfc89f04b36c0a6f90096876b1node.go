package base

import (
	"crypto/ecdsa"

	"encoding/json"

	"github.com/ineiti/cybermind/broker"
	"gopkg.in/dedis/onet.v1/log"
)

/*
A node runs on a device and has its own configuration.
*/

const ModuleNode = "Node"

type Node struct {
	Name string
	// Address might change once in a while
	Address string
	Private ecdsa.PrivateKey
	broker  *broker.Broker
}

func RegisterNode(b *broker.Broker) error {
	err := b.RegisterModule(ModuleNode, NewNode)
	if err != nil {
		return err
	}
	//return b.SpawnModule()
	return nil
}

func NewNode(b *broker.Broker, id broker.ModuleID, msg *broker.Message) broker.Module {
	node := &Node{
		broker: b,
	}
	config := msg.Tags.GetLastValue(ConfigData)
	log.ErrFatal(json.Unmarshal([]byte(config.Value), node))
	//var err error
	//_, node.Private, err = ed25519.GenerateKey(nil)
	//log.ErrFatal(err)
	b.BroadcastMessage(&broker.Message{
		Tags: broker.Tags{},
	})
	return node
}

func (n *Node) ProcessMessage(m *broker.Message) ([]broker.Message, error) {
	if m == nil {
		return nil, nil
	}
	if m.Action.Command == "config" {
	}
	return nil, nil
}
