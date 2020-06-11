package cmd

import (
	broker "github.com/Altoros/cf-broker-boilerplate/broker"
	"github.com/Altoros/cf-broker-boilerplate/config"
	"github.com/Altoros/cf-broker-boilerplate/db"
	boshcmd "github.com/cloudfoundry/bosh-cli/cmd"
	"github.com/jinzhu/gorm"
	"github.com/pivotal-cf/brokerapi"

	"net/http"
)

type StartServerCmd struct {
	deps boshcmd.BasicDeps
}

func NewStartServerCmd(deps boshcmd.BasicDeps) StartServerCmd {
	return StartServerCmd{deps: deps}
}

const logTag = "cmd"

func (c StartServerCmd) Run(opts StartServerOpts) error {
	logger := c.deps.Logger

	config, err := config.LoadFromFile(opts.ConfigPath)
	if err != nil {
		logger.Error(logTag, "Failed to load the config file", err.Error())
		return err
	}

	var db *gorm.DB
	db, err = database.New()
	if err != nil {
		logger.Error(logTag, "Failed to connect to the mysql: %s", err.Error())
	}
	defer db.Close()

	serviceBroker := broker.NewServiceBroker(
		opts,
		config,
		db,
		logger,
	)

	credentials := brokerapi.BrokerCredentials{
		Username: opts.ServiceBrokerUsername,
		Password: opts.ServiceBrokerPassword,
	}

	brokerAPI := brokerapi.New(serviceBroker, logger, credentials)

	http.Handle("/", brokerAPI)
	brokerLogger.Info("Listening for requests", lager.Data{
		"port": opts.Port,
	})

	err = http.ListenAndServe(fmt.Sprintf(":%d", opts.Port), nil)
	if err != nil {
		brokerLogger.Error("Failed to start the server", err.Error())
		return err
	}

	return nil
}
