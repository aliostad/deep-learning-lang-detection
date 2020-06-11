package rpc

import (
	"net"
	"sync"
)

type clientManager struct {
	server  *Server
	clients map[string]*client
	mutex   sync.RWMutex
}

func newClientManager(server *Server) *clientManager {
	return &clientManager{
		server:  server,
		clients: make(map[string]*client),
	}
}

func (manager *clientManager) Add(connection *net.Conn) (*client, error) {
	clientConnection := *connection
	address := clientConnection.RemoteAddr().String()

	if _, exists := manager.get(address); exists {
		return nil, clientAlreadyExistsError(address)
	}

	newClient := &client{
		directory:  manager.server.directory,
		connection: connection,
	}

	manager.mutex.Lock()
	manager.clients[address] = newClient
	manager.mutex.Unlock()

	return newClient, nil
}

func (manager *clientManager) Remove(address string) {
	manager.mutex.Lock()
	defer manager.mutex.Unlock()

	if _, exists := manager.clients[address]; exists {
		delete(manager.clients, address)
	}
}

func (manager *clientManager) get(address string) (*client, bool) {
	manager.mutex.RLock()
	defer manager.mutex.RUnlock()

	requestedClient, exists := manager.clients[address]

	return requestedClient, exists
}
