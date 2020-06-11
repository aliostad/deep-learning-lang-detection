package system

import "os"

/*#######################
### Process interface ###
#######################*/

// this defines the methods that must be available to system process objects.
type Process interface {

	// returns the name of the process
	Name() string

	// sends a message via the system communication bus.
	Send(message string, data map[string]interface{})

	/* Provided by SystemProcess */

	// returns the numerical process ID
	PID() int
}

/*#########################
### ClientProcess class ###
#########################*/
// this class complies with Process interface and is
// intended for use in everyday programs.

type ClientProcess struct {
	name string
	*os.Process
}

// returns a new ClientProcess.
// this is a low level interface. high-level interface will be provided by FindProcess().
func newClientProcess(pid int) *ClientProcess {
	proc, err := os.FindProcess(pid)
	if err != nil {
		return nil
	}
	return &ClientProcess{"", proc}
}

// sends a message directly to a process.
func (p *ClientProcess) Send(message string, data map[string]interface{}) {
}

// returns the general non-unique name of the process, such as "DeviceManager"
func (p *ClientProcess) Name() string {

	// name is cached.
	if len(p.name) != 0 {
		return p.name
	}

	// we must lookup the name manually.
	// TODO.
	return ""
}

// returns the numerical process ID.
func (p *ClientProcess) PID() int {
	return p.Pid
}

/*#########################
### ServerProcess class ###
#########################*/
// this class complies with Process interface and is
// intended for use in system management processes.

type ServerProcess struct {
	name string
	*os.Process
}

// returns a new ClientProcess.
// this is a low level interface. high-level interface will be provided by FindProcess().
func newServerProcess(pid int) *ServerProcess {
	proc, err := os.FindProcess(pid)
	if err != nil {
		return nil
	}
	return &ServerProcess{"", proc}
}

// sends a message directly to a process.
func (p *ServerProcess) Send(message string, data map[string]interface{}) {
}

// returns the general non-unique name of the process, such as "DeviceManager"
func (p *ServerProcess) Name() string {

	// name is cached.
	if len(p.name) != 0 {
		return p.name
	}

	// we must lookup the name manually.
	// TODO.
	return ""
}

// returns the numerical process ID.
func (p *ServerProcess) PID() int {
	return p.Pid
}
