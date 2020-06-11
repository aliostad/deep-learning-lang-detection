package pham

import (
	"encoding/json"
	"log"
	"sync"
)

var (
	manager = &ConnectionManager{
		connections: make([]Connection, 0, 100),
		connMutex:   new(sync.Mutex),
		connAdd:     make(chan Connection, 1),
		connDel:     make(chan Connection, 1),
	}
)

// NewConnectionManager is ConnectionManager constructor
func NewConnectionManager() (connectionManager *ConnectionManager) {
	connectionManager = manager

	// watch add & delete event
	go func() {
		for {
			func() {
				select {
				case conn := <-manager.connAdd:
					log.Println("server: new connection")
					manager.connMutex.Lock()
					defer manager.connMutex.Unlock()

					manager.connections = append(manager.connections, conn)
					log.Println("connections:", len(manager.connections))

				case conn := <-manager.connDel:
					log.Println("server: connection closed")
					manager.connMutex.Lock()
					defer manager.connMutex.Unlock()

					for i, ws := range manager.connections {
						if ws == conn {
							manager.connections = append(manager.connections[:i], manager.connections[i+1:]...)
							log.Println("connections:", len(manager.connections))
							break
						}
					}
				}
			}()
		}
	}()

	return
}

// AddConnection add connection to connections
func (manager *ConnectionManager) AddConnection(conn Connection) {
	manager.connAdd <- conn
}

// DelConnection delete connection from connections
func (manager *ConnectionManager) DelConnection(conn Connection) {
	manager.connDel <- conn
}

// Broadcast message
func (manager *ConnectionManager) Broadcast(data JSON) (length int, err error) {
	defer manager.connMutex.Unlock()
	manager.connMutex.Lock()

	// get connections length
	length = len(manager.connections)

	// encode json
	bytes, err := json.Marshal(data)
	if err != nil {
		return
	}

	// broadcast
	for _, connection := range manager.connections {
		err = connection.Send(bytes)
		if err != nil {
			return
		}
	}

	return
}

// ConnEach get connections safety
func (manager *ConnectionManager) ConnEach(f func([]Connection)) {
	defer manager.connMutex.Unlock()
	manager.connMutex.Lock()
	f(manager.connections)
}
