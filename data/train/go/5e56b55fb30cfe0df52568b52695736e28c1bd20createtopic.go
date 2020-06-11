package main

import (
	"github.com/Shopify/sarama"
	"os"
	"os/signal"
	"log"
	"fmt"
)

func main() {
	broker := sarama.NewBroker("120.27.97.59:9092")
	err := broker.Open(nil)
	if err != nil {
		panic(err)
	}

	request := sarama.MetadataRequest{Topics: []string{"wenzhenxi"}}
	response, err := broker.GetMetadata(&request)
	if err != nil {
		_ = broker.Close()
		panic(err)
	}

	fmt.Println("There are", len(response.Topics), "topics active in the cluster.")

	if err = broker.Close(); err != nil {
		panic(err)
	}

}
