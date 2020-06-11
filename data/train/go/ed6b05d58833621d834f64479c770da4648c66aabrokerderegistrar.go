package pmysql

import (
	"strings"

	"github.com/enaml-ops/enaml"
	"github.com/enaml-ops/omg-product-bundle/products/p-mysql/enaml-gen/broker-deregistrar"
)

func NewBrokerDeRegistrar(plgn *Plugin) *enaml.InstanceGroup {
	return &enaml.InstanceGroup{
		Name:      "broker-deregistrar",
		Lifecycle: "errand",
		Instances: 1,
		VMType:    plgn.VMTypeName,
		AZs:       plgn.AZs,
		Stemcell:  StemcellAlias,
		Jobs: []enaml.InstanceJob{
			newBrokerDeRegistrarJob(plgn),
		},
		Networks: []enaml.Network{
			enaml.Network{
				Name:    plgn.NetworkName,
				Default: []interface{}{"dns", "gateway"},
			},
		},
		Update: enaml.Update{
			MaxInFlight: 1,
		},
	}
}

func newBrokerDeRegistrarJob(plgn *Plugin) enaml.InstanceJob {
	return enaml.InstanceJob{
		Name:    "broker-deregistrar",
		Release: CFMysqlReleaseName,
		Properties: &broker_deregistrar.BrokerDeregistrarJob{
			Cf: &broker_deregistrar.Cf{
				ApiUrl:            strings.Join([]string{"https://api", "sys", plgn.BaseDomain}, "."),
				AdminUsername:     registrarUser,
				AdminPassword:     plgn.CFAdminPassword,
				SkipSslValidation: true,
			},
			Broker: &broker_deregistrar.Broker{
				Name: "p-mysql",
			},
		},
	}
}
