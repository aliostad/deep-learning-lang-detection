package main

import (
	"flag"
	"fmt"
	"log"
	"os"

	"github.com/castillobg/pong/api"
	"github.com/castillobg/pong/brokers"
	_ "github.com/castillobg/pong/brokers/rabbit"
	"github.com/castillobg/pong/core"
)

func main() {
	help := flag.Bool("h", false, "Prints this help message.")
	brokerAddr := flag.String("address", "localhost:5672", "The broker's address.")
	brokerName := flag.String("broker", "rabbit", "The broker to be used. Currently supported: rabbit.")
	port := flag.Int("port", 8080, "The port where the api will listen.")
	delay := flag.Int("delay", 0, "The amount of time to wait before sending back a pong.")
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
	err = broker.Listen("pings", messages)
	if err != nil {
		log.Println(err)
		os.Exit(1)
	}

	core.Listen(broker, messages, *delay)

	log.Printf("pong is running on port: %d\n", *port)
	api.Listen(*port)
}
