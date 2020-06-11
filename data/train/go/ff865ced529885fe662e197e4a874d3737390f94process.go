package process

import "log"
import "strings"

import "github.com/shirou/gopsutil/process"

// Process represents a process in the OS
type Process struct {
	Pid    int32
	Name   string
	Kind   string
  // Client points to a connected client process if this is a database process
	Client *Process
}

// interestingNames are names of processes this tool analyzes (others are
// skipped for performance reasons)
var interestingNames = map[string]bool{
	"postgres":      true,
	"java":          true,
	"httpd-prefork": true,
}

// InterestingProcesses returns a map from PIDs to "interesting" Process objects
func InterestingProcesses() map[int32]*Process {
	pids, err := process.Pids()
	if err != nil {
		log.Fatal(err)
	}

	result := make(map[int32]*Process)
	inConnMap := make(map[uint32]*Process)
	outConnMap := make(map[uint32]*Process)
	for _, pid := range pids {
		process, err := process.NewProcess(pid)
		name, err := process.Name()
		if err != nil {
			continue
		}
		if interestingNames[name] || true {
			cmd, err := process.Cmdline()
			kind := "unknown"
			if err == nil {
				if name == "java" && strings.Contains(cmd, "org.apache.catalina.startup.Bootstrap") {
					kind = "Tomcat"
				}
				if name == "java" && strings.Contains(cmd, "com.redhat.rhn.taskomatic.core.TaskomaticDaemon") {
					kind = "Taskomatic"
				}
			}
			newProcess := &Process{pid, name, kind, nil}
			result[pid] = newProcess
			connections, err := process.Connections()
			if err != nil {
				continue
			}
			for _, connection := range connections {
				if connection.Status == "ESTABLISHED" && connection.Laddr.Port == 5432 {
					inConnMap[connection.Raddr.Port] = newProcess
				}
				if connection.Status == "ESTABLISHED" && connection.Raddr.Port == 5432 {
					outConnMap[connection.Laddr.Port] = newProcess
				}
			}
		}
	}

	for port, process := range inConnMap {
		process.Client = outConnMap[port]
	}

	return result
}
