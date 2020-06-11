package pager

import (
	"log"
	"sync"
)

type lockManager struct {
	filelocks map[string]*sync.RWMutex
	mtx       sync.Mutex
}

func (manager *lockManager) ensureFileLock(filename string) *sync.RWMutex {
	manager.mtx.Lock()
	defer manager.mtx.Unlock()
	lock, ok := manager.filelocks[filename]
	if !ok {
		lock = &sync.RWMutex{}
		manager.filelocks[filename] = lock
	}
	return lock
}

func (manager *lockManager) AcquireLockShared(filename string) {
	lock := manager.ensureFileLock(filename)
	lock.RLock()
}

func (manager *lockManager) ReleaseLockShared(filename string) {
	manager.mtx.Lock()
	lock, ok := manager.filelocks[filename]
	manager.mtx.Unlock()
	if !ok {
		log.Panicf("Cannot release lock for i %s since it is not in the manager", filename)
	}
	lock.RUnlock()
}

func (manager *lockManager) AcquireLockExlusive(filename string) {
	lock := manager.ensureFileLock(filename)
	lock.Lock()
}

func (manager *lockManager) ReleaseLockExlusive(filename string) {
	manager.mtx.Lock()
	lock, ok := manager.filelocks[filename]
	manager.mtx.Unlock()
	if !ok {
		log.Panicf("Cannot release lock for i %s since it is not in the manager", filename)
	}
	lock.Unlock()
}

var lockManagerInstance *lockManager = nil
var onceLockManager sync.Once

func getLockManger() *lockManager {
	onceLockManager.Do(func() {
		lockManagerInstance = &lockManager{
			filelocks: map[string]*sync.RWMutex{},
		}
	})
	return lockManagerInstance
}
