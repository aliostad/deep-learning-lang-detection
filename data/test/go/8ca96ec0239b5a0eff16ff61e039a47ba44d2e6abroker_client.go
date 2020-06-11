package integration

import (
	"encoding/json"
	"fmt"
	"time"

	"github.com/pivotal-cf/cf-redis-broker/brokerconfig"
)

type BrokerClient struct {
	Config *brokerconfig.Config
}

func (brokerClient *BrokerClient) ProvisionInstance(instanceID string, plan string) (int, []byte) {
	var status int
	var response []byte

	planID, found := map[string]string{
		"shared":    "C210CA06-E7E5-4F5D-A5AA-7A2C51CC290E",
		"dedicated": "74E8984C-5F8C-11E4-86BE-07807B3B2589",
	}[plan]

	if !found {
		panic("invalid plan name:" + plan)
	}

	payload := struct {
		PlanID string `json:"plan_id"`
	}{
		PlanID: planID,
	}

	payloadBytes, err := json.Marshal(&payload)
	if err != nil {
		panic("unable to marshal the payload to provision instance")
	}

	status, response = ExecuteAuthenticatedHTTPRequestWithBody("PUT",
		brokerClient.InstanceURI(instanceID),
		brokerClient.Config.AuthConfiguration.Username,
		brokerClient.Config.AuthConfiguration.Password,
		payloadBytes,
	)

	// TODO - #122030819
	// Currently, the broker's Provision of a Redis instance does not wait until
	// the instance is ready (this seems to be when the log for Redis reports
	// "server started" and Redis' PID file is populated). This artifical wait
	// is a dumb work around until this is fixed.
	time.Sleep(time.Second * 2)

	return status, response
}

func (brokerClient *BrokerClient) MakeCatalogRequest() (int, []byte) {
	return brokerClient.executeAuthenticatedRequest("GET", "http://localhost:3000/v2/catalog")
}

func (brokerClient *BrokerClient) BindInstance(instanceID, bindingID string) (int, []byte) {
	var status int
	var response []byte

	status, response = ExecuteAuthenticatedHTTPRequestWithBody("PUT",
		brokerClient.BindingURI(instanceID, bindingID),
		brokerClient.Config.AuthConfiguration.Username,
		brokerClient.Config.AuthConfiguration.Password,
		[]byte("{}"))

	return status, response
}

func (brokerClient *BrokerClient) UnbindInstance(instanceID, bindingID string) (int, []byte) {
	var status int
	var response []byte

	status, response = brokerClient.executeAuthenticatedRequest("DELETE", brokerClient.BindingURI(instanceID, bindingID))

	return status, response
}

func (brokerClient *BrokerClient) DeprovisionInstance(instanceID string) (int, []byte) {
	var status int
	var response []byte

	status, response = brokerClient.executeAuthenticatedRequest("DELETE", brokerClient.InstanceURI(instanceID))

	return status, response
}

func (brokerClient *BrokerClient) executeAuthenticatedRequest(httpMethod, url string) (int, []byte) {
	return ExecuteAuthenticatedHTTPRequest(httpMethod, url, brokerClient.Config.AuthConfiguration.Username, brokerClient.Config.AuthConfiguration.Password)
}

func (brokerClient *BrokerClient) InstanceURI(instanceID string) string {
	return fmt.Sprintf("http://localhost:%s/v2/service_instances/%s", brokerClient.Config.Port, instanceID)
}

func (brokerClient *BrokerClient) BindingURI(instanceID, bindingID string) string {
	return brokerClient.InstanceURI(instanceID) + "/service_bindings/" + bindingID
}

func (brokerClient *BrokerClient) InstanceIDFromHost(host string) (int, []byte) {
	return brokerClient.executeAuthenticatedRequest("GET", brokerClient.instanceIDFromHostURI(host))
}

func (brokerClient *BrokerClient) instanceIDFromHostURI(host string) string {
	return fmt.Sprintf("http://localhost:3000/instance?host=%s", host)
}
