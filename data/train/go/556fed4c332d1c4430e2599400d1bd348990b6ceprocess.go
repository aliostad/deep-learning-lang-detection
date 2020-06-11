package process

import (
	"fmt"

	"code.cloudfoundry.org/garden"
	"code.cloudfoundry.org/garden-windows/dotnet"
)

type DotNetProcessExitStatus struct {
	ExitCode int
	Err      error
}

type DotNetProcess struct {
	Pid             string
	StreamOpen      chan DotNetProcessExitStatus
	containerHandle string
	client          *dotnet.Client
}

func NewDotNetProcess(containerHandle string, client *dotnet.Client) DotNetProcess {
	return DotNetProcess{
		StreamOpen:      make(chan DotNetProcessExitStatus),
		containerHandle: containerHandle,
		client:          client,
	}
}

func (process DotNetProcess) ID() string {
	return process.Pid
}

func (process DotNetProcess) Wait() (int, error) {
	exitStatus := <-process.StreamOpen
	return exitStatus.ExitCode, exitStatus.Err
}

func (process DotNetProcess) SetTTY(ttyspec garden.TTYSpec) error {
	return nil
}

func (process DotNetProcess) Signal(signal garden.Signal) error {
	url := fmt.Sprintf("/api/containers/%s/processes/%s", process.containerHandle, process.Pid)
	return process.client.Delete(url)
}
