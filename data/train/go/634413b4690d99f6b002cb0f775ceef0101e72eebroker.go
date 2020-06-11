package broker

import (
	"github.com/micro/go-micro/broker"

	// "github.com/neverlee/xclog/go"

	"github.com/neverlee/microframe/config"
	"github.com/neverlee/microframe/pluginer"
	"github.com/neverlee/microframe/service"
)

type brokerConf struct {
	Broker  string   `yaml:"broker"`
	Address []string `yaml:"address"`
}

type brokerPlugin struct {
	pluginer.SrvPluginBase
	conf brokerConf
}

func NewPlugin(pconf *config.RawYaml) (pluginer.SrvPluginer, error) {
	p := &brokerPlugin{
		SrvPluginBase: pluginer.SrvPluginBase{
			Phase: pluginer.BasePhase,
		},
		conf: brokerConf{
			Address: nil,
		},
	}
	if err := pconf.Decode(&p.conf); err != nil {
		return nil, err
	}

	return p, nil
}

func (p *brokerPlugin) Preinit(s *service.Service) error {
	conf := p.conf

	// Set the broker
	// broker: # Broker for pub/sub. http, nats, rabbitmq
	switch conf.Broker {
	default:
		s.Broker = broker.NewBroker(broker.Addrs(conf.Address...))
		// return errors.New("No such selector " + conf.Selector)
	}

	return nil
}
