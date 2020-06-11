package main

import (
	broker "github.com/hecatoncheir/Hecatoncheir/broker"
	http "github.com/hecatoncheir/Hecatoncheir/http"
	socket "github.com/hecatoncheir/Hecatoncheir/socket"
)

func main() {
	httpServer := http.NewEngine("v1.0")
	socketServer := socket.NewEngine("v1.0")

	httpServer.Router.HandlerFunc("GET", "/", socketServer.ClientConnectedHandler)

	broker := broker.New()
	go broker.Connect("192.168.99.100", 4150)
	SubscribeCrawlerHandler(broker, "GetItemsFromCategoriesOfCompanys", "ItemFromCategoriesOfCompanyParsed")

	httpServer.PowerUp("0.0.0.0", 8080)
}
