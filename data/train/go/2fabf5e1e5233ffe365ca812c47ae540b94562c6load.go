package main

import (
	"log"
	"os/exec"
	"strconv"
	"strings"
)

type Load struct {
	Load             []float64 `json:"load"`
	RunningProcesses int       `json:"runningprocesses"`
	TotalProcesses   int       `json:"totalprocesses"`
}

// load returns the current load average on the system
func load() (systemStruct, error) {
	loadRaw, err := exec.Command("cat", "/proc/loadavg").Output()
	if err != nil {
		log.Print(err)
		return nil, err
	}

	loadString := string(loadRaw)
	loadAvgSplit := strings.Split(loadString, " ")
	loadAvg, err := sliceAtof(loadAvgSplit[0:3])
	if err != nil {
		log.Print(err)
		return nil, err
	}
	processes, err := sliceAtoi(strings.Split(loadAvgSplit[3], "/"))
	if err != nil {
		log.Print(err)
		return nil, err
	}
	load := &Load{loadAvg, processes[0], processes[1]}

	return load, nil
}

// processorCount returns the number of cores in the system
func processorCount() (int64, error) {
	processors, err := exec.Command("grep", "-c", "^processor", "/proc/cpuinfo").Output()
	if err != nil {
		return 0, err
	}

	numberProcessors, err := strconv.ParseInt(string(processors), 0, 64)
	if err != nil {
		return 0, err
	}
	return numberProcessors, nil
}
