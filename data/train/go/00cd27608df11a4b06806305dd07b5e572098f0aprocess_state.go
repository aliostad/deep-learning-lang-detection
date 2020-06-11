package ios

import (
	"os"
	"time"
)

//ProcessState is an interface around os.ProcessState
type ProcessState interface {
	Exited() bool
	Pid() int
	String() string
	Success() bool
	Sys() interface{}
	SysUsage() interface{}
	SystemTime() time.Duration
	UserTime() time.Duration
}

//ProcessStateReal is a wrapper around os.Process that implements ios.ProcessState
type ProcessStateReal struct {
	processState *os.ProcessState
}

//NewProcessState creates a struct that behaves like os.Process
func NewProcessState(processState ...*os.ProcessState) ProcessState {
	if len(processState) > 0 {
		return &ProcessStateReal{processState: processState[0]}
	}
	return &ProcessStateReal{processState: new(os.ProcessState)}
}

//Exited is a wrapper around os.ProcessState.Exited()
func (p *ProcessStateReal) Exited() bool {
	return p.processState.Exited()
}

//Pid is a wrapper around os.ProcessState.Pid()
func (p *ProcessStateReal) Pid() int {
	return p.processState.Pid()
}

//String is a wrapper around os.ProcessState.String()
func (p *ProcessStateReal) String() string {
	return p.processState.String()
}

//Success is a wrapper around os.ProcessState.Success()
func (p *ProcessStateReal) Success() bool {
	return p.processState.Success()
}

//Sys is a wrapper around os.ProcessState.Sys()
func (p *ProcessStateReal) Sys() interface{} {
	return p.processState.Sys()
}

//SysUsage is a wrapper around os.ProcessState.SysUsage()
func (p *ProcessStateReal) SysUsage() interface{} {
	return p.processState.SysUsage()
}

//SystemTime is a wrapper around os.ProcessState.SystemTime()
func (p *ProcessStateReal) SystemTime() time.Duration {
	return p.processState.SystemTime()
}

//UserTime is a wrapper around os.ProcessState.UserTime()
func (p *ProcessStateReal) UserTime() time.Duration {
	return p.processState.UserTime()
}
