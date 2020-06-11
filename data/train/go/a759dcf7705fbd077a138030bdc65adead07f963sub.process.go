package models

const (
	ProcessNotStarted = 0
	ProcessStarted    = 1
	ProcessFinished   = 2
	ProcessAborted    = 3
	ProcessUpdate     = 4
)

type SubProcess struct {
	StateChannel chan SubProcessState
	State        int
	ProcessName  string
	Message      string
	Current      int
	Total        int
}

type SubProcessState struct {
	State       int
	ProcessName string
	Message     string
}

func (sp *SubProcess) Start() {
	sp.StateChannel <- SubProcessState{
		State:       ProcessStarted,
		ProcessName: sp.ProcessName,
	}
}

func (sp *SubProcess) Abort() {
	sp.StateChannel <- SubProcessState{
		State:       ProcessAborted,
		ProcessName: sp.ProcessName,
	}
}

func (sp *SubProcess) Finish() {
	sp.StateChannel <- SubProcessState{
		State:       ProcessFinished,
		ProcessName: sp.ProcessName,
	}
}

func (sp *SubProcess) Update(msg string) {
	sp.StateChannel <- SubProcessState{
		State:       ProcessUpdate,
		ProcessName: sp.ProcessName,
		Message:     msg,
	}
}
