package event

import (
	"sort"
	"sync"
)

//Manager is simple event manager
type Manager struct {
	lock   sync.Mutex
	id     uint32
	events map[string]eventsStore
}

func (manager *Manager) listen(name string, fn func(interface{}) bool, order float32, once bool) (id uint32) {
	manager.lock.Lock()
	defer manager.lock.Unlock()

	manager.events[name] = append(manager.events[name], eventStore{
		fn:    fn,
		order: order,
		id:    manager.id,
		once:  once,
	})
	id = manager.id
	manager.id++
	sort.Sort(manager.events[name])
	return
}

//Subscribe  listen to  event
func (manager *Manager) Subscribe(name string, fn func(interface{}) bool, order float32) uint32 {
	return manager.listen(name, fn, order, false)
}

//SubscribeOnce listen to  event for once
func (manager *Manager) SubscribeOnce(name string, fn func(interface{}) bool, order float32) uint32 {
	return manager.listen(name, fn, order, true)
}

//UnSubscribe remove listen to event
func (manager *Manager) UnSubscribe(name string, id uint32) {
	manager.lock.Lock()
	defer manager.lock.Unlock()

	if events, ok := manager.events[name]; ok {
		for index, event := range events {
			if event.id == id {
				manager.remove(name, index)
			}
		}
	}
}

//UnSubscribeAll remove all listens to event
func (manager *Manager) UnSubscribeAll(name string) {
	manager.lock.Lock()
	defer manager.lock.Unlock()
	manager.events[name] = make(eventsStore, 0)
}

// Publish executes callback defined for event. if func return false stop execute and return false
func (manager *Manager) Publish(name string, arg interface{}) bool {
	manager.lock.Lock()
	defer manager.lock.Unlock()
	if events, ok := manager.events[name]; ok {
		for index, event := range events {
			if event.once {
				manager.remove(name, index)
			}
			if !event.fn(arg) {
				return false
			}
		}
	}
	return true
}

func (manager *Manager) remove(name string, index int) {
	if index >= 0 {
		manager.events[name] = append(manager.events[name][:index],
			manager.events[name][index+1:]...)
	}
}

//NewManager retrun event manager
func NewManager() *Manager {
	return &Manager{
		sync.Mutex{},
		0,
		make(map[string]eventsStore),
	}
}
