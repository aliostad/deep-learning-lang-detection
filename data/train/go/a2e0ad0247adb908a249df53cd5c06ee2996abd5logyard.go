package logyard

import (
	"github.com/hpcloud/log"
	"github.com/hpcloud/zmqpubsub"
	"os"
)

var Broker zmqpubsub.Broker

func init() {
	Broker.PubAddr = "ipc:///var/stackato/run/logyardpub.sock"
	Broker.SubAddr = "ipc:///var/stackato/run/logyardsub.sock"
	Broker.BufferSize = 100

	// ZeroMQ will silently fail if .sock files can't be created
	if _, err := os.Stat("/var/stackato/run"); err != nil {
		log.Errorf("Cannot access /var/stackato/run: %v", err)
	}

	log.Infof("Loygard broker config: %+v\n", Broker)
}
