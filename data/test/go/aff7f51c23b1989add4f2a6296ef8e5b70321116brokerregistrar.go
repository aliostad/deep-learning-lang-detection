package pmysql

import (
	"strings"

	"github.com/enaml-ops/enaml"
	"github.com/enaml-ops/omg-product-bundle/products/p-mysql/enaml-gen/broker-registrar"
)

func NewBrokerRegistrar(plgn *Plugin) *enaml.InstanceGroup {
	return &enaml.InstanceGroup{
		Name:      "broker-registrar",
		Lifecycle: "errand",
		Instances: 1,
		VMType:    plgn.VMTypeName,
		AZs:       plgn.AZs,
		Stemcell:  StemcellAlias,
		Jobs: []enaml.InstanceJob{
			newBrokerRegistrarJob(plgn),
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

func newBrokerRegistrarJob(plgn *Plugin) enaml.InstanceJob {
	return enaml.InstanceJob{
		Name:    "broker-registrar",
		Release: CFMysqlReleaseName,
		Properties: &broker_registrar.BrokerRegistrarJob{
			Cf: &broker_registrar.Cf{
				ApiUrl:            strings.Join([]string{"https://api", "sys", plgn.BaseDomain}, "."),
				AdminUsername:     registrarUser,
				AdminPassword:     plgn.CFAdminPassword,
				SkipSslValidation: true,
			},
			Broker: &broker_registrar.Broker{
				Name:     "p-mysql",
				Host:     strings.Join([]string{"p-mysql", "sys", plgn.BaseDomain}, "."),
				Username: plgn.BrokerAuthUsername,
				Password: plgn.BrokerAuthPassword,
			},
		},
	}
}
