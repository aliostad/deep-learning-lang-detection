package main

import (
	"fmt"
	"log"
	"net/http"
	"os"

	"encoding/json"

	"github.com/pivotal-cf/brokerapi"
	"github.com/pivotal-golang/lager"
)

type fixedServiceBroker struct {
	Credentials  interface{}
	Service      brokerapi.Service
	DashboardURL string
}

func (serviceBroker *fixedServiceBroker) Services() []brokerapi.Service {
	return []brokerapi.Service{serviceBroker.Service}
}

func (serviceBroker *fixedServiceBroker) Provision(
	instanceID string,
	details brokerapi.ProvisionDetails,
	asyncAllowed bool,
) (brokerapi.ProvisionedServiceSpec, error) {
	return brokerapi.ProvisionedServiceSpec{DashboardURL: serviceBroker.DashboardURL}, nil
}

func (serviceBroker *fixedServiceBroker) LastOperation(instanceID string) (brokerapi.LastOperation, error) {
	return brokerapi.LastOperation{}, nil
}

func (serviceBroker *fixedServiceBroker) Deprovision(instanceID string, details brokerapi.DeprovisionDetails, asyncAllowed bool) (brokerapi.IsAsync, error) {
	return brokerapi.IsAsync(false), nil
}

func (serviceBroker *fixedServiceBroker) Bind(instanceID, bindingID string, details brokerapi.BindDetails) (brokerapi.Binding, error) {
	return brokerapi.Binding{Credentials: serviceBroker.Credentials}, nil
}

func (serviceBroker *fixedServiceBroker) Unbind(instanceID, bindingID string, details brokerapi.UnbindDetails) error {
	return nil
}

func (serviceBroker *fixedServiceBroker) Update(instanceID string, details brokerapi.UpdateDetails, asyncAllowed bool) (brokerapi.IsAsync, error) {
	return brokerapi.IsAsync(false), nil
}

func env(key, defaultValue string) string {
	var value string
	if value = os.Getenv(key); len(value) == 0 {
		return defaultValue
	}
	return value
}

func main() {
	port := env("PORT", "3000")
	dashboardURL := env("DASHBOARD_URL", "http://example.com/dashboard")
	credentialsJSON := env("CREDENTIALS", `{"uri":""}`)
	serviceJSON := env("SERVICE", `{
    "id": "0A789746-596F-4CEA-BFAC-A0795DA056E3",
    "name": "p-fake",
    "description": "Fake Service Broker",
    "bindable": true,
    "tags": [
      "pivotal",
      "cassandra"
    ],
    "plan_updateable": true,
    "plans": [
      {
        "id": "ABE176EE-F69F-4A96-80CE-142595CC24E3",
        "name": "standard",
        "description": "The default plan",
        "metadata": {
          "displayName": "Standard"
        }
      }
    ],
    "metadata": {
      "displayName": "Fake",
      "longDescription": "This is a fake service broker",
      "documentationUrl": "http://doc.fake.example.com",
      "supportUrl": "http://support.fake.example.com"
    }
  }`)

	var credentials interface{}
	service := brokerapi.Service{}

	err := json.Unmarshal([]byte(credentialsJSON), &credentials)
	if err != nil {
		log.Fatalf("error: %v", err)
	}
	err = json.Unmarshal([]byte(serviceJSON), &service)
	if err != nil {
		log.Fatalf("error: %v", err)
	}

	serviceBroker := &fixedServiceBroker{Credentials: credentials, Service: service, DashboardURL: dashboardURL}
	fmt.Printf("Run ServiceBroker -> %v\n", serviceBroker)
	logger := lager.NewLogger("fake-service-broker")

	brokerAPI := brokerapi.New(serviceBroker, logger, brokerapi.BrokerCredentials{
		Username: "fake",
		Password: "fake",
	})
	http.Handle("/", brokerAPI)

	fmt.Println("Start " + port)
	http.ListenAndServe(":"+port, nil)
}
