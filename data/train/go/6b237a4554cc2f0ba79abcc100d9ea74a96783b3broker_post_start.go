// Copyright (C) 2016-Present Pivotal Software, Inc. All rights reserved.
// This program and the accompanying materials are made available under the terms of the under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// http://www.apache.org/licenses/LICENSE-2.0
// Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

package main

import (
	"flag"
	"fmt"
	"net/http"
	"os"
	"time"

	"github.com/pivotal-cf/on-demand-service-broker/loggerfactory"
	"github.com/pivotal-cf/on-demand-service-broker/network"
)

func main() {
	brokerUsername := flag.String("brokerUsername", "", "username for the broker")
	brokerPassword := flag.String("brokerPassword", "", "password for the broker")
	brokerPort := flag.String("brokerPort", "", "port of the broker")
	timeout := flag.Int("timeout", 120, "timeout in seconds for the post-start check")
	flag.Parse()

	loggerFactory := loggerfactory.New(os.Stdout, "broker-post-start", loggerfactory.Flags)

	logger := loggerFactory.New()
	logger.Println("Starting broker post-start check, waiting for broker to start serving catalog.")

	brokerCatalogURL := fmt.Sprintf("http://localhost:%s/v2/catalog", *brokerPort)
	request, err := http.NewRequest("GET", brokerCatalogURL, nil)
	if err != nil {
		logger.Printf("error creating request: %s\n", err)
		os.Exit(1)
	}
	request.SetBasicAuth(*brokerUsername, *brokerPassword)

	client := network.NewDefaultHTTPClient()

	go func() {
		for {
			response, err := client.Do(request)
			if err != nil {
				logger.Printf("error performing request: %s", err)
			} else if response.StatusCode != http.StatusOK {
				logger.Printf("expected status 200, was %d, from %s\n", response.StatusCode, brokerCatalogURL)
			} else {
				logger.Println("Broker post-start check successful")
				os.Exit(0)
			}
			time.Sleep(1 * time.Second)
		}
	}()

	<-time.After(time.Duration(*timeout) * time.Second)

	logger.Println("Broker post-start check failed")
	os.Exit(1)
}
