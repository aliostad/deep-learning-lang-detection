package deregistrar

import (
	"fmt"
	"log"

	"github.com/pivotal-cf/on-demand-service-broker/config"
)

type Deregistrar struct {
	cfClient CloudFoundryClient
	logger   *log.Logger
}

type Config struct {
	DisableSSLCertVerification bool `yaml:"disable_ssl_cert_verification"`
	CF                         config.CF
}

//go:generate counterfeiter -o fakes/fake_cloud_foundry_client.go . CloudFoundryClient
type CloudFoundryClient interface {
	GetServiceOfferingGUID(string, *log.Logger) (string, error)
	DeregisterBroker(string, *log.Logger) error
}

func New(client CloudFoundryClient, logger *log.Logger) *Deregistrar {
	return &Deregistrar{
		cfClient: client,
		logger:   logger,
	}
}

func (r *Deregistrar) Deregister(brokerName string) error {
	var brokerGUID string

	brokerGUID, err := r.cfClient.GetServiceOfferingGUID(brokerName, r.logger)
	if err != nil {
		return err
	}

	err = r.cfClient.DeregisterBroker(brokerGUID, r.logger)
	if err != nil {
		return fmt.Errorf("Failed to deregister broker with %s with guid %s, err: %s", brokerName, brokerGUID, err.Error())
	}
	return nil
}
