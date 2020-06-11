package main

import (
	"context"
	"net/http"
	"os"

	"code.cloudfoundry.org/lager"
	"github.com/kelseyhightower/envconfig"
	"github.com/pivotal-cf/brokerapi"
)

type GuardBroker struct {
	RouteServiceURL string `envconfig:"route_service_url" required:"true"`
	BrokerUsername  string `envconfig:"broker_username" required:"true"`
	BrokerPassword  string `envconfig:"broker_password" required:"true"`
	Port            string `envconfig:"port" default:"3000"`
}

func (guardBroker *GuardBroker) Services(context.Context) []brokerapi.Service {
	return []brokerapi.Service{
		brokerapi.Service{
			ID:            "7a3691df-4bba-4468-9cca-85f281143d3f",
			Name:          "uaa-auth",
			Description:   "[Experimental] Protect applications with Cloud Foundry authentication in the routing path",
			Bindable:      true,
			Tags:          []string{"route-service", "uaa-auth"},
			PlanUpdatable: false,
			Requires:      []brokerapi.RequiredPermission{brokerapi.PermissionRouteForwarding},
			Plans: []brokerapi.ServicePlan{
				brokerapi.ServicePlan{
					ID:          "f72ca726-fa42-4583-8874-615808fbd6a7",
					Name:        "uaa-auth",
					Description: "[Experimental] Add to a route and it will request Cloud Foundry authentication before proceeding.",
				},
			},
		},
	}
}

func (guardBroker *GuardBroker) Provision(context context.Context, instanceID string, details brokerapi.ProvisionDetails, asyncAllowed bool) (brokerapi.ProvisionedServiceSpec, error) {
	return brokerapi.ProvisionedServiceSpec{}, nil
}

func (guardBroker *GuardBroker) Deprovision(context context.Context, instanceID string, details brokerapi.DeprovisionDetails, asyncAllowed bool) (brokerapi.DeprovisionServiceSpec, error) {
	return brokerapi.DeprovisionServiceSpec{}, nil
}

func (guardBroker *GuardBroker) Bind(context context.Context, instanceID string, bindingID string, details brokerapi.BindDetails) (brokerapi.Binding, error) {
	return brokerapi.Binding{
			Credentials:     "",
			RouteServiceURL: guardBroker.RouteServiceURL},
		nil
}

func (guardBroker *GuardBroker) Unbind(context context.Context, instanceID string, bindingID string, details brokerapi.UnbindDetails) error {
	return nil
}

func (guardBroker *GuardBroker) LastOperation(context context.Context, instanceID, operationData string) (brokerapi.LastOperation, error) {
	return brokerapi.LastOperation{}, nil
}

func (guardBroker *GuardBroker) Update(context context.Context, instanceID string, details brokerapi.UpdateDetails, asyncAllowed bool) (brokerapi.UpdateServiceSpec, error) {
	return brokerapi.UpdateServiceSpec{}, nil
}

func main() {
	serviceBroker := &GuardBroker{}
	logger := lager.NewLogger("guard-broker")
	logger.RegisterSink(lager.NewWriterSink(os.Stdout, lager.DEBUG))
	logger.RegisterSink(lager.NewWriterSink(os.Stdout, lager.ERROR))

	err := envconfig.Process("guard", serviceBroker)
	if err != nil {
		logger.Error("env-parse", err)
	}

	credentials := brokerapi.BrokerCredentials{
		Username: serviceBroker.BrokerUsername,
		Password: serviceBroker.BrokerPassword,
	}

	brokerAPI := brokerapi.New(serviceBroker, logger, credentials)
	http.Handle("/", brokerAPI)

	http.ListenAndServe(":"+serviceBroker.Port, nil)
}
