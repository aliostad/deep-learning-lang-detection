/*
 *  Bulldozer Framework
 *  Copyright (C) DesertBit
 */

package main

import (
	"fmt"
	"os"
	"os/exec"
	"strings"
	"sync"
	"syscall"
	"time"
)

const (
	setFlagDelay      = 3 * time.Second
	InterruptExitCode = 5
)

var (
	process            *exec.Cmd
	processOutput      cmdOutput
	processMutex       sync.Mutex
	processWaitForExit chan (struct{})

	restartProcessOnError      bool = true
	restartProcessOnErrorTimer *time.Timer
)

func init() {
	restartProcessOnErrorTimer = time.AfterFunc(setFlagDelay, func() {
		restartProcessOnError = true
	})

	restartProcessOnErrorTimer.Stop()
}

//#############################//
//### Process Output Struct ###//
//#############################//

type cmdOutput struct{}

func (o *cmdOutput) Write(p []byte) (n int, err error) {
	// Trim spaces and new lines.
	output := strings.Trim(strings.TrimSpace(string(p)), "\n")

	// Append a # before each line.
	output = "#  " + strings.Join(strings.Split(output, "\n"), "\n#  ")

	// Log the output
	fmt.Println(output)

	return len(p), nil
}

//###############//
//### Private ###//
//###############//

func restartProcess() {
	// Lock the mutex
	processMutex.Lock()
	defer processMutex.Unlock()

	_stopProcess()
	_startProcess()
}

func startProcess() {
	// Lock the mutex
	processMutex.Lock()
	defer processMutex.Unlock()

	_startProcess()
}

func _startProcess() {
	// Check if process is running
	if isProcessRunning() {
		return
	}

	// Create the command.
	process = exec.Command(ProcessCmd, ProcessArgs...)
	process.Dir = SrcPath
	process.Env = os.Environ()
	process.Stdout = &processOutput
	process.Stderr = &processOutput

	fmt.Println(">  starting process...")

	// Start the process
	err := process.Start()
	if err != nil {
		fmt.Printf(">  failed to start process: %v\n", err)
		process = nil
		return
	}

	// Create the buffered wait channel.
	processWaitForExit = make(chan (struct{}))

	// Start a go process to wait for the process exit
	go func() {
		requestProcessRestart := false

		defer func() {
			// Close the wait channel on defer.
			close(processWaitForExit)

			// Restart the process after the channel has been closed if requested.
			if requestProcessRestart {
				restartProcess()
			}
		}()

		// Wait for the process to exit.
		err = process.Wait()
		if err != nil {
			// Try to obtain the exit code and don't log any
			// error if the exit code is the interrupt code.
			// Otherwise errors would be always logged when
			// stopProcess gets called.
			if exiterr, ok := err.(*exec.ExitError); ok {
				// The program has exited with an exit code != 0
				// There is no plattform independent way to retrieve
				// the exit code, but the following will work on Unix
				status, ok := exiterr.Sys().(syscall.WaitStatus)
				if ok && status.ExitStatus() == InterruptExitCode {
					return
				}
			}

			fmt.Printf(">  process exited with error: %v\n", err)

			if restartProcessOnError {
				fmt.Printf(">  restarting process...\n")

				// This is an endless loop prevention.
				restartProcessOnError = false
				restartProcessOnErrorTimer.Reset(setFlagDelay)

				// Request a process restart. This is handled in the deferred function.
				requestProcessRestart = true
			}
		}
	}()
}

func stopProcess() {
	// Lock the mutex
	processMutex.Lock()
	defer processMutex.Unlock()

	_stopProcess()
}

func _stopProcess() {
	// Check if process is running
	if !isProcessRunning() {
		return
	}

	fmt.Println(">  stopping process...")

	// Don't restart the process automatically.
	restartProcessOnError = false

	// Stop the process
	process.Process.Signal(os.Interrupt)

	// Wait for the process to exit.
	if processWaitForExit != nil {
		<-processWaitForExit
	}

	// Reset the process
	process = nil

	// Wait for a short timeout.
	time.Sleep(100 * time.Millisecond)

	// Reset the flag autostart flag again.
	restartProcessOnError = true
}

func isProcessRunning() bool {
	if process == nil {
		return false
	}

	// If sig is 0, then no signal is sent, but error checking is still per‐
	// formed; this can be used to check for the existence of a process ID  or
	// process group ID.
	err := process.Process.Signal(syscall.Signal(0))
	return err == nil
}
