// +build darwin

package sysstats

import (
	"os/exec"
	"strconv"
	"strings"
)

// LoadAvg represents the load average of the system
// The following are the keys of the map:
// Avg1  - The average processor workload of the last minute
// Avg5  - The average processor workload of the last 5 minutes
// Avg15 - The average processor workload of the last 15 minutes
type LoadAvg map[string]float64

// getLoadAvg gets the load average of an OSX system
func getLoadAvg() (loadAvg LoadAvg, err error) {
	// `sysctl -n vm.loadavg` returns the load average with the
	// following format:
	// { 1.33 1.27 1.38 }
	out, err := exec.Command(`sysctl`, `-n`, `vm.loadavg`).Output()
	if err != nil {
		return nil, err
	}

	loadAvg = LoadAvg{}
	fields := strings.Fields(string(out))
	for i := 1; i < 4; i++ {
		load, err := strconv.ParseFloat(fields[i], 64)
		if err != nil {
			return nil, err
		}
		switch i {
		case 1:
			loadAvg[`avg1`] = load
		case 2:
			loadAvg[`avg5`] = load
		case 3:
			loadAvg[`avg15`] = load
		}
	}

	return loadAvg, nil
}
