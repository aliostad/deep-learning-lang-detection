// Package mqttservices provides an MQTT broker, topic subscription and publishing methods
package mqttservices

import (
	"github.com/jeffallen/mqtt"

	"log"
	"net"
)

//MqttBroker struct
type MqttBroker struct {
	port string
}

//NewBroker declares a new broker
func NewBroker(port string) *MqttBroker {
	return &MqttBroker{port: port}
}

//Run the broker
func (b *MqttBroker) Run() {

	l, err := net.Listen("tcp", b.port)
	gotError(err)

	svr := mqtt.NewServer(l)
	svr.Start()
	<-svr.Done
}

//Generic Function to catch errors
func gotError(err error) {
	if err != nil {
		log.Fatal(err)
	}
}
