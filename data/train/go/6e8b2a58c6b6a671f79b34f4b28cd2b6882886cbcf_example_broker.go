package main

import (
	"errors"
	"net/http"

	"github.com/avade/cf-example-broker/database"

	"github.com/pivotal-cf/brokerapi"
	"github.com/pivotal-golang/lager"
)

type exampleServiceBroker struct {
	dbCreator database.Creator
	instances map[string]string
}

func (*exampleServiceBroker) Services() []brokerapi.Service {
	return nil
}

func (serviceBroker *exampleServiceBroker) Provision(instanceID string, details brokerapi.ProvisionDetails) error {
	if details.PlanID == serviceBroker.plan().ID {
		_, dbName := serviceBroker.dbCreator.CreateDb()
		serviceBroker.instances[instanceID] = dbName
		return nil
	} else {
		return errors.New("plan_id is not valid")
	}
}

func (*exampleServiceBroker) Deprovision(instanceID string) error {
	return errors.New("Not supported")
	// Deprovision instances here
}

func (serviceBroker *exampleServiceBroker) Bind(instanceID, bindingID string, details brokerapi.BindDetails) (interface{}, error) {
	err, username, password := serviceBroker.dbCreator.CreateUser(serviceBroker.instances[instanceID])
	if err != nil {
		return nil, err
	}
	credentialsMap := map[string]interface{}{
		"username": username,
		"password": password,
	}
	return credentialsMap, nil
}

func (*exampleServiceBroker) Unbind(instanceID, bindingID string) error {
	return errors.New("Not supported")
	// Unbind from instances here
}

func main() {
	dbCreator := database.NewCreator("username", "password", "hostname", 123)

	serviceBroker := &exampleServiceBroker{
		dbCreator: dbCreator,
		instances: map[string]string{},
	}
	logger := lager.NewLogger("cf-example-broker")
	credentials := brokerapi.BrokerCredentials{
		Username: "username",
		Password: "password",
	}

	brokerAPI := brokerapi.New(serviceBroker, logger, credentials)
	http.Handle("/", brokerAPI)
	http.ListenAndServe(":3000", nil)
}

func (serviceBroker *exampleServiceBroker) plan() *brokerapi.ServicePlan {
	return &brokerapi.ServicePlan{
		ID:          "cheap-id",
		Name:        "cheap",
		Description: "This plan provides a...",
		Metadata: brokerapi.ServicePlanMetadata{
			Bullets: []string{
				"Example CF service",
			},
			DisplayName: "Cheap-Plan",
		},
	}
}
