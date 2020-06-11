package shell

import (
	"os/exec"
	"sync"
)

type ProcessManager struct {
	mu   sync.Mutex
	pids map[int]*Process
}

func NewProcessManager() *ProcessManager {
	return &ProcessManager{
		pids: make(map[int]*Process),
	}
}

func (p *ProcessManager) Get(pid int) *Process {
	p.mu.Lock()
	process := p.pids[pid]
	p.mu.Unlock()
	return process
}

func (p *ProcessManager) Start(cmd *exec.Cmd) (*Process, error) {
	process, err := StartProcess(cmd)
	if err != nil {
		return nil, err
	}
	p.mu.Lock()
	p.pids[cmd.Process.Pid] = process
	p.mu.Unlock()
	return process, nil
}
