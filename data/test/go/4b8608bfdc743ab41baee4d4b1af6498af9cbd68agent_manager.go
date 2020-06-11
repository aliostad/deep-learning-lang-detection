package motherbase

import (
	"fmt"
	"strings"
	"sync"
	"time"

	"github.com/yangzhao28/phantom/commonlog"
)

// 收取请求(http)        √
// cache, 本地存储       √
// Agent管理             X
// 对Agent 3 routine:
//   - 配置              X
//   - 探活              X
//   - diff              X

var managerLogger = commonlog.NewLogger("AgentManager", "log", commonlog.DEBUG)

type AgentManager struct {
	enableAgents map[string]Configurable
	enableMutex  sync.RWMutex

	availableAgents map[string]Configurable
	availableMutex  sync.RWMutex

	agentEnableChannel  chan *AgentEvent
	agentDisablechannel chan *AgentEvent
	agentCreateChannel  chan *AgentEvent
	agentRemoveChannel  chan *AgentEvent

	agentRunDetector    chan int
	agentRunDiffer      chan int
	detectorRoundSecond time.Duration
	differRoundSecond   time.Duration

	cache *PersistCache

	syncer sync.WaitGroup
	quit   chan bool
}

type AgentEvent struct {
	name         string
	configurable *Configurable
}

func NewAgentManager(cache *PersistCache) *AgentManager {
	manager := &AgentManager{
		enableAgents:    make(map[string]Configurable),
		availableAgents: make(map[string]Configurable),

		agentEnableChannel:  make(chan *AgentEvent),
		agentDisablechannel: make(chan *AgentEvent),
		agentCreateChannel:  make(chan *AgentEvent),
		agentRemoveChannel:  make(chan *AgentEvent),

		agentRunDetector: make(chan int),
		agentRunDiffer:   make(chan int),

		detectorRoundSecond: 10 * time.Second,
		differRoundSecond:   15 * time.Second,

		cache: cache,

		quit: make(chan bool),
	}
	return manager
}

func (manager *AgentManager) EnableAgent(name string, instance *Configurable) {
	manager.enableMutex.Lock()
	defer manager.enableMutex.Unlock()

	if _, ok := manager.enableAgents[name]; !ok {
		manager.enableAgents[name] = *instance
		managerLogger.Debug("new enable agent " + name)
	}
}

func (manager *AgentManager) DisableAgent(name string) {
	manager.enableMutex.Lock()
	defer manager.enableMutex.Unlock()
	if _, ok := manager.enableAgents[name]; ok {
		delete(manager.enableAgents, name)
		managerLogger.Debug("disable agent " + name)
	}
}

func (manager *AgentManager) NewAvailableAgent(name string, instance *Configurable) {
	manager.availableMutex.Lock()
	defer manager.availableMutex.Unlock()
	if _, ok := manager.availableAgents[name]; !ok {
		manager.availableAgents[name] = *instance
		managerLogger.Debug("new available agent " + name)
	}
}

func (manager *AgentManager) RemoveAvailableAgent(name string) {
	manager.availableMutex.Lock()
	defer manager.availableMutex.Unlock()
	if _, ok := manager.availableAgents[name]; ok {
		delete(manager.availableAgents, name)
		managerLogger.Debug("delete agent " + name)
	}
}

func (manager *AgentManager) Controller() {
	managerLogger.Debug("enter controller")
	defer managerLogger.Debug("leave controller")

	defer manager.syncer.Done()
	for {
		select {
		case event := <-manager.agentEnableChannel:
			manager.EnableAgent(event.name, event.configurable)
		case event := <-manager.agentDisablechannel:
			manager.DisableAgent(event.name)
		case event := <-manager.agentCreateChannel:
			manager.NewAvailableAgent(event.name, event.configurable)
		case event := <-manager.agentRemoveChannel:
			manager.RemoveAvailableAgent(event.name)
			manager.DisableAgent(event.name)
		case <-manager.quit:
			break
		}
	}
}

func (manager *AgentManager) Detector() {
	managerLogger.Debug("enter detector")
	defer managerLogger.Debug("leave detector")

	defer manager.syncer.Done()
	for {
		select {
		case <-manager.agentRunDetector:
			waitForDone := sync.WaitGroup{}
			func() {
				manager.availableMutex.RLock()
				defer manager.availableMutex.RUnlock()
				for name, agent := range manager.availableAgents {
					waitForDone.Add(1)
					go func(name string, bridge Configurable) {
						defer waitForDone.Done()
						managerLogger.Debug("ping")
						err := bridge.Ping()
						managerLogger.Debug("ping response")
						if err != nil {
							manager.agentDisablechannel <- &AgentEvent{name, &agent}
						} else {
							manager.agentEnableChannel <- &AgentEvent{name, &agent}
						}
					}(name, agent)
				}
			}()
			waitForDone.Wait()
		case <-manager.quit:
			break
		}
	}
}

