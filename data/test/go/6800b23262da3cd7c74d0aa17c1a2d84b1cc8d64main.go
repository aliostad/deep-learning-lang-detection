package main

import (
	"flag"
	"fmt"
	"log"
	"os"

	"github.com/castillobg/ping/api"
	"github.com/castillobg/ping/brokers"
	_ "github.com/castillobg/ping/brokers/rabbit"
	"github.com/castillobg/ping/core"
)

func main() {
	help := flag.Bool("h", false, "Prints this help message.")
	brokerAddr := flag.String("address", "localhost:5672", "The broker's address.")
	brokerName := flag.String("broker", "rabbit", "The broker to be used. Currently supported: rabbit.")
	port := flag.Int("port", 8080, "The port where the api will listen.")
	flag.Parse()

	if *help {
		flag.PrintDefaults()
		os.Exit(0)
	}

	brokerFactory, ok := brokers.LookUp(*brokerName)
	if !ok {
		fmt.Printf("No broker with name \"%s\" found.\n", *brokerName)
		os.Exit(1)
	}
	broker, cleanup, err := brokerFactory.New(*brokerAddr)
	defer cleanup()
	if err != nil {
		log.Printf("Error initializing broker client for \"%s\": %s\n", *brokerName, err.Error())
		os.Exit(1)
	}
	messages := make(chan []byte)
	err = broker.Listen("pongs", messages)
	if err != nil {
		log.Println(err)
		os.Exit(1)
	}

	listeners := make(chan chan []byte)
	core.Listen(broker, messages, listeners)

	log.Printf("ping is running on port: %d\n", *port)
	api.Listen(*port, listeners)
}
