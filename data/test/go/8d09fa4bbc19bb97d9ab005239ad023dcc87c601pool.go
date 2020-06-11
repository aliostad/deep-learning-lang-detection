package cluster

import (
	"sync"

	"h12.me/kpax/model"
	"h12.me/kpax/log"
)

type brokerPool struct {
	addrBroker           map[string]model.Broker
	idAddr               map[int32]string
	topicPartitionLeader map[topicPartition]model.Broker
	groupCoordinator     map[string]model.Broker
	newBroker            func(string) model.Broker
	mu                   sync.Mutex
}

type topicPartition struct {
	topic     string
	partition int32
}

func newBrokerPool(newBroker func(string) model.Broker) *brokerPool {
	return &brokerPool{
		addrBroker:           make(map[string]model.Broker),
		idAddr:               make(map[int32]string),
		topicPartitionLeader: make(map[topicPartition]model.Broker),
		groupCoordinator:     make(map[string]model.Broker),
		newBroker:            newBroker,
	}
}

func (p *brokerPool) Brokers() (map[string]model.Broker, error) {
	if len(p.addrBroker) > 0 {
		return p.addrBroker, nil
	}
	return nil, ErrNoBrokerFound
}

func (p *brokerPool) AddAddr(addr string) model.Broker {
	p.mu.Lock()
	defer p.mu.Unlock()
	return p.addAddr(addr)
}

func (p *brokerPool) addAddr(addr string) model.Broker {
	if broker, ok := p.addrBroker[addr]; ok {
		return broker
	}
	broker := p.newBroker(addr)
	p.addrBroker[addr] = broker
	return broker
}

func (p *brokerPool) add(brokerID int32, addr string) model.Broker {
	p.idAddr[brokerID] = addr
	return p.addAddr(addr)
}

func (p *brokerPool) Add(brokerID int32, addr string) model.Broker {
	p.mu.Lock()
	defer p.mu.Unlock()
	return p.add(brokerID, addr)
}

func (p *brokerPool) SetLeader(topic string, partition int32, brokerID int32) error {
	p.mu.Lock()
	defer p.mu.Unlock()
	broker, err := p.find(brokerID)
	if err != nil {
		return err
	}
	p.topicPartitionLeader[topicPartition{topic, partition}] = broker
	return nil
}

func (p *brokerPool) GetLeader(topic string, partition int32) (model.Broker, error) {
	p.mu.Lock()
	defer p.mu.Unlock()
	broker, ok := p.topicPartitionLeader[topicPartition{topic, partition}]
	if !ok {
		return nil, ErrLeaderNotFound
	}
	return broker, nil
}

func (p *brokerPool) DeleteLeader(topic string, partition int32) {
	p.mu.Lock()
	defer p.mu.Unlock()
	delete(p.topicPartitionLeader, topicPartition{topic, partition})
}

func (p *brokerPool) DeleteCoordinator(consumerGroup string) {
	p.mu.Lock()
	defer p.mu.Unlock()
	delete(p.groupCoordinator, consumerGroup)
}

func (p *brokerPool) SetCoordinator(consumerGroup string, brokerID int32, addr string) {
	p.mu.Lock()
	defer p.mu.Unlock()
	broker := p.add(brokerID, addr)
	p.groupCoordinator[consumerGroup] = broker
}

func (p *brokerPool) GetCoordinator(consumerGroup string) (model.Broker, error) {
	p.mu.Lock()
	defer p.mu.Unlock()
	broker, ok := p.groupCoordinator[consumerGroup]
	if !ok {
		return nil, ErrCoordNotFound
	}
	return broker, nil
}

func (p *brokerPool) find(brokerID int32) (model.Broker, error) {
	if addr, ok := p.idAddr[brokerID]; ok {
		if broker, ok := p.addrBroker[addr]; ok {
			return broker, nil
		}
	}
	log.Debugf("cannot find broker %d", brokerID)
	return nil, ErrNoBrokerFound
}

type topicPartitions struct {
	m  map[string][]int32
	mu sync.Mutex
}

func newTopicPartitions() *topicPartitions {
	return &topicPartitions{
		m: make(map[string][]int32),
	}
}

func (tp *topicPartitions) getPartitions(topic string) []int32 {
	tp.mu.Lock()
	defer tp.mu.Unlock()
	return tp.m[topic]
}

func (tp *topicPartitions) addPartitions(topic string, partitions []int32) {
	tp.mu.Lock()
	defer tp.mu.Unlock()
	tp.m[topic] = partitions
}
