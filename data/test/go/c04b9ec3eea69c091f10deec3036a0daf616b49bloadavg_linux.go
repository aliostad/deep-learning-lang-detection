// +build linux

package sysstats

import (
	"io/ioutil"
	"strconv"
	"strings"
)

// LoadAvg represents the load average of the system
type LoadAvg struct {
	Avg1  float64 `json:"avg1"`  // The average processor workload of the last minute
	Avg5  float64 `json:"avg5"`  // The average processor workload of the last 5 minutes
	Avg15 float64 `json:"avg15"` // The average processor workload of the last 15 minutes
}

// getLoadAvg gets the load average of a linux system from the
// file /proc/loadavg.
func getLoadAvg() (loadAvg LoadAvg, err error) {
	file, err := ioutil.ReadFile("/proc/loadavg")
	if err != nil {
		return LoadAvg{}, err
	}
	content := string(file[:len(file)])

	loadAvg = LoadAvg{}
	fields := strings.Fields(content)
	loadAvg1, err := strconv.ParseFloat(fields[0], 64)
	if err != nil {
		return LoadAvg{}, err
	}
	loadAvg.Avg1 = loadAvg1
	loadAvg5, err := strconv.ParseFloat(fields[1], 64)
	if err != nil {
		return LoadAvg{}, err
	}
	loadAvg.Avg5 = loadAvg5
	loadAvg15, err := strconv.ParseFloat(fields[2], 64)
	if err != nil {
		return LoadAvg{}, err
	}
	loadAvg.Avg15 = loadAvg15

	return loadAvg, nil
}
