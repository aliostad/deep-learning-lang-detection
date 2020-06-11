package common

import (
	"errors"
	"fmt"
	"runtime"
)

var (
	taskManager = new(TaskManager)
)

const (
	EVENT_RUN   = iota // 0
	EVENT_YIELD        // 1
	EVENT_STOP         // 2
	EVENT_WAIT
)

type Task struct {
	id      int
	event   chan int
	msg     chan interface{}
	manager *TaskManager
	actor   Actor
}

type TaskManager struct {
	taskMap       map[int]*Task
	maxSize       int
	index         int
	total         int
	taskQueueSize int // message queue size of the task
	actors        map[string]int
}

type Actor interface {
	OnReceive(interface{})
	GetName() string
}

func NewTask(id int, manager *TaskManager) *Task {
	return &Task{id: id, event: make(chan int, 1), msg: make(chan interface{}, manager.taskQueueSize), manager: manager}
}

func (task *Task) GetID() (id int) {
	return task.id
}

func NewTaskManager(size int, taskQueueSize int) *TaskManager {
	taskManager.maxSize = size
	taskManager.index = 0
	taskManager.total = 0
	taskManager.taskQueueSize = taskQueueSize
	taskManager.taskMap = make(map[int]*Task)
	taskManager.actors = make(map[string]int)
	return taskManager
}

func GetTaskManager() *TaskManager {
	return taskManager
}

func (taskManager *TaskManager) alloc() (*Task, error) {
	var task *Task
	var ok bool
	if taskManager.total == taskManager.maxSize {
		return nil, errors.New("The count of grountines exceed the maximum quota")
	}
	if taskManager.index == taskManager.maxSize {
		taskManager.index = 0
	}
	for ; taskManager.index < taskManager.maxSize; taskManager.index++ {
		if task, ok = taskManager.taskMap[taskManager.index]; !ok {
			break
		}
	}
	task = NewTask(taskManager.index, taskManager)
	taskManager.taskMap[taskManager.index] = task
	taskManager.total++
	return task, nil
}

func (taskManager *TaskManager) Register(fc interface{}, args ...interface{}) (*Task, error) {
	task, err := taskManager.alloc()
	if err != nil {
		plog.Error(err)
		return nil, err
	}
	go func(fc interface{}, args ...interface{}) {
		if len(args) > 1 {
			fc.(func(...interface{}))(args)
		} else if len(args) == 1 {
			fc.(func(interface{}))(args[0])
		} else {
			fc.(func())()
		}
		taskManager.Unregister(task.id)
	}(fc, args...)
	return task, nil
}

func (taskManager *TaskManager) RegisterLoop(fc interface{}, args ...interface{}) (*Task, error) {
	task, err := taskManager.alloc()
	if err != nil {
		plog.Error(err)
		return nil, err
	}
	go func(fc interface{}, args ...interface{}) {
		if len(args) > 1 {
			for {
				select {
				case event := <-task.event:
					switch event {
					case EVENT_STOP:
						taskManager.Unregister(task.id)
						return
					}
				default:
				}
				fc.(func(...interface{}))(args)
			}

		} else if len(args) == 1 {
			for {
				select {
				case event := <-task.event:
					switch event {
					case EVENT_STOP:
						taskManager.Unregister(task.id)
						return
					}
				default:
				}
				fc.(func(interface{}))(args[0])
			}
		} else {
			for {
				select {
				case event := <-task.event:
					switch event {
					case EVENT_STOP:
						taskManager.Unregister(task.id)
						return
					}
				default:
				}
				fc.(func())()
			}
		}
		taskManager.Unregister(task.id)
	}(fc, args...)
	return task, nil
}

func (taskManager *TaskManager) RegisterActorWorker(actor Actor) (*Task, error) {
	task, err := taskManager.alloc()
	if err != nil {
		plog.Error(err)
		return nil, err
	}
	go func() {
		for {
			select {
			case event := <-task.event:
				switch event {
				case EVENT_STOP:
					taskManager.Unregister(task.id)
					return
				case EVENT_WAIT:
					runtime.Gosched()
				}
			case msg := <-task.msg:
				actor.OnReceive(msg)
			}
		}
	}()
	taskManager.actors[actor.GetName()] = task.id
	task.actor = actor
	return task, nil
}

func (taskManager *TaskManager) Unregister(id int) {
	task := taskManager.taskMap[id]
	if task.actor != nil {
		delete(taskManager.actors, task.actor.GetName())
	}
	delete(taskManager.taskMap, id)
	taskManager.total--
}

func (taskManager *TaskManager) Send(id int, msg interface{}) error {
	var task *Task
	var ok bool
	if task, ok = taskManager.taskMap[id]; !ok {
		err := errors.New(fmt.Sprintf("Could not find task for task id: %d", id))
		return err
	}
	task.msg <- msg
	return nil
}

func (taskManager *TaskManager) Running() bool {
	if taskManager.total > 0 {
		return true
	}
	return false
}

func (taskManager *TaskManager) Stop(id int) error {
	var task *Task
	var ok bool
	if task, ok = taskManager.taskMap[id]; !ok {
		err := errors.New(fmt.Sprintf("Could not find task for task id: %d", id))
		return err
	}
	task.event <- EVENT_STOP
	return nil
}
