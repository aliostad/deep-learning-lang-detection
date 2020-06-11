// Copyright (C) 2016-Present Pivotal Software, Inc. All rights reserved.
// This program and the accompanying materials are made available under the terms of the under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// http://www.apache.org/licenses/LICENSE-2.0
// Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

package apiserver

import (
	"fmt"
	"log"
	"net/http"

	"code.cloudfoundry.org/lager"
	"github.com/gorilla/mux"
	"github.com/pivotal-cf/brokerapi"
	apiauth "github.com/pivotal-cf/brokerapi/auth"
	"github.com/pivotal-cf/on-demand-service-broker/config"
	"github.com/pivotal-cf/on-demand-service-broker/loggerfactory"
	"github.com/pivotal-cf/on-demand-service-broker/mgmtapi"
	"github.com/urfave/negroni"
)

//go:generate counterfeiter -o fakes/combined_brokers.go . CombinedBrokers
type CombinedBrokers interface {
	mgmtapi.ManageableBroker
	brokerapi.ServiceBroker
}

func New(
	conf config.Config,
	baseBroker CombinedBrokers,
	credhubBroker CombinedBrokers,
	componentName string,
	mgmtapiLoggerFactory *loggerfactory.LoggerFactory,
	serverLogger *log.Logger,
) *http.Server {

	brokerRouter := mux.NewRouter()
	broker := baseBroker
	if conf.HasCredHub() {
		broker = credhubBroker
	}
	mgmtapi.AttachRoutes(brokerRouter, broker, conf.ServiceCatalog, mgmtapiLoggerFactory)
	brokerapi.AttachRoutes(brokerRouter, broker, lager.NewLogger(componentName))
	authProtectedBrokerAPI := apiauth.
		NewWrapper(conf.Broker.Username, conf.Broker.Password).
		Wrap(brokerRouter)

	negroniLogger := &negroni.Logger{ALogger: serverLogger}
	server := negroni.New(
		negroni.NewRecovery(),
		negroniLogger,
		negroni.NewStatic(http.Dir("public")),
	)

	server.UseHandler(authProtectedBrokerAPI)
	return &http.Server{
		Addr:    fmt.Sprintf(":%d", conf.Broker.Port),
		Handler: server,
	}
}
