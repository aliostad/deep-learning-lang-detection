// Copyright 2014, The cf-service-broker Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that
// can be found in the LICENSE file.

package broker

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"os/signal"
)

type broker struct {
	opts   Options
	router *router
}

func New(o Options, bs []BrokerService) *broker {
	return &broker{o, newRouter(o, newHandler(bs))}
}

func (b *broker) Start() {
	sigCh := make(chan os.Signal, 1)
	signal.Notify(sigCh, os.Interrupt)

	errCh := make(chan error, 1)
	go func() {
		addr := fmt.Sprintf("%v:%v", b.opts.Host, b.opts.Port)
		log.Printf("Broker started: Listening at [%v]", addr)
		errCh <- http.ListenAndServe(addr, b.router)
	}()

	select {
	case err := <-errCh:
		log.Printf("Broker shutdown with error: %v", err)
	case sig := <-sigCh:
		var _ = sig
		log.Print("Broker shutdown gracefully")
	}
}
