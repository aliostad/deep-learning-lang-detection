package client

import (
	priceManager "github.com/RetailMarket/priceManagerClient"
	"log"
	"google.golang.org/grpc"
)

var PriceManagerClient priceManager.PriceManagerClient;

var priceManagerConn *grpc.ClientConn;

const (
	PRICE_MANAGER_ADDRESS = "localhost:3000"
)

func createPriceManagerClientConnection() (priceManager.PriceManagerClient, *grpc.ClientConn) {
	conn, err := grpc.Dial(PRICE_MANAGER_ADDRESS, grpc.WithInsecure())
	if err != nil {
		log.Fatalf("did not connect: %v", err)
	}

	return priceManager.NewPriceManagerClient(conn), conn
}

func CreateClientConnection() {
	PriceManagerClient, priceManagerConn = createPriceManagerClientConnection()
}

func CloseConnections() {
	priceManagerConn.Close();
}