func (manager *AgentManager) Scheduler() {
	managerLogger.Debug("enter scheduler")
	defer managerLogger.Debug("leave scheduler")
	defer manager.syncer.Done()

	detectorTimer := time.NewTimer(manager.detectorRoundSecond)
	differTimer := time.NewTimer(manager.differRoundSecond)
	for {
		select {
		case <-detectorTimer.C:
			manager.agentRunDetector <- 0
			detectorTimer.Reset(manager.detectorRoundSecond)
		case <-differTimer.C:
			manager.agentRunDiffer <- 0
			differTimer.Reset(manager.differRoundSecond)
		case <-manager.quit:
			break
		}
	}
}

func (manager *AgentManager) Differ() {
	managerLogger.Debug("enter differ")
	defer managerLogger.Debug("leave differ")

	defer manager.syncer.Done()
	for {
		select {
		case <-manager.agentRunDiffer:
			if len(manager.enableAgents) == 0 {
				managerLogger.Debug("no activated agents")
				continue
			}
			func() {
				managerLogger.Debug("run differ")
				// get current agent list, eg: activated
				activatedAgents, err := manager.cache.List()
				if err != nil {
					return
				}
				activatedAgentsId := make(map[string]bool)
				for _, value := range activatedAgents {
					activatedAgentsId[value.id] = true
				}
				waitForDone := sync.WaitGroup{}
				func() {
					manager.availableMutex.RLock()
					defer manager.availableMutex.RUnlock()
					for name, agent := range manager.enableAgents {
						waitForDone.Add(1)
						managerLogger.Debug("diff -> " + name)
						go func(name string, bridge Configurable) {
							defer waitForDone.Done()
							// map[string]string
							foundAgents, err := bridge.ListConfig()
							managerLogger.Debug(fmt.Sprintf("%v", foundAgents))
							if err != nil {
								// do something
								managerLogger.Debug(fmt.Sprintf("fail to list config on %v: %v", name, err.Error()))
								return
							}
							managerLogger.Debug(fmt.Sprintf("found %v agents on %v", len(foundAgents), name))
							// check unexpected agents
							for id, _ := range foundAgents {
								if _, ok := activatedAgentsId[id]; !ok {
									agent.UnConfig(id)
								}
							}
							// check agent not updated
							for _, info := range activatedAgents {
								managerLogger.Debug(fmt.Sprintf("expect id %v on %v", info.id, name))
								if md5sum, ok := foundAgents[info.id]; ok && strings.ToLower(md5sum) == strings.ToLower(info.md5sum) {
									managerLogger.Debug("matched")
									continue
								}
								managerLogger.Debug(fmt.Sprintf("but missed, %v vs %v", foundAgents[info.id], info.md5sum))
								go func(id string) {
									managerLogger.Debug("try boot agent config: " + id)
									if manager.cache != nil {
										config, err := manager.cache.Get(id)
										if err != nil {
											managerLogger.Debug("no config for: " + id)
											return
										}
										managerLogger.Debug("do config")
										bridge.DoConfig(id, config)
									}
								}(info.id)
							}
						}(name, agent)
					}
				}()
				waitForDone.Wait()
			}()
		case <-manager.quit:
			break
		}
	}
}

func (manager *AgentManager) Quit() {
	managerLogger.Debug("Quit")
	close(manager.quit)
}

func (manager *AgentManager) AddAgent(name string, instance *Configurable) {
	managerLogger.Debug("ready to send add agent" + name)
	manager.agentCreateChannel <- &AgentEvent{
		name:         name,
		configurable: instance,
	}
	managerLogger.Debug("done")
}

func (manager *AgentManager) RemoveAgent(name string, instance *Configurable) {
	manager.agentRemoveChannel <- &AgentEvent{
		name:         name,
		configurable: instance,
	}
}

func (manager *AgentManager) Go() {
	manager.syncer.Add(1)
	go manager.Controller()
	manager.syncer.Add(1)
	go manager.Detector()
	manager.syncer.Add(1)
	go manager.Scheduler()
	manager.syncer.Add(1)
	go manager.Differ()

	manager.syncer.Wait()
}
