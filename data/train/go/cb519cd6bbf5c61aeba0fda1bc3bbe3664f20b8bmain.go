package main

import (
	"net/http"
	"os"

	"code.cloudfoundry.org/lager"
	"github.com/pivotal-cf/brokerapi"
)

func main() {
	var logLevels = map[string]lager.LogLevel{
		"DEBUG": lager.DEBUG,
		"INFO":  lager.INFO,
		"ERROR": lager.ERROR,
		"FATAL": lager.FATAL,
	}

	config, err := brokerConfigLoad()
	if err != nil {
		panic(err)
	}

	brokerCredentials := brokerapi.BrokerCredentials{
		Username: config.BrokerUsername,
		Password: config.BrokerPassword,
	}

	services, err := CatalogLoad("./catalog.json")
	if err != nil {
		panic(err)
	}

	logger := lager.NewLogger("concourse-broker")
	logger.RegisterSink(lager.NewWriterSink(os.Stdout, logLevels[config.LogLevel]))

	serviceBroker := &broker{services: services, logger: logger, env: config}
	brokerHandler := brokerapi.New(serviceBroker, logger, brokerCredentials)
	http.Handle("/", brokerHandler)
	http.ListenAndServe(":"+config.Port, nil)
}
