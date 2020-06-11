package system

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
	MemoryPersent float32                 // Usage virtual memory in percents.
	NumThreads    int32                   // Process threads count.
	CPUPersent    float64                 // CPU usage in percents.
}
