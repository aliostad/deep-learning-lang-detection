package main

import (
	"connect-server/model"
	"connect-server/utils/config"
	"fmt"
	"runtime"
	"td-server/dispatcher"
)

func main() {
	runtime.GOMAXPROCS(runtime.NumCPU())
	config := config.NewConfig()

	err := config.Read("conf/Server.conf")
	if err != nil {
		fmt.Println("td-server Read conf file error")
		return
	}

	var IP string
	var TokenPort int
	var DispatchPort int

	IP, err = config.GetString("DispacthIP")
	if err != nil {
		fmt.Println("td-server Get IP error")
		return
	}
	TokenPort, err = config.GetInt("TokenPort")
	if err != nil {
		fmt.Println("td-server Get TokenPort error")
		return
	}
	DispatchPort, err = config.GetInt("DispatchPort")
	if err != nil {
		fmt.Println("td-server Get DispatchPort error")
		return
	}

	tokens := model.NewTokens()
	relations := model.NewRelations()

	tokenServer := dispatcher.NewTokener(IP, TokenPort, tokens)
	go tokenServer.Start()

	dispatchServer := dispatcher.NewDispatcher(IP, DispatchPort, tokens, relations)
	dispatchServer.Start()
}
