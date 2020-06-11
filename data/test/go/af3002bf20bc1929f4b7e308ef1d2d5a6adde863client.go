package tg

import (
	"bufio"
	"encoding/json"
	"io"
	"log"
)

// UpdateHandler is an update handler for webhook updates
type UpdateHandler func(broker *Broker, message APIMessage)

// BrokerCallback is a callback for broker responses to client requests
type BrokerCallback func(broker *Broker, update BrokerUpdate)

// CreateBrokerClient creates a connection to a broker and sends all webhook updates to a given function.
// This is the intended way to create clients, please refer to examples for how to make a simple client.
func CreateBrokerClient(brokerAddr string, updateFn UpdateHandler) error {
	broker, err := ConnectToBroker(brokerAddr)
	if err != nil {
		return err
	}
	defer broker.Close()

	return RunBrokerClient(broker, updateFn)
}

// RunBrokerClient is a slimmer version of CreateBrokerClient for who wants to keep its own broker connection
func RunBrokerClient(broker *Broker, updateFn UpdateHandler) error {
	in := bufio.NewReader(broker.Socket)
	var buf []byte
	for {
		bytes, isPrefix, err := in.ReadLine()
		if err != nil {
			break
		}
		buf = append(buf, bytes...)

		if isPrefix {
			continue
		}

		var update BrokerUpdate
		err = json.Unmarshal(buf, &update)
		if err != nil {
			log.Printf("[tg - CreateBrokerClient] ERROR reading JSON: %s\r\n", err.Error())
			log.Printf("%s\n", string(buf))
			continue
		}

		if update.Callback == nil {
			// It's a generic message: dispatch to UpdateHandler
			go updateFn(broker, *(update.Message))
		} else {
			// It's a response to a request: retrieve callback and call it
			go broker.SpliceCallback(*(update.Callback))(broker, update)
		}

		// Empty buffer
		buf = []byte{}
	}

	return io.EOF
}
