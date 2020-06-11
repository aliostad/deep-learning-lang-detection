/* data_manager.go - manager of data*/
/*
modification history
--------------------
2015/6/4, by Guang Yao, create
*/
/*
DESCRIPTION
*/
package state_manager

import (
	"sync"
)

import (
	. "types"
)

type DataManager struct {
	dataLock sync.RWMutex
	datas    map[uint64]*Data // data id => data
}

func NewDataManager() *DataManager {
	dm := new(DataManager)

	dm.datas = make(map[uint64]*Data)

	return dm
}

func HasData(id uint64) bool {
	m := stateManager.dataManager

	m.dataLock.RLock()
	defer m.dataLock.RUnlock()

	_, exist := m.datas[id]
	return exist
}

func AddData(data *Data, agent *Agent) {
	m := stateManager.dataManager

	m.dataLock.Lock()
	m.datas[data.DataId] = data
	m.dataLock.Unlock()

	stateManager.mapsManager.addDataLocation(data, agent)
}
