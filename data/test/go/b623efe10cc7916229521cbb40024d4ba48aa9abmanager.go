package transaction

import (
	"fmt"
	"sync"

	"gopkg.in/pg.v5"
)

func NewManager(connection *pg.DB) *Manager {
	manager := new(Manager)
	manager.counter = 0
	manager.connection = connection
	manager.storage = make(map[string]*Adapter)

	return manager
}

type Manager struct {
	mutex      sync.Mutex
	counter    uint64
	connection *pg.DB
	storage    map[string]*Adapter
}

func (manager *Manager) observe(transaction *Adapter) {
	result := make(chan error)
	go transaction.wait(result)

	transaction.result <- <-result
	close(transaction.result)

	manager.mutex.Lock()
	defer manager.mutex.Unlock()

	delete(manager.storage, transaction.key)
}

// Checkout returns go-pg transaction
// if transaction not found will fail with NotFound error
func (manager *Manager) Checkout(key string) (*pg.Tx, error) {
	manager.mutex.Lock()
	defer manager.mutex.Unlock()

	if transaction, exist := manager.storage[key]; exist {
		return transaction.origin, nil
	}

	return nil, NotFound{key}
}

// Start creates and returns database transaction
func (manager *Manager) Start(operation string) (*Adapter, error) {
	transaction, err := New(manager.connection)

	go manager.observe(transaction)

	if err != nil {
		return transaction, err
	}

	manager.mutex.Lock()
	defer manager.mutex.Unlock()

	manager.counter++
	transaction.key = fmt.Sprintf("%s-%d", operation, manager.counter)
	manager.storage[transaction.key] = transaction

	return transaction, nil
}
