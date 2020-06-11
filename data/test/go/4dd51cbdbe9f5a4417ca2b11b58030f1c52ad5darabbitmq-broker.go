// Copyright 2014, The cf-service-broker Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that
// can be found in the LICENSE file.

package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"github.com/FreightTrain/cf-rabbitmq-broker/broker"
	"github.com/FreightTrain/cf-rabbitmq-broker/rabbitmq"
	"io/ioutil"
	"log"
	"os"
)

const version = "1.0.1"

func init() {
	flag.BoolVar(&showHelp, "help", false, "")
	flag.BoolVar(&showVersion, "version", false, "")
}

func main() {
	flag.Usage = Usage
	flag.Parse()

	if showHelp {
		Usage()
	}
	if showVersion {
		Version()
	}

	configFile := flag.Args()[0]
	file, e := ioutil.ReadFile(configFile)
	if e != nil {
		fmt.Printf("Cannot read config file '%v'; %v\n", configFile, e)
		os.Exit(1)
	}

	configJson := map[string]map[string]interface{}{}
	err := json.Unmarshal(file, &configJson)
	if err != nil {
		fmt.Printf("Cannot parse JSON in '%v'", configFile)
		os.Exit(1)
	}

	rabbitmq.PopulateOptions(configJson["rabbitmq"])
	broker.PopulateOptions(configJson["broker"])

	brokerServices := make([]broker.BrokerService, len(rabbitmq.Opts.Zones))
	fmt.Sprintf("%v", len(rabbitmq.Opts.Zones))
	for k, zoneData := range rabbitmq.Opts.Zones {
		brokerService, err := rabbitmq.New(zoneData)
		if err != nil {
			log.Fatal(err)
		}
		brokerServices[k] = brokerService
	}

	broker := broker.New(broker.Opts, brokerServices)
	broker.Start()
}

func Usage() {
	fmt.Print(versionStr)
	fmt.Print(usageStr)
	os.Exit(0)
}
func Version() {
	fmt.Print(versionStr)
	os.Exit(0)
}

var (
	showHelp, showVersion bool
	versionStr            = fmt.Sprintf(`
RabbitMQ Service Broker v%v
`, version)
	usageStr = `
cf-rabbitmq-broker [config.json path]
Common Options:
        --help                         Show this message
        --version                      Show service broker version
`
)
