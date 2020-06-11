package publisher

import (
	//"fmt"

	pb "github.com/ericnorway/arbitraryFailures/proto"
)

// brokerInfo contains important information about a broker
type brokerInfo struct {
	id   uint64
	addr string
	key  []byte
	toCh chan pb.Publication
}

// AddBroker adds a broker to the map of brokers.
// It takes as input the broker's id, address, and shared private key.
func (p *Publisher) AddBroker(id uint64, addr string, key []byte) {
	//fmt.Printf("Broker info to %v added.\n", id)

	p.brokersMutex.Lock()
	defer p.brokersMutex.Unlock()

	p.brokers[id] = brokerInfo{
		id:   id,
		addr: addr,
		key:  key,
		toCh: nil,
	}
}

// RemoveBroker removes a broker from the map of brokers.
// It takes as input the id of the broker.
func (p *Publisher) RemoveBroker(id uint64) {
	//fmt.Printf("Broker info to %v removed.\n", id)

	p.brokersMutex.Lock()
	defer p.brokersMutex.Unlock()

	delete(p.brokers, id)
}

// addChannel adds a channel to a broker in the broker info map.
// It returns the new channel. It takes as input the id
// of the broker.
func (p *Publisher) addChannel(id uint64) chan pb.Publication {
	//fmt.Printf("Channel to broker %v added.\n", id)

	p.brokersMutex.Lock()
	defer p.brokersMutex.Unlock()

	ch := make(chan pb.Publication, 32)

	// Update channel
	tempBroker := p.brokers[id]
	tempBroker.toCh = ch
	p.brokers[id] = tempBroker

	p.brokerConnections++
	return ch
}

// removeChannel removes a channel from a broker in the broker info map.
// It takes as input the id of the broker.
func (p *Publisher) removeChannel(id uint64) {
	//fmt.Printf("Channel to broker %v removed.\n", id)

	p.brokersMutex.Lock()
	defer p.brokersMutex.Unlock()

	// Update channel
	tempBroker := p.brokers[id]
	tempBroker.toCh = nil
	p.brokers[id] = tempBroker

	p.brokerConnections--
}
