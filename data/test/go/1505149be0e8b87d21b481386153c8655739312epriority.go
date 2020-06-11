package algs

import (
	"450-p1/datastructs"
	"450-p1/process"
	"fmt"
	"sort"
)

func Priority(processQueue datastructs.Queue, debug bool) {

	ticks := int64(0)
	contextSwitch := false

	var curProc process.Process

	var readyQueue datastructs.Queue
	var finishedProcs datastructs.Queue

	sort.Sort(process.ByArrival(processQueue))

	for {
		if ticks >= processQueue.Front().ArrivalTime && processQueue.Len() > 0 {
			readyQueue.Enqueue(processQueue.Dequeue())
			sort.Sort(process.ByPriority(readyQueue))
		}

		processReady := readyQueue.Len() > 0 && ticks >= readyQueue.Front().ArrivalTime
		processRunning := curProc != process.Process{}

		if processReady {
			if processRunning {
				if readyQueue.Front().Priority < curProc.Priority {
					contextSwitch = true
					// swap the current process with the new process
					readyQueue.Enqueue(curProc)
					curProc = readyQueue.Dequeue()
					if curProc.StartTime == 0 {
						curProc.StartTime = ticks + 1
					}
					sort.Sort(process.ByPriority(readyQueue))
				}
			} else {
				curProc = readyQueue.Dequeue()
				if curProc.StartTime == 0 {
					curProc.StartTime = ticks
				}
			}
		}
		
	  processRunning = curProc != process.Process{}

		// if a process is running
		if (processRunning) {
			if !contextSwitch {
				curProc.WorkTicks += 1
			} else {
				// for next work tick...
				contextSwitch = false
			}

			if curProc.WorkTicks == curProc.TotalTicks {
				curProc.EndTime = ticks
				finishedProcs.Enqueue(curProc)
				curProc = process.Process{}
			}
		}

		ticks += 1

		// when both queues and no process is running, the simulation is over
		if (processQueue.Len() == 0 && readyQueue.Len() == 0 && curProc == process.Process{}) {
			break
		}
	}

	sort.Sort(process.ByPid(finishedProcs))

	// collect information from finished processes
	var processStr string
	var totalProcTicks, totalResp, totalTurn int64
	cpuUtil := float64(0)
	avgResp := float64(0)
	avgTurn := float64(0)

	for _, process := range finishedProcs {
		processStr += fmt.Sprintf("\tProcess %d: entered=%d response=%d finished=%d\n", process.Pid, process.ArrivalTime, process.StartTime, process.EndTime)
		totalProcTicks += int64(process.TotalTicks)
		totalResp += (process.StartTime - process.ArrivalTime)
		totalTurn += (process.EndTime - process.ArrivalTime)
	}

	// final calculations
	cpuUtil = float64(totalProcTicks) / float64(ticks)
	avgResp = float64(totalResp) / float64(finishedProcs.Len())
	avgTurn = float64(totalTurn) / float64(finishedProcs.Len())

	// final output
	fmt.Printf("Priority statistics:\n"+
		"\tCPU utilization = %.6f (%d/%d)\n"+
		"\tAverage response time = %.6f ticks\n"+
		"\tAverage turnaround time = %.6f ticks\n"+
		"%s",
		cpuUtil, totalProcTicks, ticks, // CPU Utilization
		avgResp, // Average response time
		avgTurn, // Average turnaround time
		processStr)
}
