package main

import (
	"mysql_byroad/model"
	"time"

	"sort"

	log "github.com/Sirupsen/logrus"
)

type DispatcherManager struct {
	rpcclients *RPCClientMap
	timers     *TimerMap
}

func NewDispatcherManager() *DispatcherManager {
	dm := &DispatcherManager{
		rpcclients: NewRPCClientMap(),
		timers:     NewTimerMap(),
	}
	return dm
}

type OrderRPCClients []*RPCClient

func (o OrderRPCClients) Len() int {
	return len(o)
}

func (o OrderRPCClients) Less(i, j int) bool {
	return o[i].Desc < o[j].Desc
}

func (o OrderRPCClients) Swap(i, j int) {
	o[i], o[j] = o[j], o[i]
}

func (dm *DispatcherManager) GetRPCClients() []*RPCClient {
	clients := make([]*RPCClient, 0, 10)
	for c := range dm.rpcclients.Iter() {
		clients = append(clients, c)
	}
	sort.Sort(OrderRPCClients(clients))
	return clients
}

func (dm *DispatcherManager) GetRPCClient(desc string) (*RPCClient, bool) {
	return dm.rpcclients.Get(desc)
}

func (dm *DispatcherManager) AddDispatchClient(schema, desc string) {
	if _, ok := dm.rpcclients.Get(desc); !ok {
		client := NewRPCClient("tcp", schema, desc)
		dm.rpcclients.Set(desc, client)
		timer := time.NewTimer(Conf.RPCClientLookupInterval.Duration)
		dm.timers.Set(desc, timer)
		go func() {
			for {
				<-timer.C
				dm.DeleteDispatchClient(schema, desc)
			}
		}()
		log.Infof("add dispatch client %s, length: %d", desc, dm.rpcclients.Length())
	}
}

func (dm *DispatcherManager) DeleteDispatchClient(schema, desc string) {
	dm.rpcclients.Delete(desc)
	if timer, ok := dm.timers.Get(desc); ok {
		timer.Stop()
	}
	dm.timers.Delete(desc)
	log.Infof("delete dispatch client %s, length: %d", desc, dm.rpcclients.Length())
}

func (dm *DispatcherManager) UpdateDispatchClient(schema, desc string) {
	if timer, ok := dm.timers.Get(desc); ok {
		timer.Reset(Conf.RPCClientLookupInterval.Duration)
	}
	if _, ok := dm.rpcclients.Get(desc); !ok {
		dm.AddDispatchClient(schema, desc)
	}
	log.Debugf("dispatcher manager update client %s: %s", schema, desc)
}

func (dm *DispatcherManager) AddTask(task *model.Task) {
	clients := dm.GetRPCClients()
	for _, client := range clients {
		status, err := client.AddTask(task)
		if err != nil {
			log.Errorf("dispatch manager add task status: %s, error: %s", status, err.Error())
		}
	}
}

func (dm *DispatcherManager) DeleteTask(task *model.Task) {
	clients := dm.GetRPCClients()
	for _, client := range clients {
		status, err := client.DeleteTask(task)
		if err != nil {
			log.Errorf("dispatch manager delete task status: %s, error: %s", status, err.Error())
		}
	}
}

func (dm *DispatcherManager) UpdateTask(task *model.Task) {
	clients := dm.GetRPCClients()
	for _, client := range clients {
		status, err := client.UpdateTask(task)
		if err != nil {
			log.Errorf("dispatch manager update task status: %s, error: %s", status, err.Error())
		}
	}
}

func (dm *DispatcherManager) StartTask(task *model.Task) {
	clients := dm.GetRPCClients()
	for _, client := range clients {
		status, err := client.StartTask(task)
		if err != nil {
			log.Errorf("dispatch manager start task status: %s, error: %s", status, err.Error())
		}
	}
}

func (dm *DispatcherManager) StopTask(task *model.Task) {
	clients := dm.GetRPCClients()
	for _, client := range clients {
		status, err := client.StopTask(task)
		if err != nil {
			log.Errorf("dispatch manager stop task status: %s, error: %s", status, err.Error())
		}
	}
}
