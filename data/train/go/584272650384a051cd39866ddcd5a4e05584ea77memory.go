package session

import (
	"sync"
	"time"

	"github.com/ije/gox/crypto/rs"
)

type MemorySession struct {
	sid     string
	store   map[string]interface{}
	expires time.Time
	manager *MemorySessionManager
}

func (ms *MemorySession) SID() string {
	return ms.sid
}

func (ms *MemorySession) Store() (store map[string]interface{}) {
	store = ms.store
	ms.activate()
	return
}

func (ms *MemorySession) Get(key string) (value interface{}, ok bool) {
	value, ok = ms.store[key]
	ms.activate()
	return
}

func (ms *MemorySession) Set(key string, value interface{}) {
	ms.store[key] = value
	ms.activate()
}

func (ms *MemorySession) Delete(key string) {
	delete(ms.store, key)
	ms.activate()
	return
}

func (ms *MemorySession) Flush() {
	ms.store = map[string]interface{}{}
	ms.activate()
}

func (ms *MemorySession) activate() {
	ms.expires = time.Now().Add(ms.manager.gcLifetime)
}

type MemorySessionManager struct {
	lock       sync.RWMutex
	sessions   map[string]*MemorySession
	gcLifetime time.Duration
	gcTicker   *time.Ticker
}

func NewMemorySessionManager(gcLifetime time.Duration) *MemorySessionManager {
	manager := &MemorySessionManager{
		sessions: map[string]*MemorySession{},
	}
	manager.SetGCLifetime(gcLifetime)
	go func(manager *MemorySessionManager) {
		for {
			manager.lock.RLock()
			ticker := manager.gcTicker
			manager.lock.RUnlock()

			if ticker != nil {
				<-ticker.C
				manager.GC()
			}
		}
	}(manager)

	return manager
}

func (manager *MemorySessionManager) SetGCLifetime(lifetime time.Duration) error {
	if lifetime < time.Second {
		return nil
	}

	manager.lock.Lock()
	defer manager.lock.Unlock()

	if manager.gcTicker != nil {
		manager.gcTicker.Stop()
	}
	manager.gcLifetime = lifetime
	manager.gcTicker = time.NewTicker(lifetime)

	return nil
}

func (manager *MemorySessionManager) Get(sid string) (session Session, err error) {
	now := time.Now()
	ok := len(sid) == 64

	var ms *MemorySession
	if ok {
		manager.lock.RLock()
		ms, ok = manager.sessions[sid]
		manager.lock.RUnlock()
	}

	if ok && ms.expires.Before(now) {
		manager.lock.Lock()
		delete(manager.sessions, sid)
		manager.lock.Unlock()

		ms = nil
	}

	if ms == nil {
	NEWSID:
		sid = rs.Base64.String(64)
		manager.lock.RLock()
		_, ok := manager.sessions[sid]
		manager.lock.RUnlock()
		if ok {
			goto NEWSID
		}

		ms = &MemorySession{
			sid:     sid,
			store:   map[string]interface{}{},
			manager: manager,
		}
		manager.lock.Lock()
		manager.sessions[sid] = ms
		manager.lock.Unlock()
	}

	manager.lock.Lock()
	ms.expires = now.Add(manager.gcLifetime)
	manager.lock.Unlock()

	session = ms
	return
}

func (manager *MemorySessionManager) Destroy(sid string) error {
	manager.lock.Lock()
	defer manager.lock.Unlock()

	delete(manager.sessions, sid)
	return nil
}

func (manager *MemorySessionManager) GC() error {
	now := time.Now()

	manager.lock.RLock()
	defer manager.lock.RUnlock()

	for sid, session := range manager.sessions {
		if session.expires.Before(now) {
			manager.lock.RUnlock()
			manager.lock.Lock()
			delete(manager.sessions, sid)
			manager.lock.Unlock()
			manager.lock.RLock()
		}
	}

	return nil
}

func init() {
	var _ Manager = (*MemorySessionManager)(nil)
}
