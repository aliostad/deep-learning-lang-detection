/* state_manager.go - state manager */
/*
modification history
--------------------
2015/6/4, by Guang Yao, create
*/
/*
DESCRIPTION
    state manager holds the states and provides interfaces to the states
*/
package state_manager

import (
//"fmt"
//"time"
)

import (
	"www.baidu.com/golang-lib/log"
)

import (
	//"meta_service"
	"sync"
	. "types"
)

type StateManager struct {
	// manager of tasks
	taskManager      *TaskManager
	PendingTaskQueue chan *Task // pending tasks to schedule

	// manager of subtasks
	subtaskManager   *SubtaskManager
	StopSubtaskQueue chan *Subtask // unprocessed stoped subtasks

	// manager of agents
	agentManager *AgentManager

	// manager of data and block
	dataManager *DataManager

	// manager of the network
	networkManager *NetworkManager

	// manager of maps
	mapsManager *MapsManager

	// State of the controller
	isMaster bool // if the controller is master

	// state 
	state  int

	lock sync.RWMutex
}

// use singleton model
var stateManager *StateManager

func Init() error {
	var err error
	stateManager, err = newStateManager()
	if err != nil {
		log.Logger.Error("err in init StateManager:%s", err.Error())
		return err
	}

	return nil
}

func newStateManager() (*StateManager, error) {
	var err error
	stateManager := new(StateManager)

	// Init inner structs
	stateManager.taskManager = NewTaskManager()
	stateManager.subtaskManager = NewSubtaskManager()
	stateManager.agentManager = NewAgentManager()
	stateManager.dataManager = NewDataManager()

	stateManager.networkManager, err = NewNetworkManager()
	if err != nil {
		return nil, err
	}

	stateManager.mapsManager = NewMapsManager()

	stateManager.state = 0

	// Register idc link quota as resource
	//idcLinks := stateManager.networkManager.getAllIdcLinks()
	//stateManager.resourceManager.registerIdcLinkResource(idcLinks)

	// Register region link quota as resource
	//regionLinks := stateManager.networkManager.getAllRegionLinks()
	//stateManager.resourceManager.registerRegionLinkResource(regionLinks)

	return stateManager, nil
}

func GetState() int{
	stateManager.lock.RLock()
	defer stateManager.lock.RUnlock()
	return stateManager.state
}

func UpdateState() {
	stateManager.lock.Lock()
	defer stateManager.lock.Unlock()
	stateManager.state ++
}

