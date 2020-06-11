package main

import (
    "flag"
    "github.com/brahmaroutu/docker-broker/broker/brokerapi"
    "github.com/brahmaroutu/docker-broker/broker/dockerapi"
    "log"
    "os"
)

func main() {
    /* Usage: broker [ -config file ] */

    var configFile string

    flag.StringVar(&configFile, "config", "broker.config",
        "Location of configuration file")

    flag.Parse()

    log.Println("ConfigFile:", configFile)
    config,err := dockerapi.NewConfiguration(configFile)
    if err != nil {
        log.Println("Failed to create configuration", err)
        os.Exit(1)
    }
    
    var dispatcher brokerapi.DispatcherInterface
    switch config.Dispatcher {
    case "SimpleDispatcher":
        dispatcher = dockerapi.NewSimpleDispatcher(*config)
    default:
        dispatcher = dockerapi.NewSimpleDispatcher(*config)
    }
    agentmanager, err := dockerapi.NewAgentManager(*config, dispatcher)
    broker := brokerapi.New(config.GetOpts(), agentmanager)
    broker.Start()
}
