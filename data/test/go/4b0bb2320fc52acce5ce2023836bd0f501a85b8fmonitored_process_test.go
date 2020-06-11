package watchgod

import (
	"testing"
)

func TestCreateProcess(t *testing.T) {
	monitor := make(chan ProcessInfo, 1)
	process := newProcess("greetings", []string{"echo", "hello world"}, monitor)
	if process.id != "greetings" || process.pid != 0 || process.state != STOPPED {
		t.Fatalf("Create process did not retrun a valid process")
	}
}

func TestStartProcess(t *testing.T) {
	defaultMonitor := make(chan ProcessInfo, 1)
	go func() {
		for {
			<-defaultMonitor
		}
	}()
	process := newProcess("sleeper", []string{"sleep", "5"}, defaultMonitor)
	monitor := make(chan ProcessInfo, 1)
	process.start(monitor)
	processInfo := <-monitor

	if processInfo.state != RUNNING {
		t.Fatalf("Start process state is not RUNNING >>> %s", processInfo.state)
	}
	if processInfo.pid <= 0 {
		t.Fatalf("Start process PID is not greater than zero >>> %d", processInfo.pid)
	}
}

func TestStartAndDieProcess(t *testing.T) {
	defaultMonitor := make(chan ProcessInfo, 1)
	process := newProcess("greetings", []string{"echo", "hello world"}, defaultMonitor)
	monitor := make(chan ProcessInfo, 1)
	process.start(monitor)

	processInfo := <-monitor
	if processInfo.state != RUNNING {
		t.Fatalf("Start process state is not RUNNING >>> %s", processInfo.state)
	}

	processInfo = process.waitForNextEvent(defaultMonitor, 1)
	if processInfo.state != DEAD {
		t.Fatalf("Process did not died within one second (%s)", processInfo.state)
	}
}

func TestStartAndStableProcess(t *testing.T) {
	defaultMonitor := make(chan ProcessInfo, 1)
	process := newProcess("sleeper", []string{"sleep", "3"}, defaultMonitor)
	monitor := make(chan ProcessInfo, 1)
	process.start(monitor)

	processInfo := <-monitor
	if processInfo.state != RUNNING {
		t.Fatalf("Start process state is not RUNNING >>> %s", processInfo.state)
	}

	processInfo = process.waitForNextEvent(defaultMonitor, 2)
	if processInfo.state != TIMEOUT {
		t.Fatalf("Process probably died (%s), expected TIMEOUT", processInfo.state)
	}
}

func TestStartAndKillProcess(t *testing.T) {
	defaultMonitor := make(chan ProcessInfo, 1)
	process := newProcess("sleeper", []string{"sleep", "60"}, defaultMonitor)
	monitor := make(chan ProcessInfo, 1)
	process.start(monitor)

	processInfo := <-monitor
	if processInfo.state != RUNNING {
		t.Fatalf("Start process state is not RUNNING >>> %s", processInfo.state)
	}
	process.stop(monitor)
	processInfo = <-defaultMonitor
	if processInfo.state != DEAD {
		t.Fatalf("Process probably died (%s), expected TIMEOUT", processInfo.state)
	}
}
