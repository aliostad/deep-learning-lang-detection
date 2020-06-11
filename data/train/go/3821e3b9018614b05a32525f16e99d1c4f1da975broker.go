package broker

import (
	"bytes"
	"encoding/binary"
	"encoding/json"
	"net"
    "fmt"
    "encoding/hex"
)

type (
	BrokerMessagePayload struct {
		Payload *string `json:"payload,omitempty"`
	}
	BrokerActionInfo struct {
		Destination     *string               `json:"destination"`
		ActionType      string                `json:"action_type"`
		DestinationType string                `json:"destination_type"`
		Message         *BrokerMessagePayload `json:"message,omitempty"`
	}
	BrokerAction struct {
		PublishInfo   *BrokerActionInfo `json:"publish,omitempty"`
		SubscribeInfo *BrokerActionInfo `json:"subscribe,omitempty"`
	}
	BrokerMessage struct {
		Action *BrokerAction `json:"action"`
	}
)

// NewPublishMessage builds a BrokerMessage primed to act as a message to a given topic
func NewPublishMessage(topic string, message *string) *BrokerMessage {
	return &BrokerMessage{
		Action: &BrokerAction{
			PublishInfo: &BrokerActionInfo{
				ActionType:      "PUBLISH",
				Destination:     &topic,
				DestinationType: "TOPIC",
				Message: &BrokerMessagePayload{
					Payload: message,
				},
			},
		},
	}
}

// NewSubscribeMessage builds a BrokerMessage primed to act as a subscription request
func NewSubscribeMessage(topic string) *BrokerMessage {
	return &BrokerMessage{
		Action: &BrokerAction{
			SubscribeInfo: &BrokerActionInfo{
				ActionType:      "SUBSCRIBE",
				Destination:     &topic,
				DestinationType: "TOPIC",
				Message:         nil,
			},
		},
	}
}

// pack turns a BrokerMessage into a byte array for sending over the wire
func pack(msg *BrokerMessage) []byte {
	b, _ := json.Marshal(*msg)
	buf := new(bytes.Buffer)
	var data = []interface{}{
		uint16(3),     // JSON transport
		uint16(0),     // version
		int32(len(b)), // payload length
		b,
	}

	for _, item := range data {
		binary.Write(buf, binary.BigEndian, item)
	}
	return buf.Bytes()
}

// Publisher takes an open connection, a broker topic and an input channel and publishes to that
// topic until the channel is closed.
func Publisher(conn net.Conn, topic string, in <-chan string) {
    fmt.Println("Publisher started")
	for message := range in {
        fmt.Println("Got message")
        msg := NewPublishMessage(topic, &message)
		b, _ := json.Marshal(*msg)
		fmt.Println(string(b))
        buf := pack(msg)
        fmt.Println(hex.EncodeToString(buf))
		conn.Write(pack(NewPublishMessage(topic, &message)))
        fmt.Println("Sent")
	}
}
