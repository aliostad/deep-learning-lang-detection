package pscs

import (
	"github.com/enaml-ops/enaml"
	"github.com/enaml-ops/omg-product-bundle/products/p-scs/enaml-gen/destroy-service-broker"
)

func NewDestroyServiceBroker(c *Config) *enaml.InstanceGroup {
	return &enaml.InstanceGroup{
		Name:      "destroy-service-broker",
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
				Name:    "destroy-service-broker",
				Release: SpringCloudBrokerReleaseName,
				Properties: &destroy_service_broker.DestroyServiceBrokerJob{
					Domain: c.SystemDomain,
					Ssl: &destroy_service_broker.Ssl{
						SkipCertVerify: c.SkipSSLVerify,
					},
					SpringCloudBroker: &destroy_service_broker.SpringCloudBroker{
						Broker: &destroy_service_broker.Broker{
							User:     c.BrokerUsername,
							Password: c.BrokerPassword,
						},
						Worker: &destroy_service_broker.Worker{
							ClientSecret: c.WorkerClientSecret,
						},
						Instances: &destroy_service_broker.Instances{
							InstancesUser: "p-spring-cloud-services",
						},
						Cf: &destroy_service_broker.Cf{
							AdminUser:     "admin",
							AdminPassword: c.CFAdminPassword,
						},
						Uaa: &destroy_service_broker.Uaa{
							AdminClientId:     "admin",
							AdminClientSecret: c.UAAAdminClientSecret,
						},
					},
				},
			},
		},
	}
}
