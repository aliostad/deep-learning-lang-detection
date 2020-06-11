package models

import (
	"fmt"
)

//Contains Broker Information
type Broker struct {
	ID              string `json:"id"`
	IP              string `json:"ip"`
	InternetDomain  string `json:"internetDomain"`
	Geolocation     *Geolocation `json:"geolocation"`
	RealWorldDomain *RealWorldDomain `json:"realWorldDomain"`
	Statistics      *BrokerStatistics `json:"statitics"`
}


func NewBroker() *Broker {
	broker := new(Broker)
	broker.ID = ""
	broker.IP = ""
	broker.InternetDomain = ""
	broker.Geolocation = new(Geolocation)
	broker.RealWorldDomain = NewRealWorldDomain("default")
	broker.Statistics = NewBrokerStatistics()
	return broker
}

func (broker *Broker) String() string {
	return fmt.Sprintf("ID: %s, IP: %s, interDomain: %s, geolocation: %s, realWorldDomains: %s", broker.ID, broker.IP, broker.InternetDomain, broker.Geolocation, broker.RealWorldDomain)
}

