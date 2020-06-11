package main

import (
	"os"
	"os/exec"
	"strings"
	"syscall"

	"github.com/golang/glog"
)

type ProcessManagerOptions struct {
	command string
	args    []string
	errorCh chan error
}

type ProcessManager struct {
	ProcessManagerOptions
	process  *os.Process
	stopping bool
}

func NewProcessManager(options ProcessManagerOptions) (*ProcessManager, error) {
	mgr := &ProcessManager{
		ProcessManagerOptions: options,
	}

	go mgr.run()

	return mgr, nil
}

func (pm *ProcessManager) run() {
	glog.Infof("Starting child process with args: %s", strings.Join(pm.args, " "))

	cmd := exec.Command(pm.command, pm.args...)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	if err := cmd.Start(); err != nil {
		glog.Errorf("Child process failed to start: %v", err)
		pm.errorCh <- err
		return
	}

	pm.process = cmd.Process

	err := cmd.Wait()
	if err != nil {
		glog.Errorf("Child process failed: %v", err)
	} else {
		glog.Infof("Child process terminated: %s", cmd.ProcessState.String())
	}
	if !pm.stopping {
		pm.errorCh <- err
	}

	pm.process = nil
	return
}

// Implements Stoppable
func (pm *ProcessManager) Stop() {
	if !pm.stopping {
		pm.stopping = true
		if pm.process != nil {
			glog.Info("Sending SIGTERM to child process")
			if err := pm.process.Kill(); err != nil {
				glog.Errorf("Kill failed: %s", err)
			}
		}
	}
}

// Implements Reloadable
func (pm *ProcessManager) Reload() error {
	if pm.process != nil {
		glog.Info("Sending SIGHUP to application")
		return pm.process.Signal(syscall.SIGHUP)
	}
	return nil
}
