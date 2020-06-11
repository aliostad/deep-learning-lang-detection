package manager

import (
	"github.com/Efruit/marqit/broker"
	"github.com/Efruit/marqit/exchange"
	"github.com/Efruit/marqit/trader"
	"github.com/nu7hatch/gouuid"
)

type MiniMarket interface {
	Bank
	Ticker
	exchange.Dealership
	exchange.Auctioner
	RunID() (uuid.UUID, uint64, exchange.Mode)
	Licensee(exchange.LicenseID) trader.Trader
	List() []exchange.Stock
	Status() bool
}

type TraderMaker func(MiniMarket) trader.Trader

type BrokerMaker func(MiniMarket) broker.Broker

type TraderCfg struct {
	Type  string
	Count uint64
}

type Broker interface {
	RegisterBroker(string, BrokerMaker) // Add a broker
	Brokers() []broker.Broker
	RegisterTrader(string, TraderMaker)
	Traders() []trader.Trader
	Licensee(exchange.LicenseID) trader.Trader
	SetCount(...TraderCfg)                   // Configure the Market's trader generators
	CreateTrader(string, exchange.LicenseID) // Add a trader with the specified LicenseID
	SpawnTraders()                           // Create the trader goroutines
	Retire(exchange.LicenseID)               // Revoke a LicenseID
}
