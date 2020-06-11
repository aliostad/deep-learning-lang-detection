package prabbitmq

import (
	"fmt"

	"github.com/enaml-ops/enaml"
	bd "github.com/enaml-ops/omg-product-bundle/products/p-rabbitmq/enaml-gen/broker-deregistrar"
)

func (p *Plugin) NewRabbitMQBrokerDeregistrar(c *Config) *enaml.InstanceGroup {
	return &enaml.InstanceGroup{
		Name:      "broker-deregistrar",
		Lifecycle: "errand",
		Instances: 1,
		VMType:    c.BrokerVMType,
		AZs:       c.AZs,
		Stemcell:  StemcellAlias,
		Networks: []enaml.Network{
			{
				Name:    c.Network,
				Default: []interface{}{"dns", "gateway"},
			},
		},
		Jobs: []enaml.InstanceJob{
			{
				Name:    "broker-deregistrar",
				Release: CFRabbitMQReleaseName,
				Properties: &bd.BrokerDeregistrarJob{
					Broker: &bd.Broker{
						Name: "p-rabbitmq",
					},
					Cf: &bd.Cf{
						ApiUrl:            fmt.Sprintf("https://api.%s", c.SystemDomain),
						AdminUsername:     "system_services",
						AdminPassword:     c.SystemServicesPassword,
						SkipSslValidation: c.SkipSSLVerify,
					},
				},
			},
		},
	}
}
