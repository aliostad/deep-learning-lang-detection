package halo

import (
	"errors"
	"net"
	"sync"

	"github.com/bohler/halo/service"
	log "github.com/bohler/lib/dlog"
)

var DefaultNetService = newNetService()

type netService struct {
	sync.RWMutex
	agents             map[int64]*Agent
	sessionCloseCbLock sync.RWMutex
	sessionCloseCb     []func(*Session)
}

func newNetService() *netService {
	return &netService{
		agents: make(map[int64]*Agent),
	}
}

func (net *netService) CreateAgent(conn net.Conn) *Agent {
	a := newAgent(conn)
	// add to maps
	net.Lock()
	defer net.Unlock()

	net.agents[a.id] = a
	return a
}

func (net *netService) Agent(id int64) (*Agent, error) {
	net.RLock()
	defer net.RUnlock()

	a, ok := net.agents[id]
	if !ok {
		return nil, errors.New("Agent id: " + string(id) + " not exists!")
	}

	return a, nil
}

func (net *netService) Send(session *Session, data []byte) {
	session.Entity.Send(data)
}

func (net *netService) Push(session *Session, route string, data []byte) error {
	return nil
}

func (net *netService) Response(session *Session, data []byte) error {

	return nil
}

func (net *netService) Multicast(aids []int64, route string, data []byte) {

}

// Close session
func (net *netService) CloseSession(session *Session) {
	net.sessionCloseCbLock.RLock()
	for _, cb := range net.sessionCloseCb {
		if cb != nil {
			cb(session)
		}
	}
	net.sessionCloseCbLock.RUnlock()
	net.Lock()
	defer net.Unlock()
	if agent, ok := net.agents[session.Entity.ID()]; ok && agent != nil {
		delete(net.agents, session.Entity.ID())
		service.Connections.Decrement()
	}

}

func (net *netService) Heartbeat() {
}

// Dump all agents
func (net *netService) DumpAgents() {
	net.RLock()
	defer net.RUnlock()

	log.Log.Infof("current Agent count: %d", len(net.agents))
	for _, ses := range net.agents {
		log.Log.Infof("session: " + ses.String())
	}
}

func (net *netService) SessionClosedCallback(cb func(*Session)) {
	net.sessionCloseCbLock.Lock()
	defer net.sessionCloseCbLock.Unlock()

	net.sessionCloseCb = append(net.sessionCloseCb, cb)
}

func OnSessionClosed(service *netService, cb func(*Session)) {
	service.SessionClosedCallback(cb)
}
