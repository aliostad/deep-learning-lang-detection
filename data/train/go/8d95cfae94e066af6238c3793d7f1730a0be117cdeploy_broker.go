package pscs

import (
	"github.com/enaml-ops/enaml"
	"github.com/enaml-ops/omg-product-bundle/products/p-scs/enaml-gen/deploy-service-broker"
)

func NewDeployServiceBroker(c *Config) *enaml.InstanceGroup {
	return &enaml.InstanceGroup{
		Name:      "deploy-service-broker",
		Instances: 1,
		Stemcell:  StemcellAlias,
		VMType:    c.VMType,
		AZs:       c.AZs,
		Lifecycle: "errand",
		Networks: []enaml.Network{
			{Name: c.Network, Default: []interface{}{"dns", "gateway"}},
		},
		Jobs: []enaml.InstanceJob{
			{
				Name:    "deploy-service-broker",
				Release: SpringCloudBrokerReleaseName,
				Properties: &deploy_service_broker.DeployServiceBrokerJob{
					Domain:     c.SystemDomain,
					AppDomains: c.AppDomains,
					Ssl: &deploy_service_broker.Ssl{
						SkipCertVerify: c.SkipSSLVerify,
					},
					SpringCloudBroker: &deploy_service_broker.SpringCloudBroker{
						Broker: &deploy_service_broker.Broker{
							User:         c.BrokerUsername,
							Password:     c.BrokerPassword,
							MaxInstances: 100,
						},
						Worker: &deploy_service_broker.Worker{
							ClientSecret: c.WorkerClientSecret,
							User:         "admin",
							Password:     c.WorkerPassword,
						},
						Instances: &deploy_service_broker.Instances{
							InstancesUser:     "p-spring-cloud-services",
							InstancesPassword: c.InstancesPassword,
						},
						AppPush: &deploy_service_broker.AppPush{
							Timeout: 180,
						},
						BrokerDashboardSecret: c.BrokerDashboardSecret,
						EncryptionKey:         c.EncryptionKey,
						Cf: &deploy_service_broker.Cf{
							AdminUser:     "admin",
							AdminPassword: c.CFAdminPassword,
						},
						Uaa: &deploy_service_broker.SpringCloudBrokerUaa{
							AdminClientId:     "admin",
							AdminClientSecret: c.UAAAdminClientSecret,
						},
					},
				},
			},
		},
	}
}
