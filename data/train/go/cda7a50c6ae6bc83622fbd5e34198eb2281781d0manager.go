package session

import (
	"hargo/discovery"
	"net"
)

var slaveSafeCommandMap map[string]bool

func init() {

	slaveSafeCommandMap = map[string]bool{
		"get":      true,
		"lrange":   true,
		"smembers": true,
		"hgetall":  true,
	}
}

type Manager struct {
	discov *discovery.Discovery
	cache  *Cache
}

func NewManager(discov *discovery.Discovery, cache *Cache) *Manager {
	manager := &Manager{}
	manager.discov = discov
	manager.cache = cache
	return manager
}

func (m *Manager) NewCommandSession(client net.Conn) *CommandSession {
	return &CommandSession{manager: m, client: client, isHA: true, readBuf: make([]byte, 4096)}
}
