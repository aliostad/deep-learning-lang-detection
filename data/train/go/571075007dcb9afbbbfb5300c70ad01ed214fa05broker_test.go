package main

import (
	"testing"

	"github.com/pivotal-cf/brokerapi"
)

func TestBrokerServices(t *testing.T) {
	config, _ := brokerConfigLoad()
	services, _ := CatalogLoad("./catalog.json")
	serviceBroker := &broker{services: services, logger: nil, env: config}

	returnedServices := serviceBroker.Services(nil)
	if returnedServices == nil || len(returnedServices) == 0 {
		t.Error("No services returned.")
	}
}

func TestBrokerBind(t *testing.T) {
	config, _ := brokerConfigLoad()
	services, _ := CatalogLoad("./catalog.json")
	serviceBroker := &broker{services: services, logger: nil, env: config}

	fakeDetails := brokerapi.BindDetails{
		AppGUID:       "thisisanappguid",
		PlanID:        "fakePlanId",
		ServiceID:     "faeServiceId",
		BindResource:  nil,
		RawParameters: nil,
	}

	_, err := serviceBroker.Bind(nil, "fakeInstanceId", "fakeBindingId", fakeDetails)
	/*if err != nil {
		t.Error("serviceBroker.Bind returned error: " + err.Error())
	}*/
	if err.Error() != "service does not support bind" {
		t.Error("got: " + err.Error() + " expected: service does not support bind")
	}

}
