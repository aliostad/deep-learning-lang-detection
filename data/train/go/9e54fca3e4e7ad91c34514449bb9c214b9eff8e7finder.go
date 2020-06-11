package devoops

import (
	"fmt"
	"strings"

	"github.com/shirou/gopsutil/process"
)

type Process struct {
	Pid         int
	ProgramName string
	Args        []string
	Env         []string
}

func parentEnv(p *process.Process) []string {
	pp, err := p.Parent()
	if err != nil {
		return []string{}
	}

	return envForPid(int(pp.Pid))
}

func FindByPid(pid int) (Process, error) {
	ok, err := process.PidExists(int32(pid))
	if err != nil {
		return Process{}, fmt.Errorf("getting process: %s", err)
	}
	if !ok {
		return Process{}, fmt.Errorf("process `%d` does not exist", pid)
	}

	// initialize the process
	p, err := process.NewProcess(int32(pid))
	if err != nil {
		return Process{}, wrapProcErr(err)
	}

	// command line arguments
	cmdline, err := p.Cmdline()
	if err != nil {
		return Process{}, wrapProcErr(err)
	}
	cmdArgs := strings.Split(cmdline, " ")

	// environvent variables
	env := envForPid(pid)
	env = append(env, parentEnv(p)...)

	return Process{
		Pid:         pid,
		ProgramName: cmdArgs[0],
		Args:        cmdArgs[1:],
		Env:         env,
	}, nil
}

func wrapProcErr(err error) error {
	return fmt.Errorf("accessing process state: %s", err)
}
