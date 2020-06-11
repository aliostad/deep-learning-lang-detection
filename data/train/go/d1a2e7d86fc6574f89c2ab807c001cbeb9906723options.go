package common

import (
	"time"

	"github.com/moonwalker/margaret/broker"
	"github.com/moonwalker/margaret/codec"
	"github.com/moonwalker/margaret/transport"
)

const (
	DefaultTimeout = 2 * time.Second
)

type Options struct {
	Codec     codec.Codec
	Broker    broker.Broker
	Transport transport.Transport
	Timeout   time.Duration
}

type Option func(*Options)

func NewOptions(opts ...Option) *Options {
	options := &Options{
		Codec:     NewDefaultCodec(),
		Broker:    NewDefaultBroker(),
		Transport: NewDefaultTransport(),
		Timeout:   DefaultTimeout,
	}

	for _, o := range opts {
		o(options)
	}

	return options
}

func Codec(codec codec.Codec) Option {
	return func(o *Options) {
		o.Codec = codec
	}
}

func Broker(broker broker.Broker) Option {
	return func(o *Options) {
		o.Broker = broker
	}
}

func Transport(transport transport.Transport) Option {
	return func(o *Options) {
		o.Transport = transport
	}
}

func Timeout(timeout time.Duration) Option {
	return func(o *Options) {
		o.Timeout = timeout
	}
}
