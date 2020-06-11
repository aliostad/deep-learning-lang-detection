package memory_session

import (
	"io"
	"encoding/base64"
	"crypto/rand"
	"github.com/gwuhaolin/pong"
)

//in memory sessionManager
type memorySessionManager struct {
	pong.SessionIO
	store map[string]map[string]interface{}
}

func New() pong.SessionIO {
	return &memorySessionManager{
		store:make(map[string]map[string]interface{}),
	}
}

func (manager *memorySessionManager) NewSession() (sessionId string) {
	bs := make([]byte, 8)
	io.ReadFull(rand.Reader, bs)
	sessionId = base64.URLEncoding.EncodeToString(bs)
	if manager.Has(sessionId) {
		return manager.NewSession()
	}
	manager.store[sessionId] = make(map[string]interface{})
	return sessionId
}

func (manager *memorySessionManager) Destory(sessionId string) error {
	delete(manager.store, sessionId)
	return nil
}

func (manager *memorySessionManager) Reset(oldSessionId string) (newSessionId string, err error) {
	newSessionId = manager.NewSession()
	manager.store[newSessionId] = manager.store[oldSessionId]
	delete(manager.store, oldSessionId)
	return
}

func (manager *memorySessionManager) Has(sessionId string) bool {
	return manager.store[sessionId] != nil
}

func (manager *memorySessionManager) Read(sessionId string) (wholeValue map[string]interface{}) {
	wholeValue = manager.store[sessionId]
	return
}

func (manager *memorySessionManager) Write(sessionId string, changes map[string]interface{}) error {
	sessionValue := manager.store[sessionId]
	for k, v := range changes {
		sessionValue[k] = v
	}
	return nil
}