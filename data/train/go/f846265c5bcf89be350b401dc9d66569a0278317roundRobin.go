package algs

import (
	"450-p1/datastructs"
	"450-p1/process"
	"fmt"
	"sort"
)

func RoundRobin(processQueue datastructs.Queue, debug bool) {

	ticks := int64(0)
	contextSwitch := false
	quantum := int64(0)
	_ = quantum
	_ = contextSwitch

	var curProc process.Process

	var readyQueue datastructs.Queue
	var finishedProcs datastructs.Queue

	sort.Sort(process.ByArrival(processQueue))

  for {
    
    if debug {
      fmt.Printf("Tick %d:\n", ticks)
    }
    
		if ticks >= processQueue.Front().ArrivalTime && processQueue.Len() > 0 {
		  if debug {
		    fmt.Printf("Process %d has arrived\n", processQueue.Front().Pid)
		  }
			readyQueue.Enqueue(processQueue.Dequeue())
		}

		processReady := readyQueue.Len() > 0 && ticks >= readyQueue.Front().ArrivalTime
		processRunning := curProc != process.Process{}
		quantumExpired := processRunning && quantum == 10

		if processReady && !processRunning {
			curProc = readyQueue.Dequeue()
			if (curProc.StartTime == 0) {
			  curProc.StartTime = ticks
			}
		} else if quantumExpired {
		  quantum = 0
		  contextSwitch = true
		  if debug {
		    fmt.Printf("Switching from process %d", curProc.Pid)
		  }
		  readyQueue.Enqueue(curProc)
		  curProc = readyQueue.Dequeue()
		  if debug {
		    fmt.Printf(" to process %d\n", curProc.Pid)
		  }
		  if (curProc.StartTime == 0) {
			  curProc.StartTime = ticks + 1
			}
		}
		
		processRunning = curProc != process.Process{}

		if (processRunning) {
		  if !contextSwitch {
        curProc.WorkTicks += 1
        quantum += 1
        if debug {
          fmt.Printf("Process %d has done %d tick(s) of work\n", curProc.Pid, curProc.WorkTicks)
        }
			} else {
			  contextSwitch = false
			}
		}

		if (processRunning && curProc.WorkTicks == curProc.TotalTicks) {
			curProc.EndTime = ticks
			if debug {
			  fmt.Printf("Process %d has finished\n", curProc.Pid)
			}
			finishedProcs.Enqueue(curProc)
			curProc = process.Process{}
			quantum = 0
		}

		ticks += 1

		// when both queues are empty and no process is running, the simulation is over
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
	fmt.Printf("RR statistics:\n"+
		"\tCPU utilization = %.6f (%d/%d)\n"+
		"\tAverage response time = %.6f ticks\n"+
		"\tAverage turnaround time = %.6f ticks\n"+
		"%s",
		cpuUtil, totalProcTicks, ticks, // CPU Utilization
		avgResp, // Average response time
		avgTurn, // Average turnaround time
		processStr)
}


