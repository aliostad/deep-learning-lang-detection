package main

import (
	"fmt"
	"net/http"

	"github.com/pivotal-golang/lager"

	"github.com/cholick/cf-examples/broker-go/example"
	"github.com/cholick/cf-examples/broker-go/kv"
	"github.com/cholick/cf-examples/broker-go/util"
	"github.com/pivotal-cf/brokerapi"
)

func main() {
	logger := lager.NewLogger("my-service-broker")
	store := kv.NewMemoryStore()

	serviceBroker := example.NewSampleServiceBroker(store)
	credentials := brokerapi.BrokerCredentials{
		Username: util.GetUser(),
		Password: util.GetPassword(),
	}
	brokerAPI := brokerapi.New(serviceBroker, logger, credentials)
	http.Handle("/v2/", brokerAPI)


	api := kv.NewApi(logger, store)
	http.Handle("/kv/", api)

	port := util.GetPort()
	println(fmt.Sprintf("Listening on port %s", port))
	err := http.ListenAndServe(":"+port, nil)
	if err != nil {
		logger.Fatal("failed-to-start-server", err)
	}
}
