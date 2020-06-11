package transaction

import (
	"fmt"
	"sync"

	"github.com/jinzhu/gorm"
)

func NewManager(connection *gorm.DB) *Manager {
	manager := new(Manager)
	manager.counter = 0
	manager.connection = connection
	manager.storage = make(map[string]*Adapter)

	return manager
}

type Manager struct {
	mutex      sync.Mutex
	counter    uint64
	connection *gorm.DB
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

// Checkout returns gorm transaction
// if transaction not found will fail with NotFound error
func (manager *Manager) Checkout(key string) (*gorm.DB, error) {
	manager.mutex.Lock()
	defer manager.mutex.Unlock()

	if transaction, exist := manager.storage[key]; exist {
		return transaction.origin, nil
	}

	return nil, NotFound{key}
}

// Start creates and returns transaction
func (manager *Manager) Start(operation string) (*Adapter, error) {
	transaction := New(manager.connection)

	go manager.observe(transaction)

	manager.mutex.Lock()
	defer manager.mutex.Unlock()

	manager.counter++
	transaction.key = fmt.Sprintf("%s-%d", operation, manager.counter)
	manager.storage[transaction.key] = transaction

	return transaction, nil
}
