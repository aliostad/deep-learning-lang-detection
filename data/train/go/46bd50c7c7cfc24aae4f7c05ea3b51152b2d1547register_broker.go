package pscs

import (
	"github.com/enaml-ops/enaml"
	"github.com/enaml-ops/omg-product-bundle/products/p-scs/enaml-gen/register-service-broker"
)

func NewRegisterBroker(c *Config) *enaml.InstanceGroup {
	return &enaml.InstanceGroup{
		Name:      "register-service-broker",
		Instances: 1,
		Lifecycle: "errand",
		Stemcell:  StemcellAlias,
		VMType:    c.VMType,
		AZs:       c.AZs,
		Networks: []enaml.Network{
			{Name: c.Network, Default: []interface{}{"dns", "gateway"}},
		},
		Jobs: []enaml.InstanceJob{
			{
				Name:    "register-service-broker",
				Release: SpringCloudBrokerReleaseName,
				Properties: &register_service_broker.RegisterServiceBrokerJob{
					Domain:     c.SystemDomain,
					AppDomains: c.AppDomains,
					SpringCloudBroker: &register_service_broker.SpringCloudBroker{
						Broker: &register_service_broker.Broker{
							User:     c.BrokerUsername,
							Password: c.BrokerPassword,
						},
						Cf: &register_service_broker.Cf{
							AdminUser:     "admin",
							AdminPassword: c.CFAdminPassword,
						},
						Uaa: &register_service_broker.Uaa{
							AdminClientId:     "admin",
							AdminClientSecret: c.UAAAdminClientSecret,
						},
					},
					Ssl: &register_service_broker.Ssl{
						SkipCertVerify: c.SkipSSLVerify,
					},
				},
			},
		},
	}
}
