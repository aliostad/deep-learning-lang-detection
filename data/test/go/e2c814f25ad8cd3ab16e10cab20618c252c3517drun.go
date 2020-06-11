package gardendocker

import (
	"os/exec"

	"github.com/cloudfoundry-incubator/garden"
	"github.com/cloudfoundry-incubator/garden-linux/process_tracker"
)

type RunHandler struct {
	ContainerCmd   ContainerCmder
	ProcessTracker process_tracker.ProcessTracker
}

//go:generate counterfeiter . ContainerCmder
type ContainerCmder interface {
	Cmd(path string, args ...string) *exec.Cmd
}

func (c *RunHandler) Run(spec garden.ProcessSpec, io garden.ProcessIO) (garden.Process, error) {
	cmd := c.ContainerCmd.Cmd(spec.Path, spec.Args...)
	return c.ProcessTracker.Run(0, cmd, io, spec.TTY, nil)
}

func (c *RunHandler) Attach(processID uint32, io garden.ProcessIO) (garden.Process, error) {
	return c.ProcessTracker.Attach(processID, io)
}

func (c *RunHandler) Stop(kill bool) error {
	panic("not implemented: stop")
}
