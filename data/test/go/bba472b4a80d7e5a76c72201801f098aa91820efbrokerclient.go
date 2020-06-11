package brokerclient

import (
	"errors"
	"io/ioutil"

	MQTT "github.com/eclipse/paho.mqtt.golang"
	"github.com/labstack/echo"
)

type BrokerClient struct {
	mqtt MQTT.Client
}

func (bc *BrokerClient) publish(topic string, payload []byte) error {
	token := bc.mqtt.Publish(topic, 0, false, payload)
	token.Wait()

	return token.Error()
}

// Connect connects to broker
func Connect() (*BrokerClient, error) {
	opts := MQTT.NewClientOptions()
	opts.AddBroker("tcp://wormhole-broker:1883")
	opts.SetAutoReconnect(true)

	mqtt := MQTT.NewClient(opts)

	if token := mqtt.Connect(); token.Wait() && token.Error() != nil {
		return nil, token.Error()
	}

	return &BrokerClient{mqtt: mqtt}, nil
}

// PublishBroadcast publishes broadcast to broker
func PublishBroadcast(c echo.Context) error {
	bc, ok := c.Get("BrokerClient").(*BrokerClient)
	if !ok {
		return errors.New("Failed to get BrokerClient from context")
	}

	body, err := ioutil.ReadAll(c.Request().Body)
	if err != nil {
		return err
	}

	return bc.publish("wormhole/broadcast", body)
}

// SetBrokerClient is a middleware responsible for setting 'bc' as BrokerClient in the context
func SetBrokerClient(bc *BrokerClient) func(echo.HandlerFunc) echo.HandlerFunc {
	return func(next echo.HandlerFunc) echo.HandlerFunc {
		return func(c echo.Context) error {
			c.Set("BrokerClient", bc)
			return next(c)
		}
	}
}
