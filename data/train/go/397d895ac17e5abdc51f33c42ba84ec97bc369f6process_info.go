package container_monitor

import (
	"github.com/shirou/gopsutil/process"
)

// Process info value object
type ProcessInfo struct {
	Name          string                  // Process name.
	PID           int32                   // Process system ID
	Status        string                  // Process status info.
	Cwd           string                  // Process file path.
	CreateTime    string                  // Process creation UNIX time.
	MemoryInfo    *process.MemoryInfoStat // Process memory usage info.
	MemoryPercent float64                 // Usage virtual memory in percents.
	NumThreads    int64                   // Process threads count.
	CPUPercent    float64                 // CPU usage in percents.
}
