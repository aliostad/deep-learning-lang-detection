package main

import (
	"fmt"
	"log"
	"net/http"
	"os"

	"code.cloudfoundry.org/lager"
	"github.com/cloudflare/Cloudflare-Pivotal-Cloud-Foundry/broker"
	"github.com/pivotal-cf/brokerapi"
)

func main() {
	logger := lager.NewLogger("cloudflare-broker")
	logger.RegisterSink(lager.NewWriterSink(os.Stderr, lager.DEBUG))

	serviceBroker := broker.New(logger, map[string]broker.Zone{})

	credentials := brokerapi.BrokerCredentials{
		Username: os.Getenv(broker.BROKER_USERNAME),
		Password: os.Getenv(broker.BROKER_PASSWORD),
	}

	brokerAPI := brokerapi.New(&serviceBroker, logger, credentials)

	fmt.Println("Running Server on port " + os.Getenv(broker.BROKER_PORT))
	http.Handle("/", brokerAPI)
	if err := http.ListenAndServe(":"+os.Getenv(broker.BROKER_PORT), nil); err != nil {
		log.Fatal("ListenAndServe:", err)
	}
}
