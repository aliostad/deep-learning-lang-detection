package broker_test

import (
	"github.com/buptmiao/msgo/broker"
	"sync"
	"testing"
)

//Only one broker
var OneLoad sync.Once

func loadConfig() {
	OneLoad.Do(broker.LoadConfig)
}

func TestArbitrateConfigs(t *testing.T) {
	s := make(chan struct{}, 1)
	Config := &broker.Configure{
		HttpPort: 12345,
		MsgPort:  12345,
	}
	func() {
		defer EatPanic(s)
		broker.ArbitrateConfigs(Config)
	}()
	<-s

	Config = &broker.Configure{
		HttpPort: 1000,
		MsgPort:  12345,
	}
	func() {
		defer EatPanic(s)
		broker.ArbitrateConfigs(Config)
	}()
	<-s

	Config = &broker.Configure{
		HttpPort: 12345,
		MsgPort:  1000,
	}
	func() {
		defer EatPanic(s)
		broker.ArbitrateConfigs(Config)
	}()
	<-s

	Config = &broker.Configure{
		HttpPort: 12345,
		MsgPort:  12346,
		Retry:    11,
	}
	broker.ArbitrateConfigs(Config)
	if Config.Retry != 10 {
		panic("")
	}

	Config = &broker.Configure{
		HttpPort: 12345,
		MsgPort:  12346,
		Retry:    0,
	}
	broker.ArbitrateConfigs(Config)
	if Config.Retry != 1 {
		panic("")
	}

	Config = &broker.Configure{
		HttpPort: 12345,
		MsgPort:  12346,
		Retry:    5,
		SyncType: 3,
	}
	broker.ArbitrateConfigs(Config)
	if Config.SyncType != 0 {
		panic("")
	}

	Config = &broker.Configure{
		HttpPort:  12345,
		MsgPort:   12346,
		Retry:     5,
		Threshold: 100,
	}
	broker.ArbitrateConfigs(Config)
	if Config.Threshold != 1000 {
		panic("")
	}

	Config = &broker.Configure{
		HttpPort:  12345,
		MsgPort:   12346,
		Retry:     5,
		Threshold: 10000000,
	}
	broker.ArbitrateConfigs(Config)
	if Config.Threshold != 1000000 {
		panic("")
	}
}
