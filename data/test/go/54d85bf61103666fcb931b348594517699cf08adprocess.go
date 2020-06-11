package process

import (
	"io/ioutil"
	"os"
	"strconv"
	"strings"
	"syscall"
)

type ProcessChecker struct{}
type ProcessKiller struct{}

func ReadPID(pidFilePath string) (int, error) {
	contents, err := ioutil.ReadFile(pidFilePath)
	if err != nil {
		return 0, err
	}

	return strconv.Atoi(strings.TrimSpace(string(contents)))
}

func (*ProcessChecker) Alive(pid int) bool {
	osProcess, findProcessErr := os.FindProcess(pid)
	if findProcessErr != nil {
		return false
	}
	err := osProcess.Signal(syscall.Signal(0))
	if err != nil {
		return false
	}

	return true
}

type PIDProvider func() (int, error)

func (k *ProcessKiller) KillProvidedPID(pidProvider PIDProvider) error {
	pid, err := pidProvider()
	if err != nil {
		return err
	}

	return k.Kill(pid)
}

func (*ProcessKiller) Kill(pid int) error {
	osProcess, findProcessErr := os.FindProcess(pid)
	if findProcessErr != nil {
		return findProcessErr
	}

	killProcessErr := osProcess.Kill()
	if killProcessErr != nil {
		return killProcessErr
	}

	osProcess.Wait()
	return nil
}
