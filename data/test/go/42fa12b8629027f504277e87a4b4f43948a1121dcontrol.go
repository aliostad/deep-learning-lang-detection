// Copyright (c) 2012 VMware, Inc.

package gonit

import (
	"fmt"
	"io/ioutil"
	"launchpad.net/goyaml"
	"os"
	"sync"
	"time"
)

const (
	MONITOR_NOT     = 0x0
	MONITOR_YES     = 0x1
	MONITOR_INIT    = 0x2
	MONITOR_WAITING = 0x4
)

const (
	ACTION_START = iota
	ACTION_STOP
	ACTION_RESTART
	ACTION_MONITOR
	ACTION_UNMONITOR
)

const (
	scopeDefault = iota
	scopeRestartGroup
)

const (
	processStopped = iota
	processStarted
)

const (
	ERROR_IN_PROGRESS_FMT = "Process %q action already in progress"
)

// So we can mock it in tests.
type EventMonitorInterface interface {
	StartMonitoringProcess(process *Process)
	Start(configManager *ConfigManager, control *Control) error
	Stop()
}

type Control struct {
	ConfigManager *ConfigManager
	EventMonitor  EventMonitorInterface
	States        map[string]*ProcessState
	persistLock   sync.Mutex
}

type ControlAction struct {
	scope  int
	method int
	visits map[string]*visitor
}

// flags to avoid invoking actions more than once
// as we traverse the dependency graph
type visitor struct {
	started bool
	stopped bool
}

// XXX TODO should state be attached to Process type?
type ProcessState struct {
	Monitor     int
	MonitorLock sync.Mutex
	Starts      int

	actionPending     bool
	actionPendingLock sync.Mutex
}

// XXX TODO needed for tests, a form of this should probably be in ConfigManager
func (c *ConfigManager) AddProcess(groupName string, process *Process) error {
	groups := c.ProcessGroups
	var group *ProcessGroup
	var exists bool
	if group, exists = groups[groupName]; !exists {
		group = &ProcessGroup{
			Name:      groupName,
			Processes: make(map[string]*Process),
		}
		groups[groupName] = group
	}

	if _, exists := group.Processes[process.Name]; exists {
		return fmt.Errorf("process %q already exists", process.Name)
	} else {
		group.Processes[process.Name] = process
	}

	return nil
}

// BUG(lisbakke): If there are two processes named the same thing in different process groups, this could return the wrong process. ConfigManager should enforce unique group/process names.
// XXX TODO should probably be in configmanager.go
// Helper methods to find a Process by name
func (c *ConfigManager) FindProcess(name string) (*Process, error) {
	for _, processGroup := range c.ProcessGroups {
		if process, exists := processGroup.Processes[name]; exists {
			return process, nil
		}
	}

	return nil, fmt.Errorf("process %q not found", name)
}

// TODO should probably be in configmanager.go
// Helper method to find a ProcessGroup by name
func (c *ConfigManager) FindGroup(name string) (*ProcessGroup, error) {
	if group, exists := c.ProcessGroups[name]; exists {
		return group, nil
	}
	return nil, fmt.Errorf("process group %q not found", name)
}

// ConfigManager accessor (exported for tests)
func (c *Control) Config() *ConfigManager {
	if c.ConfigManager == nil {
		c.ConfigManager = &ConfigManager{}
	}

	if c.ConfigManager.ProcessGroups == nil {
		// XXX TODO NewConfigManager() ?
		c.ConfigManager.ProcessGroups = make(map[string]*ProcessGroup)
	}

	return c.ConfigManager
}

// XXX TODO should probably be in configmanager.go
// Visit each Process in the ConfigManager.
// Stop visiting if visit func returns false
func (c *ConfigManager) VisitProcesses(visit func(p *Process) bool) {
	for _, processGroup := range c.ProcessGroups {
		for _, process := range processGroup.Processes {
			if !visit(process) {
				return
			}
		}
	}
}

func (c *ControlAction) visitorOf(process *Process) *visitor {
	if _, exists := c.visits[process.Name]; !exists {
		c.visits[process.Name] = &visitor{}
	}

	return c.visits[process.Name]
}

func (c *Control) State(process *Process) *ProcessState {
	if c.States == nil {
		c.States = make(map[string]*ProcessState)
	}
	procName := process.Name
	if _, exists := c.States[procName]; !exists {
		state := &ProcessState{}
		c.States[procName] = state
		if process.IsMonitoringModeActive() {
			state.Monitor = MONITOR_INIT
		}

	}
	return c.States[procName]
}

