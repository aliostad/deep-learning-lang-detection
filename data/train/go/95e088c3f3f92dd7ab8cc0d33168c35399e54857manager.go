package task

import (
	"fmt"
	"log"
	"os"
	"sync"
	"time"
)

type Manager struct {
	FailedTasks TaskList
	ActionChan  chan TaskAction
	tasks       TaskList
	*log.Logger
	*time.Ticker
}

func NewManager() *Manager {
	actionChan := make(chan TaskAction, 50)
	manager := Manager{
		Logger:      log.New(os.Stdout, fmt.Sprintf("[task] "), log.Flags()),
		tasks:       make(TaskList, 0),
		Ticker:      time.NewTicker(time.Second),
		FailedTasks: make(TaskList, 0),
		ActionChan:  actionChan,
	}

	go func() {
		for _ = range manager.Ticker.C {
			now := time.Now()

			for _, t := range manager.tasks {
				if t.ScheduledTime.Before(now) {
					manager.ActionChan <- TaskAction{actionRemove, t}
					manager.ActionChan <- TaskAction{actionRun, t}
				}
			}
		}
	}()

	go func() {
		for {
			action := <-actionChan
			switch action.Action {
			case actionAdd:
				manager.addTask(action.Task)
			case actionRemove:
				manager.removeTask(action.Task)
			case actionRun:
				go manager.runOne(action.Task)
			case actionReschedule:
				manager.addTask(action.Task.Reschedule())
			case actionFail:
				manager.fail(action.Task)
			default:
				fmt.Println("unknown action!!")
			}
		}
	}()

	return &manager
}

func (manager *Manager) fail(t Task) {
	manager.Logger.Println(t.Name, t.failures, TaskError("failed after retries."))
	manager.FailedTasks = append(manager.FailedTasks, t)
}

func (manager *Manager) runOne(t Task) {
	if err := (*t.Runner).Run(); err != nil {
		t.failures += 1
		manager.Logger.Println(t.Name, t.failures, err)

		if t.failures > t.MaxFailures {
			manager.ActionChan <- TaskAction{actionFail, t}
			return
		}

		manager.ActionChan <- TaskAction{actionReschedule, t}
		return
	}

	t.failures = 0
	manager.ActionChan <- TaskAction{actionReschedule, t}
}

func (manager *Manager) addTask(t Task) {
	manager.tasks = append(manager.tasks, t)
	manager.Logger.Println(t.Name, "added for", t.ScheduledTime)
}

func (manager *Manager) removeTask(t Task) {
	i := manager.tasks.IndexOf(t)
	if i < 0 {
		manager.Logger.Println(fmt.Sprintf("Task '%s' isn't in list", t.Name))
		return
	}

	manager.tasks = append(manager.tasks[:i], manager.tasks[i+1:]...)
}

func (manager *Manager) Tasks() TaskList {
	return manager.tasks
}

func (manager *Manager) Find(name string) *Task {
	return manager.tasks.Find(name)
}

func (manager *Manager) Queue(t Task) {
	manager.ActionChan <- TaskAction{actionAdd, t}
}
