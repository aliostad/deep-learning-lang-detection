package allthingstalk

import (
	"fmt"
	MQTT "git.eclipse.org/gitroot/paho/org.eclipse.paho.mqtt.golang.git"
	io "github.com/gillesdemey/All-Things-Go/io"
	"log"
)

var brokerUri = "tcp://broker.smartliving.io:1883"

// MQTT Broker structure
type Broker struct {
	Client *MQTT.MqttClient
}

// Create a new broker connection and subscribe to the correct
// topic for this device
func NewBroker(device *Device) (*Broker, error) {

	// TODO: abstract the MessageHandler function
	msgHandler := func(client *MQTT.MqttClient, msg MQTT.Message) {
		log.Printf("TOPIC: %s\n", msg.Topic())
		log.Printf("MSG: %s\n", msg.Payload())
	}

	opts := MQTT.NewClientOptions()

	opts.AddBroker(brokerUri)
	opts.SetClientID(device.DeviceID[:23]) // max 24 characters long
	opts.SetDefaultPublishHandler(msgHandler)

	broker := &Broker{
		Client: MQTT.NewClient(opts),
	}

	_, err := broker.Client.Start()

	if err != nil {
		return nil, err
	}

	err = broker.subscribeToTopic(device)

	if err != nil {
		return nil, err
	}

	return broker, nil
}

// Subscribes to the device's MQTT topic
func (broker *Broker) subscribeToTopic(device *Device) error {

	filter, err := MQTT.NewTopicFilter(buildTopic(device), byte(0)) // default QoS

	if err != nil {
		return err
	}

	_, err = broker.Client.StartSubscription(nil, filter)

	if err != nil {
		return err
	}

	return nil
}

// Helper functions to build the correct URI's
func buildAssetUri(device *Device, iodev *io.IODevice) string {
	return fmt.Sprintf("%s/api/asset/%s%s", httpUri, device.DeviceID, iodev.Id)
}

func buildTopic(device *Device) string {
	return fmt.Sprintf("m/%s/d/%s/#", device.ClientID, device.DeviceID)
}