// Registers the event monitor with Control so that it can turn event monitoring
// on/off when processes are started/stopped.
func (c *Control) RegisterEventMonitor(eventMonitor *EventMonitor) {
	c.EventMonitor = eventMonitor
}

func NewControlAction(method int) *ControlAction {
	return &ControlAction{
		method: method,
		visits: make(map[string]*visitor),
	}
}

func NewGroupControlAction(method int) *ControlAction {
	action := NewControlAction(method)
	if method == ACTION_RESTART {
		action.scope = scopeRestartGroup
	}
	return action
}

// Invoke given action for the given process and its
// dependents and/or dependencies
func (c *Control) DoAction(name string, action *ControlAction) error {
	process, err := c.Config().FindProcess(name)
	if err != nil {
		Log.Error(err.Error())
		return err
	}

	return c.invoke(process, func() error {
		return c.dispatchAction(process, action)
	})
}

func (c *Control) dispatchAction(process *Process, action *ControlAction) error {

	switch action.method {
	case ACTION_START:
		if process.IsRunning() {
			Log.Debugf("Process %q already running", process.Name)
			c.monitorSet(process)
			return nil
		}
		c.doDepend(process, ACTION_STOP, action)
		c.doStart(process, action)
		c.doDepend(process, ACTION_START, action)

	case ACTION_STOP:
		c.doDepend(process, ACTION_STOP, action)
		c.doStop(process, action)

	case ACTION_RESTART:
		c.doDepend(process, ACTION_STOP, action)
		if c.doStop(process, action) {
			c.doStart(process, action)
			c.doDepend(process, ACTION_START, action)
		} else {
			c.monitorSet(process)
		}

	case ACTION_MONITOR:
		c.doMonitor(process, action)

	case ACTION_UNMONITOR:
		c.doDepend(process, ACTION_UNMONITOR, action)
		c.doUnmonitor(process, action)

	default:
		err := fmt.Errorf("process %q -- invalid action: %d",
			process.Name, action)
		return err
	}
	if err := c.PersistStates(c.States); err != nil {
		Log.Errorf("Error persisting state: '%v'", err.Error())
	}
	return nil
}

// do not allow more than one control action per process at the same time
func (c *Control) invoke(process *Process, action func() error) error {
	if c.isActionPending(process) {
		return fmt.Errorf(ERROR_IN_PROGRESS_FMT, process.Name)
	}
	c.setActionPending(process, true)
	defer c.setActionPending(process, false)

	return action()
}

// Start the given Process dependencies before starting Process
func (c *Control) doStart(process *Process, action *ControlAction) {
	visitor := action.visitorOf(process)
	if visitor.started {
		return
	}
	visitor.started = true

	if action.scope != scopeRestartGroup {
		for _, d := range process.DependsOn {
			parent, err := c.Config().FindProcess(d)
			if err != nil {
				panic(err)
			}
			c.doStart(parent, action)
		}
	}

	if !process.IsRunning() {
		c.State(process).Starts++
		process.StartProcess()
		process.waitState(processStarted)
	}

	c.monitorSet(process)
}

// Stop the given Process.
// Waits for process to stop or until Process.Timeout is reached.
func (c *Control) doStop(process *Process, action *ControlAction) bool {
	visitor := action.visitorOf(process)
	var rv = true
	if visitor.stopped {
		return rv
	}
	visitor.stopped = true

	c.monitorUnset(process)

	if process.IsRunning() {
		process.StopProcess()
		if process.waitState(processStopped) != processStopped {
			rv = false
		}
	}

	return rv
}

// Enable monitoring for Process dependencies and given Process.
func (c *Control) doMonitor(process *Process, action *ControlAction) {
	if action.visitorOf(process).started {
		return
	}

	for _, d := range process.DependsOn {
		parent, err := c.Config().FindProcess(d)
		if err != nil {
			panic(err)
		}
		c.doMonitor(parent, action)
	}

	c.monitorSet(process)
}

// Disable monitoring for the given Process
func (c *Control) doUnmonitor(process *Process, action *ControlAction) {
	visitor := action.visitorOf(process)
	if visitor.stopped {
		return
	}

	visitor.stopped = true
	c.monitorUnset(process)
}

// Apply actions to processes that depend on the given Process
func (c *Control) doDepend(process *Process, method int, action *ControlAction) {
	c.ConfigManager.VisitProcesses(func(child *Process) bool {
		for _, dep := range child.DependsOn {
			if dep == process.Name {
				switch method {
				case ACTION_START:
					c.doStart(child, action)
				case ACTION_MONITOR:
					c.doMonitor(child, action)
				}

				c.doDepend(child, method, action)

				switch method {
				case ACTION_STOP:
					c.doStop(child, action)
				case ACTION_UNMONITOR:
					c.doUnmonitor(child, action)
				}
				break
			}
		}
		return true
	})
}

