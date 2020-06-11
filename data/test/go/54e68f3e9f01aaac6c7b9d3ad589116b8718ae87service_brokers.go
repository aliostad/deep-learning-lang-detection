package api

import (
	"bytes"
	"encoding/json"
	"fmt"
	"net/url"
	"strings"

	"github.com/cloudfoundry/cli/cf/api/resources"
	"github.com/cloudfoundry/cli/cf/configuration/core_config"
	"github.com/cloudfoundry/cli/cf/errors"
	"github.com/cloudfoundry/cli/cf/models"
	"github.com/cloudfoundry/cli/cf/net"
)

//go:generate counterfeiter -o fakes/fake_service_broker_repository.go . ServiceBrokerRepository
type ServiceBrokerRepository interface {
	ListServiceBrokers(callback func(models.ServiceBroker) bool) error
	FindByName(name string) (serviceBroker models.ServiceBroker, apiErr error)
	FindByGuid(guid string) (serviceBroker models.ServiceBroker, apiErr error)
	Create(name, url, username, password, spaceGUID string) (apiErr error)
	Update(serviceBroker models.ServiceBroker) (apiErr error)
	Rename(guid, name string) (apiErr error)
	Delete(guid string) (apiErr error)
}

type CloudControllerServiceBrokerRepository struct {
	config  core_config.Reader
	gateway net.Gateway
}

func NewCloudControllerServiceBrokerRepository(config core_config.Reader, gateway net.Gateway) (repo CloudControllerServiceBrokerRepository) {
	repo.config = config
	repo.gateway = gateway
	return
}

func (repo CloudControllerServiceBrokerRepository) ListServiceBrokers(callback func(models.ServiceBroker) bool) error {
	return repo.gateway.ListPaginatedResources(
		repo.config.ApiEndpoint(),
		"/v2/service_brokers",
		resources.ServiceBrokerResource{},
		func(resource interface{}) bool {
			callback(resource.(resources.ServiceBrokerResource).ToFields())
			return true
		})
}

func (repo CloudControllerServiceBrokerRepository) FindByName(name string) (serviceBroker models.ServiceBroker, apiErr error) {
	foundBroker := false
	apiErr = repo.gateway.ListPaginatedResources(
		repo.config.ApiEndpoint(),
		fmt.Sprintf("/v2/service_brokers?q=%s", url.QueryEscape("name:"+name)),
		resources.ServiceBrokerResource{},
		func(resource interface{}) bool {
			serviceBroker = resource.(resources.ServiceBrokerResource).ToFields()
			foundBroker = true
			return false
		})

	if !foundBroker && (apiErr == nil) {
		apiErr = errors.NewModelNotFoundError("Service Broker", name)
	}

	return
}
func (repo CloudControllerServiceBrokerRepository) FindByGuid(guid string) (serviceBroker models.ServiceBroker, apiErr error) {
	broker := new(resources.ServiceBrokerResource)
	apiErr = repo.gateway.GetResource(repo.config.ApiEndpoint()+fmt.Sprintf("/v2/service_brokers/%s", guid), broker)
	serviceBroker = broker.ToFields()
	return
}

func (repo CloudControllerServiceBrokerRepository) Create(name, url, username, password, spaceGUID string) error {
	path := "/v2/service_brokers"
	args := struct {
		Name      string `json:"name"`
		Url       string `json:"broker_url"`
		Username  string `json:"auth_username"`
		Password  string `json:"auth_password"`
		SpaceGUID string `json:"space_guid,omitempty"`
	}{
		name,
		url,
		username,
		password,
		spaceGUID,
	}
	bs, err := json.Marshal(args)
	if err != nil {
		return err
	}
	return repo.gateway.CreateResource(repo.config.ApiEndpoint(), path, bytes.NewReader(bs))
}

func (repo CloudControllerServiceBrokerRepository) Update(serviceBroker models.ServiceBroker) (apiErr error) {
	path := fmt.Sprintf("/v2/service_brokers/%s", serviceBroker.Guid)
	body := fmt.Sprintf(
		`{"broker_url":"%s","auth_username":"%s","auth_password":"%s"}`,
		serviceBroker.Url, serviceBroker.Username, serviceBroker.Password,
	)
	return repo.gateway.UpdateResource(repo.config.ApiEndpoint(), path, strings.NewReader(body))
}

func (repo CloudControllerServiceBrokerRepository) Rename(guid, name string) (apiErr error) {
	path := fmt.Sprintf("/v2/service_brokers/%s", guid)
	body := fmt.Sprintf(`{"name":"%s"}`, name)
	return repo.gateway.UpdateResource(repo.config.ApiEndpoint(), path, strings.NewReader(body))
}

func (repo CloudControllerServiceBrokerRepository) Delete(guid string) (apiErr error) {
	path := fmt.Sprintf("/v2/service_brokers/%s", guid)
	return repo.gateway.DeleteResource(repo.config.ApiEndpoint(), path)
}
