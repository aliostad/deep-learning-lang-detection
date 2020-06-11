package main

import (
	"fmt"
	"os"
	"path/filepath"
	"sync"
)

type Manager struct {
	tasks map[int]*Task
	mutex sync.Mutex
}

// BUG(utkan) check UID of the process before adding; proc/*/status
func (manager *Manager) AddTask(pid int) (added bool, err error) {
	manager.mutex.Lock()
	defer manager.mutex.Unlock()

	exe, err := os.Readlink(fmt.Sprint("/proc/", pid, "/exe"))
	if in(filepath.Base(exe), exes) == false {
		// 		log.Println("error reading symlink: ", err)
		return
	}

	println("add", pid)

	t := NewTask(pid)
	manager.tasks[pid] = t
	return true, nil
}

func (manager *Manager) RmTask(pid int) {
	manager.mutex.Lock()
	defer manager.mutex.Unlock()

	if _, ok := manager.tasks[pid]; !ok {
		return
	}

	delete(manager.tasks, pid)

	println("rm", pid)
}