func (c *Control) monitorSet(process *Process) {
	state := c.State(process)
	state.MonitorLock.Lock()
	defer state.MonitorLock.Unlock()
	if state.Monitor == MONITOR_NOT {
		state.Monitor = MONITOR_INIT
		c.EventMonitor.StartMonitoringProcess(process)
		Log.Infof("%q monitoring enabled", process.Name)
	}
}

// for use by process watcher
func (c *Control) monitorActivate(process *Process) bool {
	state := c.State(process)
	state.MonitorLock.Lock()
	defer state.MonitorLock.Unlock()

	if state.Monitor == MONITOR_NOT {
		return false
	}

	if state.Monitor != MONITOR_YES {
		state.Monitor = MONITOR_YES // INIT -> YES
		Log.Infof("%q monitoring activated", process.Name)
	}

	return true
}

func (c *Control) monitorUnset(process *Process) {
	state := c.State(process)
	state.MonitorLock.Lock()
	defer state.MonitorLock.Unlock()
	if state.Monitor != MONITOR_NOT {
		state.Monitor = MONITOR_NOT
		Log.Infof("%q monitoring disabled", process.Name)
	}
}

func (c *Control) isActionPending(process *Process) bool {
	state := c.State(process)
	state.actionPendingLock.Lock()
	defer state.actionPendingLock.Unlock()
	return state.actionPending
}

func (c *Control) setActionPending(process *Process, actionPending bool) {
	state := c.State(process)
	state.actionPendingLock.Lock()
	defer state.actionPendingLock.Unlock()
	state.actionPending = actionPending
}

func (c *Control) IsMonitoring(process *Process) bool {
	state := c.State(process)
	state.MonitorLock.Lock()
	defer state.MonitorLock.Unlock()
	return state.Monitor == MONITOR_INIT || state.Monitor == MONITOR_YES
}

// Poll process for expected state change
func (p *Process) pollState(timeout time.Duration, expect int) bool {
	isRunning := false
	timeoutTicker := time.NewTicker(timeout)
	pollTicker := time.NewTicker(100 * time.Millisecond)
	defer timeoutTicker.Stop()
	defer pollTicker.Stop()

	// XXX TODO could make use of psnotify + fsnotify here
	for {
		select {
		case <-timeoutTicker.C:
			return isRunning
		case <-pollTicker.C:
			isRunning = p.IsRunning()

			if (expect == processStopped && !isRunning) ||
				(expect == processStarted && isRunning) {
				return isRunning
			}
		}
	}

	panic("not reached")
}

// Wait for a Process to change state.
func (p *Process) waitState(expect int) int {
	timeout := 30 * time.Second // XXX TODO process.Timeout
	isRunning := p.pollState(timeout, expect)

	// XXX TODO emit events when process state changes
	if isRunning {
		if expect == processStarted {
			Log.Infof("process %q started", p.Name)
		} else {
			Log.Errorf("process %q failed to stop", p.Name)
		}
		return processStarted
	} else {
		if expect == processStarted {
			Log.Errorf("process %q failed to start", p.Name)
		} else {
			Log.Infof("process %q stopped", p.Name)
		}
		return processStopped
	}

	panic("not reached")
}

func (c *Control) LoadPersistState() error {
	states := map[string]ProcessState{}
	persistFile := c.ConfigManager.Settings.PersistFile
	_, err := os.Stat(persistFile)
	if err != nil {
		Log.Debugf("No persisted state found at '%v'", persistFile)
		return nil
	}
	persistData, err := ioutil.ReadFile(persistFile)
	if err != nil {
		return err
	}
	if err := goyaml.Unmarshal(persistData, states); err != nil {
		return err
	}
	for _, processGroup := range c.ConfigManager.ProcessGroups {
		for name, process := range processGroup.Processes {
			if state, hasKey := states[name]; hasKey {
				*c.State(process) = state
			}
		}
	}
	return nil
}

func (c *Control) PersistStates(states map[string]*ProcessState) error {
	c.persistLock.Lock()
	defer c.persistLock.Unlock()

	yaml, err := goyaml.Marshal(states)
	if err != nil {
		return err
	}
	persistFile := c.ConfigManager.Settings.PersistFile
	if err = ioutil.WriteFile(persistFile, []byte(yaml), 0644); err != nil {
		return err
	}
	Log.Debugf("Persisted state to '%v'", persistFile)
	return nil
}
