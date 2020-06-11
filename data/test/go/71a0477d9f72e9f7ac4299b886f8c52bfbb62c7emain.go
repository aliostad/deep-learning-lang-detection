package main

import (
	"github.com/nautilus/events"

	"github.com/nautilus/services"
	nHttp "github.com/nautilus/services/http"
)

func main() {
	// try to connect to kafka
	broker, err := events.NewKafkaBroker(&events.NewKafkaBrokerOptions{
		Topic: "api",
	})
	if err != nil {
		panic(err)
	}

	// an instance of the service
	service := MaestroAPI{
		EventBroker: broker,
	}

	// start the event listener
	go Service.Start(&service, &Service.RuntimeConfig{
		EventBroker: service,
	})
	// start the api service
	nHttp.Start(&service, nil)
}
