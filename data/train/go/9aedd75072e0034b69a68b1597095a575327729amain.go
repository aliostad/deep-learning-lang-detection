package main

import (
	"github.com/nautilus/events"
	"github.com/nautilus/services"
	"github.com/spf13/afero"
)

func main() {
	// try to connect to kafka
	broker, err := events.NewKafkaBroker(&events.NewKafkaBrokerOptions{
		Topic: "build",
	})
	if err != nil {
		panic(err)
	}

	// for now, just run a single build instance
	service := MaestroRepo{
		EventBroker: broker,
		Fs:          afero.NewOsFs(),
	}

	// start the event listener
	Service.Start(&service, &Service.RuntimeConfig{
		EventBroker: broker,
	})
}
