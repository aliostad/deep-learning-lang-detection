// Copyright (C) 2016-Present Pivotal Software, Inc. All rights reserved.
// This program and the accompanying materials are made available under the terms of the under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// http://www.apache.org/licenses/LICENSE-2.0
// Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

package main

import (
	"flag"
	"os"

	"github.com/pivotal-cf/on-demand-service-broker/broker/services"
	"github.com/pivotal-cf/on-demand-service-broker/loggerfactory"
	"github.com/pivotal-cf/on-demand-service-broker/network"
	"github.com/pivotal-cf/on-demand-service-broker/upgrader"
)

func main() {
	loggerFactory := loggerfactory.New(os.Stdout, "upgrade-all-service-instances", loggerfactory.Flags)
	logger := loggerFactory.New()

	brokerUsername := flag.String("brokerUsername", "", "username for the broker")
	brokerPassword := flag.String("brokerPassword", "", "password for the broker")
	brokerUrl := flag.String("brokerUrl", "", "url of the broker")
	pollingInterval := flag.Int("pollingInterval", 0, "interval for checking the upgrade in seconds")
	flag.Parse()

	if *brokerUsername == "" || *brokerPassword == "" || *brokerUrl == "" {
		logger.Fatalln("the brokerUsername, brokerPassword and brokerUrl are required to function")
	}

	if *pollingInterval <= 0 {
		logger.Fatalln("the pollingInterval must be greater than zero")
	}

	httpClient := network.NewDefaultHTTPClient()
	basicAuthClient := network.NewBasicAuthHTTPClient(httpClient, *brokerUsername, *brokerPassword, *brokerUrl)
	brokerServices := services.NewBrokerServices(basicAuthClient)
	listener := upgrader.NewLoggingListener(logger)
	upgradeTool := upgrader.New(brokerServices, *pollingInterval, listener)

	err := upgradeTool.Upgrade()
	if err != nil {
		logger.Fatalln(err.Error())
	}
}
