package main

import (
	"fmt"
	"os"
	"strconv"
	"time"

	//"github.com/ericnorway/arbitraryFailures/common"
	//pb "github.com/ericnorway/arbitraryFailures/proto"
	"github.com/ericnorway/arbitraryFailures/broker"
)

// main parses the command line arguments and starts the Broker
func main() {
	parsedCorrectly := ParseArgs()
	if !parsedCorrectly {
		return
	}

	err := ReadConfigFile(*configFile)
	if err != nil {
		fmt.Printf("%v\n", err)
		return
	}

	numberOfBrokers := uint64(len(brokerAddresses))

	// Create new broker
	b := broker.NewBroker(localID, brokerAddresses[localID], numberOfBrokers, uint64(*alpha), *maliciousPercent)

	// Add publisher information
	for i, key := range publisherKeys {
		id := uint64(i)
		b.AddPublisher(id, []byte(key))
	}

	// Add broker information
	for i, key := range brokerKeys {
		id := uint64(i)
		if id != localID {
			b.AddBroker(id, brokerAddresses[id], []byte(key))
		}
	}

	// Add subscriber information
	for i, key := range subscriberKeys {
		id := uint64(i)
		b.AddSubscriber(id, []byte(key))
	}

	// Add the chain path
	b.AddChainPath(chain, rChain)

	go RecordThroughput(b)

	// Start the broker
	b.StartBroker()
}

// RecordThroughput ...
func RecordThroughput(b *broker.Broker) {
	file, err := os.Create("./results/throughput" + strconv.FormatUint(localID, 10) + ".txt")
	if err != nil {
		fmt.Printf("%v\n", err)
		return
	}
	defer file.Close()
	pubCount := 0
	ticker := time.NewTicker(time.Second)

	for {
		select {
		case <-b.ToUserRecordCh:
			pubCount++
		case <-ticker.C:
			file.Write([]byte(fmt.Sprintf("%v\n", pubCount)))
			pubCount = 0
		}
	}
}
