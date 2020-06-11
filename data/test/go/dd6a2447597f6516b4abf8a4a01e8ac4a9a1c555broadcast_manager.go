package libbroadcast

import (
	"sync"
)

var (
	globalBroadcastManager *BroadcastManager
)

type BroadcastManager struct {
	broadcasters map[string]*Broadcaster
	mutex        *sync.Mutex
}

func init() {
	globalBroadcastManager = &BroadcastManager{
		broadcasters: make(map[string]*Broadcaster),
		mutex:        &sync.Mutex{},
	}
}

func Global() *BroadcastManager {
	return globalBroadcastManager
}

func (broadcastManager *BroadcastManager) CreateBroadcaster(name string) *Broadcaster {
	broadcastManager.mutex.Lock()
	defer broadcastManager.mutex.Unlock()

	// don't allow duplicated names to be created (since that will be a bad situation)
	if b, ok := broadcastManager.broadcasters[name]; ok {
		return b
	}

	broadcaster := newBroadcaster(name)
	broadcastManager.broadcasters[name] = broadcaster
	return broadcaster
}

func (broadcastManager *BroadcastManager) GetBroadcaster(name string) *Broadcaster {
	return broadcastManager.CreateBroadcaster(name)
}

func (broadcastManager *BroadcastManager) Destroy(name string) {
	broadcastManager.mutex.Lock()
	defer broadcastManager.mutex.Unlock()

	delete(broadcastManager.broadcasters, name)
}
