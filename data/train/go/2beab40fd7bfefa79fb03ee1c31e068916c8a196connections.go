package server

import (
	"strconv"
	"sync"
)

type ConnectionManager struct {
	sync.RWMutex
	index            int64
	connectionsTable map[string]*WSConnection
}

func NewConnectionManager() *ConnectionManager {
	return &ConnectionManager{
		connectionsTable: make(map[string]*WSConnection),
	}
}

func (manager *ConnectionManager) GenID() string {
	manager.Lock()
	manager.index = manager.index + 1
	index := manager.index
	manager.Unlock()

	return strconv.FormatInt(index, 10)
}

func (manager *ConnectionManager) OnConnect(id string, connection *WSConnection) {
	//log.Println("connections onConnect", id)
	manager.Lock()
	manager.connectionsTable[id] = connection
	manager.Unlock()
}

func (manager *ConnectionManager) OnDisconnect(id string) {
	//log.Println("connections onDisconnect", id)
	manager.Lock()
	delete(manager.connectionsTable, id)
	manager.Unlock()
}

func (manager *ConnectionManager) Broadcast(v interface{}) {
	manager.RLock()
	for _, connection := range manager.connectionsTable {
		connection.Send(v)
	}
	manager.RUnlock()
}
