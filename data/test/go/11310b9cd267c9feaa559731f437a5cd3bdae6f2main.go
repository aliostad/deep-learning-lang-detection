package main

import (
	"fmt"
	"log"
	"net/http"
	"os"

	"github.com/benchapman/redis-broker/broker"
	"github.com/pivotal-cf/brokerapi"
	"github.com/pivotal-golang/lager"
)

func main() {
	ipAddress := os.Getenv("REDIS_IP")

	serviceBroker := broker.New(broker.DatabaseIDs{}, ipAddress)
	logger := lager.NewLogger("redis-service-broker")
	credentials := brokerapi.BrokerCredentials{
		Username: "admin",
		Password: "admin",
	}

	brokerAPI := brokerapi.New(&serviceBroker, logger, credentials)
	fmt.Println("Listening on port " + os.Getenv("PORT") + " with IP " + ipAddress)
	http.Handle("/", brokerAPI)
	if err := http.ListenAndServe(":"+os.Getenv("PORT"), nil); err != nil {
		log.Fatal("ListenAndServe:", err)
	}
}
