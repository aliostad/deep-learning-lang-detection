package main

import (
	"sync"
)

type ConnectionsManager struct {
	connections      map[uint64]*Connection
	namedConnections map[string]uint64
	indexMutex       sync.RWMutex
	currentIndex     uint64
}

func (manager *ConnectionsManager) GenerateIndex() uint64 {
	manager.indexMutex.Lock()
	defer manager.indexMutex.Unlock()

	manager.currentIndex++

	return manager.currentIndex
}

func (manager *ConnectionsManager) GetCurrentIndex() uint64 {
	manager.indexMutex.RLock()
	defer manager.indexMutex.RUnlock()

	return manager.currentIndex
}

func (manager *ConnectionsManager) AddConnection(conn *Connection) uint64 {
	conn.id = manager.GenerateIndex()
	manager.connections[conn.id] = conn
	manager.namedConnections[conn.uuid] = conn.id
	return conn.id
}

func (manager *ConnectionsManager) RemoveConnection(ind uint64) {
	//conn := manager.connections[ind]
	delete(manager.connections, ind)
}

func (manager *ConnectionsManager) RemoveConnectionByUUID(uuid string) {
	ind := manager.namedConnections[uuid]
	manager.RemoveConnection(ind)
}

func (manager *ConnectionsManager) GetConnectionsUUIDs() []string {
	var uuids []string = make([]string, len(manager.connections))
	var i int = 0
	for _, conn := range manager.connections {
		uuids[i] = conn.uuid
		i++
	}

	return uuids
}

func (manager *ConnectionsManager) GetConnection(id uint64) *Connection {
	return manager.connections[id]
}
func (manager *ConnectionsManager) GetConnectionByUUID(uuid string) *Connection {
	return manager.connections[manager.namedConnections[uuid]]
}

func NewConnectionsManager() ConnectionsManager {
	manager := new(ConnectionsManager)

	manager.connections = make(map[uint64]*Connection)
	manager.namedConnections = make(map[string]uint64)

	return *manager
}
