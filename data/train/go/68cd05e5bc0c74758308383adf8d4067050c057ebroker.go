package broker

import (
	"os"
	"path"
	"sync"
)

type Broker struct {
	mu         sync.Mutex
	topicStore map[string]Store
	dataDir    string
}

func (broker *Broker) Write(topic, data []byte) error {

	if store, err := broker.getStore(topic, true); err == nil {
		return store.Write(data)
	} else {
		return err
	}
}

func (broker *Broker) Read(topic, group []byte, size int) ([][]byte, error) {

	if store, err := broker.getStore(topic, false); err == nil {
		var data [][]byte
		if store != nil {
			if data, err = store.Read(group, size); err != nil {
				return nil, err
			}
		}
		return data, nil

	} else {
		return nil, err
	}

}

func (broker *Broker) getStore(topic []byte, createIfNotExit bool) (Store, error) {
	broker.mu.Lock()
	defer broker.mu.Unlock()
	if store, ok := broker.topicStore[string(topic)]; ok {
		return store, nil
	}

	if _, err := os.Stat(path.Join(broker.dataDir, string(topic))); createIfNotExit || err == nil {
		store := NewBrokerStore(broker.dataDir, string(topic))
		broker.topicStore[string(topic)] = store
		return store, nil
	}

	return nil, nil
}

func NewBroker(dataDir string) *Broker {
	return &Broker{dataDir: dataDir, topicStore: make(map[string]Store)}
}
