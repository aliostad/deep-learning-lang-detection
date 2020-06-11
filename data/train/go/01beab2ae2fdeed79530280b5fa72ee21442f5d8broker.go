/*
Copyright 2014 Google Inc. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package main

import (
	"flag"
	"fmt"
	"os"
	"os/signal"
	"path/filepath"

	broker "github.com/GoogleCloudPlatform/cloud-testenv-broker/broker"
	glog "github.com/golang/glog"
	jsonpb "github.com/golang/protobuf/jsonpb"
	proto "github.com/golang/protobuf/proto"
	emulators "google/emulators"
	duration_pb "github.com/golang/protobuf/ptypes/duration"
)

const (
	// BRKR - get it?
	defaultBrokerPort = 8939
)

var (
	host = flag.String("host", "localhost", "The server host or IP address.")
	port = flag.Int("port", defaultBrokerPort,
		fmt.Sprintf("The server port. If specified as a non-default value, "+
			"overrides the value of the %s environment variable.",
			broker.BrokerAddressEnv))
	// TODO(hbchai): Should we accept multiple config files?
	configFile = flag.String("config_file", "", "The json config file of the Cloud Broker.")
)

// Returns the port the broker should serve on.
func brokerPort() int {
	if *port != defaultBrokerPort {
		return *port
	}
	brokerPort := broker.BrokerPortFromEnv()
	if brokerPort != 0 {
		return brokerPort
	}
	return defaultBrokerPort
}

func main() {
	flag.Set("alsologtostderr", "true")
	flag.Parse()
	brokerDir, err := filepath.Abs(filepath.Dir(os.Args[0]))
	if err != nil {
		glog.Fatalf("Failed to obtain broker directory: %v", err)
	}
	glog.Infof("Broker starting up (%s)...", brokerDir)

	config := emulators.BrokerConfig{DefaultEmulatorStartDeadline: &duration_pb.Duration{Seconds: 10}}
	if *configFile != "" {
		// Parse configFile and use it.
		f, err := os.Open(*configFile)
		if err != nil {
			glog.Fatalf("Failed to open config file: %v", err)
		}
		defer f.Close()
		err = jsonpb.Unmarshal(f, &config)
		if err != nil {
			glog.Fatalf("Failed to parse config file: %v", err)
		}
	}
	glog.Infof("Using configuration:\n%s", proto.MarshalTextString(&config))

	b, err := broker.NewGrpcServer(*host, brokerPort(), brokerDir, &config)
	if err != nil {
		glog.Fatalf("Failed to create broker: %v", err)
	}
	err = b.Start()
	if err != nil {
		glog.Fatalf("Failed to start broker: %v", err)
	}
	die := make(chan os.Signal, 1)
	signal.Notify(die, os.Interrupt, os.Kill)
	go func() {
		<-die
		b.Shutdown()
		os.Exit(1)
	}()
	defer b.Shutdown()
	glog.Infof("Broker listening on %s:%d.", *host, b.Port())
	b.Wait()
	glog.Infof("Broker shut down.")
}
