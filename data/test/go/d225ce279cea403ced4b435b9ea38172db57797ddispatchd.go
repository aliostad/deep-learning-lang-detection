package main

import (
	"fmt"

	"github.com/innovate-technologies/Dispatch/dispatchd/apiserver"
	"github.com/innovate-technologies/Dispatch/dispatchd/command"
	"github.com/innovate-technologies/Dispatch/dispatchd/config"
	"github.com/innovate-technologies/Dispatch/dispatchd/machine"
	"github.com/innovate-technologies/Dispatch/dispatchd/supervisor"
)

var configuration config.ConfigurationInfo

func main() {
	fmt.Println("Dispatch")
	fmt.Println("Copyright 2017 Innovate Technologies")
	fmt.Println("====================================")
	configuration = config.GetConfiguration()
	fmt.Println(configuration.MachineName)

	machine.Config = &configuration
	supervisor.Config = &configuration
	command.Config = &configuration
	apiserver.Config = &configuration

	machine.RegisterMachine()
	supervisor.Run()
	command.Run()

	apiserver.Run()

}
