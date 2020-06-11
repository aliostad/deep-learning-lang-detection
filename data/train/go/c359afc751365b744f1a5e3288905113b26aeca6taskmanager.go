package goro

import (
	"fmt"
	"log"
)

type Goro interface {
	AddTask(string, WorkerFn)
	LoadTask(string, ...Arg) *Task
}

type TaskManager struct {
	tasks map[string]WorkerFn
	log   *log.Logger
}

func NewTaskManager(logger *log.Logger) *TaskManager {
	t := &TaskManager{}
	t.tasks = make(map[string]WorkerFn)
	t.log = logger
	return t
}

func (manager *TaskManager) AddTask(name string, wf WorkerFn) {
	manager.tasks[name] = wf
}

func (manager *TaskManager) LoadTask(name string, args ...Arg) *Task {
	if fn, ok := manager.tasks[name]; ok {
		return NewTask(fn, manager.log, args...)
	}
	log.Fatal(fmt.Sprintf("task %s not found", name))
	return nil
}

func (manager *TaskManager) SetLogger(logger *log.Logger) {
	manager.log = logger
}
