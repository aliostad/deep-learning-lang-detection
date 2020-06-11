package broker

import (
	"errors"
	"fmt"
	"log"
	"path"
	"sync"
)

var NO_READ_STORE_ERROR = errors.New("no read store")

type BrokerStore struct {
	mu            sync.Mutex
	writeStore    Store
	writeStoreSeq uint32
	meta          *Meta
	dataDir       string
	name          string
	mur           sync.Mutex
	readStores    map[string]Store
}

func (brokerStore *BrokerStore) Write(data []byte) error {

	brokerStore.mu.Lock()
	defer brokerStore.mu.Unlock()

	err := brokerStore.doWrite(data)

	if err != nil {
		if err == STORE_CLOSED_ERROR {
			brokerStore.writeStore = GetStore(path.Join(brokerStore.dataDir, brokerStore.name, fmt.Sprintf("%06d", brokerStore.writeStoreSeq)), brokerStore.meta)
			return brokerStore.doWrite(data)
		}

		if err == FULL_SIZE_ERROR {
			err = brokerStore.rollingWriteStore()
			if err != nil {
				return err
			}
			return brokerStore.doWrite(data)
		}

		return err
	}

	return nil

}

func (brokerStore *BrokerStore) doWrite(data []byte) error {
	return brokerStore.writeStore.Write(data)
}

func (brokerStore *BrokerStore) Read(group []byte, size int) ([][]byte, error) {

	store, err := brokerStore.getReadStore(group)
	if err != nil {
		if err == NO_READ_STORE_ERROR {
			return make([][]byte, 0), nil
		}
		return nil, err
	}

	data, err := store.Read(group, size)

	if err != nil {
		if err == EOF_ERROR {
			if err := brokerStore.rollingReadStore(group); err != nil {
				return nil, err
			} else {
				return brokerStore.Read(group, size)
			}
		}
		return nil, err
	}
	return data, nil
}

func (brokerStore *BrokerStore) Close() error {
	if brokerStore.writeStore != nil {
		err := brokerStore.writeStore.Close()
		return err
	}

	for _, v := range brokerStore.readStores {
		err := v.Close()
		if err != nil {
			return err
		}
	}

	return nil

}

func (brokerStore *BrokerStore) getReadStore(group []byte) (Store, error) {

	brokerStore.mur.Lock()
	defer brokerStore.mur.Unlock()
	brokerStoreueue, ok := brokerStore.readStores[string(group)]

	if !ok {
		brokerStoreueue, ok = brokerStore.readStores[string(group)]
		readStoreSeq, err := brokerStore.meta.GetReadStoreSeq(group)
		if err != nil {
			return nil, err
		}

		dataDir := path.Join(brokerStore.dataDir, brokerStore.name, fmt.Sprintf("%06d", readStoreSeq))
		log.Printf("Open read brokerStoreueue[%s] for %s", dataDir, group)
		brokerStoreueue = GetStore(dataDir, brokerStore.meta)
		brokerStore.readStores[string(group)] = brokerStoreueue
	}

	return brokerStoreueue, nil

}

func (brokerStore *BrokerStore) rollingReadStore(group []byte) error {
	brokerStore.mur.Lock()
	defer brokerStore.mur.Unlock()

	readStoreSeq, err := brokerStore.meta.GetReadStoreSeq(group)
	if err != nil {
		return err
	}

	if err := brokerStore.meta.SetReadPosition(group, uint64(0)); err != nil {
		return err
	}

	if readStoreSeq+1 > brokerStore.writeStoreSeq {
		return NO_READ_STORE_ERROR
	}
	newReadSebrokerStore := readStoreSeq + 1
	if err := brokerStore.meta.SetReadStoreSeq(group, newReadSebrokerStore); err != nil {
		return err
	}
	log.Printf("rolling read brokerStoreueue for %s to from %d to %d ", group, readStoreSeq, newReadSebrokerStore)

	delete(brokerStore.readStores, string(group))

	return nil

}

func (brokerStore *BrokerStore) rollingWriteStore() error {
	writeStoreSeq, err := brokerStore.meta.GetWriteStoreSeq()
	if err != nil {
		return err
	}
	newDataDir := path.Join(brokerStore.dataDir, brokerStore.name, fmt.Sprintf("%06d", writeStoreSeq+1))
	writeStore := GetStore(newDataDir, brokerStore.meta)

	if err := brokerStore.meta.SetSize(uint64(0)); err != nil {
		return err
	}

	if err := brokerStore.meta.SetWriteStoreSeq(writeStoreSeq + 1); err != nil {
		return err
	}

	brokerStore.writeStore = writeStore
	brokerStore.writeStoreSeq = writeStoreSeq

	return nil
}

func NewBrokerStore(dataDir, name string) *BrokerStore {

	meta := NewMeta(path.Join(dataDir, name))

	writeStoreSeq, err := meta.GetWriteStoreSeq()

	if err != nil {
		panic(err)
	}

	writeStore := GetStore(path.Join(dataDir, name, fmt.Sprintf("%06d", writeStoreSeq)), meta)

	return &BrokerStore{writeStore: writeStore, writeStoreSeq: writeStoreSeq, meta: meta, name: name, dataDir: dataDir, readStores: make(map[string]Store)}
}
