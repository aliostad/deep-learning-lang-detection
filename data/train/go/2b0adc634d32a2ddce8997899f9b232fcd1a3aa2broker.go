package broker

import (
	"net"
)

type Broker struct {
	//
	cfg *Config

	// tcp 监听
	listener net.Listener

	// 存储
	//msgStore Store

	// 消息队列
	queues map[string]*Queue
}

func (brokerServer *Broker) Run() {
	for {
		conn, err := brokerServer.listener.Accept()

		if err != nil {
			continue
		}

		// 新建连接
		co := newConnection(brokerServer, conn)
		// 开始处理
		go co.run()
	}
}

func NewBrokerWithConfig(cfg *Config) (*Broker, error) {
	brokerServer := new(Broker)

	brokerServer.cfg = cfg

	brokerServer.queues = make(map[string]*Queue)

	var err error

	brokerServer.listener, err = net.Listen(cfg.AddrType, cfg.Addr)
	if err != nil {
		return nil, err
	}

	return brokerServer, nil
}
