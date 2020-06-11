package subscriber

import (
	//"fmt"

	pb "github.com/ericnorway/arbitraryFailures/proto"
)

// brokerInfo contains important information about a broker
type brokerInfo struct {
	id   uint64
	addr string
	key  []byte
	toCh chan pb.SubRequest
}

// AddBroker adds a broker to the map of brokers.
// It takes as input the broker's id, address, and shared private key.
func (s *Subscriber) AddBroker(id uint64, addr string, key []byte) {
	//fmt.Printf("Info for broker %v added.\n", id)

	s.brokersMutex.Lock()
	defer s.brokersMutex.Unlock()

	s.brokers[id] = brokerInfo{
		id:   id,
		addr: addr,
		key:  key,
		toCh: nil,
	}
}

// RemoveBroker removes a broker from the map of brokers.
// It takes as input the id of the broker.
func (s *Subscriber) RemoveBroker(id uint64) {
	//fmt.Printf("Info for broker %v removed.\n", id)

	s.brokersMutex.Lock()
	defer s.brokersMutex.Unlock()

	delete(s.brokers, id)
}

// addChannel adds a channel to a broker in the broker info map.
// It returns the new channel. It takes as input the id
// of the broker.
func (s *Subscriber) addChannel(id uint64) chan pb.SubRequest {
	//fmt.Printf("Channel to broker %v added.\n", id)

	s.brokersMutex.Lock()
	defer s.brokersMutex.Unlock()

	ch := make(chan pb.SubRequest, 32)

	// Update channel
	tempBroker := s.brokers[id]
	tempBroker.toCh = ch
	s.brokers[id] = tempBroker

	s.brokerConnections++
	return ch
}

// removeChannel removes a channel from a broker in the broker info map.
// It takes as input the id of the broker.
func (s *Subscriber) removeChannel(id uint64) {
	//fmt.Printf("Channel to broker %v removed.\n", id)

	s.brokersMutex.Lock()
	defer s.brokersMutex.Unlock()

	// Update channel
	tempBroker := s.brokers[id]
	tempBroker.toCh = nil
	s.brokers[id] = tempBroker

	s.brokerConnections--
}
