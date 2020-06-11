package ps

import (
	"io/ioutil"
	"os/exec"
	"strconv"
	"strings"
)

type Process struct {
	Pid     int64
	User    string
	Cpu     float64
	Mem     float64
	Time    string
	Command string
}

func compact(collection []string) []string {
	var result []string
	for i := 0; i < len(collection); i++ {
		if collection[i] != "" {
			result = append(result, collection[i])
		}
	}
	return result
}

func FindAllByCommand(query string) []Process {
	var collection []Process
	processes := Processes()
	for i := 0; i < len(processes); i++ {
		if strings.Contains(processes[i].Command, query) {
			collection = append(collection, processes[i])
		}
	}
	return collection
}

func FindByPid(pid int64) Process {
	var process Process
	processes := Processes()
	for i := 0; i < len(processes); i++ {
		if processes[i].Pid == pid {
			process = processes[i]
			break
		}
	}
	return process
}

func FindByPidFilePath(pid_file string) Process {
	var process Process
	processes := Processes()
	file, err := ioutil.ReadFile(pid_file)
	if err == nil {
		pid, _ := strconv.ParseInt(strings.Trim(string(file), "\n"), 10, 64)

		for i := 0; i < len(processes); i++ {
			if processes[i].Pid == pid {
				process = processes[i]
				break
			}
		}
	}
	return process
}

// USER PID %CPU %MEM VSZ RSS TT STAT STARTED TIME COMMAND
func Processes() []Process {
	var result []Process
	output, _ := exec.Command("ps", "aux").CombinedOutput()
	process_list := strings.Split(string(output), "\n")

	for i := 1; i < len(process_list); i++ {
		parts := compact(strings.Split(process_list[i], " "))
		if len(parts) >= 10 {
			var process Process
			process.User = parts[0]
			process.Pid, _ = strconv.ParseInt(parts[1], 10, 64)
			process.Cpu, _ = strconv.ParseFloat(parts[2], 64)
			process.Mem, _ = strconv.ParseFloat(parts[3], 64)
			process.Time = parts[9]
			for j := 10; j < len(parts); j++ {
				process.Command = process.Command + " " + parts[j]
			}
			result = append(result, process)
		}
	}
	return result
}
