/** * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 * net manager stream
 * generate by DavidYang 2017.9.7
 *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
package net

import "sync"

const sessionMapNums = 64

type Manager struct {
	clientMaps  [sessionMapNums]clientMap
	disposeFlag bool
	disposeOnce sync.Once
	disposeWait sync.WaitGroup
}

type clientMap struct {
	sync.RWMutex
	clients map[uint64]*Client
}

func NewManager() *Manager {
	manager := &Manager{}
	for i := 0; i < len(manager.clientMaps); i++ {
		manager.clientMaps[i].clients = make(map[uint64]*Client)
	}
	return manager
}

func (manager *Manager) Dispose() {

	manager.disposeOnce.Do(func() {
		manager.disposeFlag = true
		for i := 0; i < sessionMapNums; i++ {
			sessionmp := &manager.clientMaps[i]
			sessionmp.Lock()
			for _, session := range sessionmp.clients {
				session.Close()
			}
			sessionmp.Unlock()
		}
		manager.disposeWait.Wait()
	})
}

func (manager *Manager) NewClient(netStream NetStreamProtocol, sendChanSize int) *Client {
	client := newClient(manager, netStream, sendChanSize)
	manager.putClient(client)
	return client
}

func (manager *Manager) GetClient(clientID uint64) *Client {
	smap := &manager.clientMaps[clientID%sessionMapNums]
	smap.RLock()
	defer smap.RUnlock()
	session, _ := smap.clients[clientID]
	return session
}

func (manager *Manager) putClient(client *Client) {
	cmap := &manager.clientMaps[client.id%sessionMapNums]
	cmap.Lock()
	defer cmap.Unlock()
	cmap.clients[client.id] = client
	manager.disposeWait.Add(1)
}

func (manager *Manager) delClient(client *Client) {
	if manager.disposeFlag {
		manager.disposeWait.Done()
		return
	}
	smap := &manager.clientMaps[client.id%sessionMapNums]
	smap.Lock()
	defer smap.Unlock()
	delete(smap.clients, client.id)
	manager.disposeWait.Done()
}
