package libnet

import (
	"sync"
)

const sessionMapNum = 32

type Manager struct {
	sessionsMap [sessionMapNum]SessionMap
	disposeFlag bool
	disposeOnce sync.Once
	disposeWait sync.WaitGroup
}

type SessionMap struct {
	sync.RWMutex
	sessions map[uint64]*Session
}

func NewManager() *Manager {
	manager := &Manager{}
	for i := 0; i < len(manager.sessionsMap); i++ {
		manager.sessionsMap[i].sessions = make(map[uint64]*Session)
	}
	return manager
}

func (manager *Manager) Dispose() {
	manager.disposeOnce.Do(func() {
		manager.disposeFlag = true
		for i := 0; i < sessionMapNum; i++ {
			smap := &manager.sessionsMap[i]
			smap.Lock()
			for _, s := range smap.sessions {
				s.Close()
			}
			smap.Unlock()
		}
		manager.disposeWait.Wait()
	})
}

func (manager *Manager) NewSession(codec Codec, sendChanSize int) *Session {
	session := NewSession(codec, sendChanSize)
	manager.putSession(session)
	return session
}

func (manager *Manager) getSession(sessionID uint64) *Session {
	smap := &manager.sessionsMap[sessionID%sessionMapNum]
	smap.RLock()
	defer smap.RUnlock()
	session, _ := smap.sessions[sessionID]
	return session
}

func (manager *Manager) putSession(session *Session) {
	smap := &manager.sessionsMap[session.id%sessionMapNum]
	smap.Lock()
	defer smap.Unlock()
	smap.sessions[session.id] = session
	manager.disposeWait.Add(1)
}

func (manager *Manager) delSession(session *Session) {
	if manager.disposeFlag {
		manager.disposeWait.Done()
		return
	}
	smap := &manager.sessionsMap[session.id%sessionMapNum]
	smap.Lock()
	defer smap.Unlock()
	delete(smap.sessions, session.id)
	manager.disposeWait.Done()
}
