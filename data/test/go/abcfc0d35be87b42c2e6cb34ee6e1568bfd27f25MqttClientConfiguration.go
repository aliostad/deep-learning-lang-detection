package models

import "net/url"

// Information necessary for connecting to a MQTT Broker
type MqttClientConfiguration struct {
	brokerAddress *url.URL
	clientID 	string
}


func NewMqttClientConfiguration(brokerAddress *url.URL, clientID string) *MqttClientConfiguration {
	clientConfig := new(MqttClientConfiguration)
	clientConfig.brokerAddress = brokerAddress
	clientConfig.clientID = clientID
	return clientConfig
}

func (config *MqttClientConfiguration) BrokerAddress() string {
	return config.brokerAddress.String()
}


func (config *MqttClientConfiguration) ClientID() string {
	return config.clientID
}
