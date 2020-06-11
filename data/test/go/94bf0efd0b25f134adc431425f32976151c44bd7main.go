package main

import (
	"net/http"
	"os"

	"code.cloudfoundry.org/lager"
	"github.com/pivotal-cf/brokerapi"
)

func main() {
	brokerConfig, err := brokerConfigLoad()
	if err != nil {
		panic(err)
	}

	brokerCredentials := brokerapi.BrokerCredentials{
		Username: brokerConfig.BrokerUsername,
		Password: brokerConfig.BrokerPassword,
	}

	services, err := CatalogLoad("./catalog.json")
	if err != nil {
		panic(err)
	}

	logger := lager.NewLogger("static-broker")
	logger.RegisterSink(lager.NewWriterSink(os.Stdout, lager.DEBUG))

	serviceBroker := &broker{services: services, logger: logger, env: brokerConfig}
	brokerHandler := brokerapi.New(serviceBroker, logger, brokerCredentials)
	http.Handle("/", brokerHandler)
	http.ListenAndServe(":"+brokerConfig.Port, nil)
}
