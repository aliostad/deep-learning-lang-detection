package process

import (
	"consensus/util"
	"consensus/channel"
)

// interface for the function executed by threads, must periodically check if AtomicBool is setted, if it's the case the thread must terminate.
type WorkerFunction func(*ProcessConfiguration, *util.AtomicBool, *util.RetVal)  //function type, the last int is the retVal.


// parameters to the function, should not be modified after the start (concurrency).
type ProcessConfiguration struct {
	Channel         *channel.Channel
	ProcessId       int // process ID
	ProcessesNumber int // number of processes in the system.
	F               int // number of crashable processes.
	MaxVal          int // maximum decidable number + 1
}

func NewProcessConfiguration(channel *channel.Channel, processId int, processNumber int, F int, MaxVal int) *ProcessConfiguration {
	return &ProcessConfiguration{channel, processId, processNumber, F, MaxVal}
}

// ----------------PROCESS--------------

type Process struct {
	configuration *ProcessConfiguration // class that contains the configuration parameters of the process.
	state         *util.AtomicState     // state of the process: ERROR, STOP, RUNNING.
	terminator    *util.AtomicBool      // used to stop the process from the outside.
	function      WorkerFunction        // function that implements the process functionality.
	retVal        *util.RetVal          // return value of the process.
	endChannel    chan bool             // signal termination.
}

func NewProcess(configuration *ProcessConfiguration, function WorkerFunction) Process {
	return Process{configuration, util.NewAtomicState(), util.NewAtomicBool(), function, util.NewRetVal(), make(chan bool)}
}

/*
 * start the process.
 */
func (process *Process)Start() bool {
	switch process.state.Get() {
	case util.ERROR: // ERROR state, can be inconsistent state.
		return false
	case util.RUNNING: // already running.
		return true
	case util.STOP: // Okay, can start.
		go process.startFunction() // starts thread.
		process.state.Set(util.RUNNING)
		return true
	}
	return false
}

/*
 * execute the worker function.
 */
func (process *Process)startFunction() {
	process.retVal.Lock()
	process.function(process.configuration, process.terminator, process.retVal)
	process.retVal.Unlock()
	process.state.Set(util.STOP)
	//fmt.Printf("\tprocess %d finished\n", process.configuration.ProcessId)
	process.endChannel <- true// scrivi su channel che hai finito.

}

/*
 * check if the thread is running.
 */
func (process *Process)IsAlive() bool {
	switch process.state.Get() {
	case util.ERROR:
		return false
	case util.STOP:
		return false
	case util.RUNNING:
		return true
	}
	return false
}

/*
 * kill the process.
 */
func (process *Process)Stop() bool {
	switch process.state.Get() {
	case util.ERROR:
		return false
	case util.STOP:
		return true
	case util.RUNNING:
		process.terminator.Set()
		return true
	}
	return false
}

/*
 * block until the process signals his termination.
 */
func (process *Process)WaitTermination() *util.RetVal {
	switch process.state.Get(){
	case util.RUNNING: // need to wait termination.
		<-process.endChannel // read from channel signal for thread termination.
		return process.retVal
	case util.STOP: // already finished.
		return process.retVal
	case util.ERROR:
		return nil
	}
	return nil
}