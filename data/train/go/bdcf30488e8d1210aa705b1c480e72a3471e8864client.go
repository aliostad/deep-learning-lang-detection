package client

import (
	"github.com/micro/go-micro/broker"
	"github.com/micro/go-micro/client"
	"github.com/micro/go-micro/registry"
	"github.com/micro/go-micro/selector"
	"github.com/micro/go-micro/selector/cache"
	"github.com/micro/go-micro/transport"

	"github.com/micro/go-micro/registry/consul"

	"github.com/neverlee/microframe/config"
)

type ClientOpts struct {
	RequestTimeout  config.Duration `yaml:"request_timeout" json:"request_timeout"` // Default: 5s
	Retries         int             `yaml:"retries" json:"retries"`                 // Default: 1
	PoolSize        int             `yaml:"pool_size" json:"pool_size"`             // Default: 0
	PoolTTL         config.Duration `yaml:"pool_ttl" json:"pool_ttl"`               // Default: 1m
	BrokerAddress   []string        `yaml:"broker_address" json:"broker_address"`
	RegistryAddress []string        `yaml:"registry_address" json:"registry_address"`
	Selector        string          `yaml:"selector" json:"selector"`
	// Broker          string   `yaml:"broker"`
	// Registry        string   `yaml:"registry"`
	// TransportAddress []string `yaml:"address"` // default
}

var DefaultClient *Client

type Client struct {
	opts      *ClientOpts
	broker    broker.Broker
	registry  registry.Registry
	selector  selector.Selector
	transport transport.Transport

	client.Client
}

func NewClient(opts *ClientOpts) *Client {
	cli := Client{
		opts:      opts,
		broker:    broker.DefaultBroker,
		registry:  registry.DefaultRegistry,
		transport: transport.DefaultTransport,
		selector:  selector.DefaultSelector,
		// client:    client.DefaultClient,
		Client: client.DefaultClient,
	}

	switch opts.Selector {
	case "", "default":
		cli.selector = selector.NewSelector()
	case "cache":
		cli.selector = cache.NewSelector()
	}

	cli.broker = broker.NewBroker(broker.Addrs(opts.BrokerAddress...))
	cli.registry = consul.NewRegistry(registry.Addrs(opts.RegistryAddress...))

	cli.selector.Init(
		selector.Registry(cli.registry),
	)
	cli.broker.Init(
		broker.Registry(cli.registry),
	)
	cli.Client.Init(
		client.Retries(opts.Retries),
		client.RequestTimeout(opts.RequestTimeout.Value()),
		client.PoolSize(opts.PoolSize),
		client.PoolTTL(opts.PoolTTL.Value()),

		client.Broker(cli.broker),
		client.Registry(cli.registry),
		client.Transport(cli.transport),
		client.Selector(cli.selector),
	)

	return &cli
}
