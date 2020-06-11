package common

import (
	"github.com/moonwalker/margaret/broker"
	defaultBroker "github.com/moonwalker/margaret/broker/nats"
	"github.com/moonwalker/margaret/codec"
	defaultCodec "github.com/moonwalker/margaret/codec/protobuf"
	"github.com/moonwalker/margaret/transport"
	defaultTransport "github.com/moonwalker/margaret/transport/nats"
)

func NewDefaultCodec() codec.Codec {
	return defaultCodec.NewCodec()
}

func NewDefaultBroker() broker.Broker {
	return defaultBroker.NewBroker()
}

func NewDefaultTransport() transport.Transport {
	return defaultTransport.NewTransport()
}
