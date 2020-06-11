package commands

import (
	"io"

	"github.com/ooesili/qfi/dispatch"
)

var (
	ErrNoShell  = dispatch.UsageError{"no shell specified"}
	ErrNoScript = dispatch.UsageError{"no script specified"}
)

type ShellDriver interface {
	GetScript(shell, scriptType string) ([]byte, error)
}

type Shell struct {
	Driver ShellDriver
	Logger io.Writer
}

func (a *Shell) Run(args []string) error {
	if len(args) == 0 {
		return ErrNoShell
	}
	if len(args) == 1 {
		return ErrNoScript
	}
	if len(args) > 2 {
		return ErrTooManyArgs
	}

	data, err := a.Driver.GetScript(args[0], args[1])
	if err != nil {
		return err
	}
	a.Logger.Write(data)
	return nil
}
