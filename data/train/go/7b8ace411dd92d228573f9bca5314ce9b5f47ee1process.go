package ios

import "os"

//Process is an interface around os.Process
type Process interface {
	Kill() error
	Release() error
	Signal(os.Signal) error
	Wait() (ProcessState, error)
	GetPid() int
	SetPid(int)
}

//ProcessReal is a wrapper around os.Process that implements ios.Process
type ProcessReal struct {
	process *os.Process
}

//NewProcess creates a struct that behaves like os.Process
func NewProcess(process ...*os.Process) Process {
	if len(process) > 0 {
		return &ProcessReal{process: process[0]}
	}
	return &ProcessReal{process: new(os.Process)}
}

//Kill is a wrapper around os.Process.Kill()
func (p *ProcessReal) Kill() error {
	return p.process.Kill()
}

//Release is a wrapper around os.Process.Release()
func (p *ProcessReal) Release() error {
	return p.process.Release()
}

//Signal is a wrapper around os.Process.Signal()
func (p *ProcessReal) Signal(sig os.Signal) error {
	return p.process.Signal(sig)
}

//Wait is a wrapper around os.Process.Wait()
func (p *ProcessReal) Wait() (ProcessState, error) {
	processState, err := p.process.Wait()
	return NewProcessState(processState), err
}

//GetPid is a wrapper around getting os.Process.Pid
func (p *ProcessReal) GetPid() int {
	return p.process.Pid
}

//SetPid is a wrapper around setting os.Process.Pid
func (p *ProcessReal) SetPid(pid int) {
	p.process.Pid = pid
}
