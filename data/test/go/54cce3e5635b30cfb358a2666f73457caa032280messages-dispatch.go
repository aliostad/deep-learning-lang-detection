package gorabbit

import "time"

type (
	DispatchChannelRequested struct {
		Context     interface{}
		Credentials Credentials
	}
	DispatchChannelOpened struct {
		Request   DispatchChannelRequested
		ChannelID int
	}
	DispatchChannelFailed struct {
		Request   DispatchChannelRequested
		ChannelID int
	}
	DispatchChannelShutdownRequested struct {
		Context   interface{}
		ChannelID int
	}
	DispatchChannelClosed struct {
		Context   interface{}
		ChannelID int
	}
)

type (
	DispatchRequested struct {
		Context         interface{}
		ChannelID       int // the dispatch channel id through which the message will be sent
		Exchange        string
		RoutingKey      string
		MessageID       string
		Durable         bool
		TTL             time.Duration
		DispatchTimeout time.Duration
		Payload         interface{}
		Marshalling     int
	}
	DispatchReceived struct {
		Request DispatchRequested
	}
	DispatchFailed struct {
		Request DispatchRequested
	}
)

const (
	AlreadyMarshalled = iota
	JSONMarshalling
	XMLMarshalling
)
