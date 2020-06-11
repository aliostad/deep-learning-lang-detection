package linda

import (
	"errors"
	neturl "net/url"
	"time"
	"strconv"
)

var (
	UnknownBroker = errors.New("unknown broker scheme")
)

// Broker is message transport[MQ]
// it provides a unified API, support multi drivers
type Broker interface {
	Connect(rawUrl string, timeout time.Duration) error
	Close() error
	MigrateExpiredJobs(queue string)
	Reserve(queue string, timeout int64) (string, error)
	Delete(queue, id string) error
	Release(queue, id string, delay int64) error
	Push(queue, id string) error
	Later(queue, id string, delay int64) error
}

var brokerMaps = make(map[string]Broker)

// RegisterBroker is used to register brokers with scheme name
// You can use your own broker driver
func RegisterBroker(scheme string, broker Broker) {
	if broker == nil {
		panic("Register broker is nil")
	}
	brokerMaps[scheme] = broker
}

// NewBroker will get an instance of broker with url string
// if there is no matched scheme, return error
// now broker only support redis
func NewBroker(rawUrl string) (Broker, error) {
	url, err := neturl.Parse(rawUrl)
	if err != nil {
		return nil, err
	}
	scheme := url.Scheme
	timeout, err := strconv.Atoi(url.Query().Get("timeout"))
	if err != nil {
		timeout = 1000
	}
	if b, ok := brokerMaps[scheme]; ok {
		err := b.Connect(rawUrl, time.Duration(timeout)*time.Millisecond)
		if err != nil {
			return nil, err
		}
		return b, nil
	}
	return nil, UnknownBroker
}

func init() {
	RegisterBroker("redis", &RedisBroker{})
}
