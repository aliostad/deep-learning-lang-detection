package main

type Progress int

const (
	InvalidProgress Progress = iota
	PendingProgress
	CompletedProgress
	FailedProgress
)

type Process int

const (
	InvalidProcess Process = iota
	UpdateProcess
	CreateProcess
	DeleteProcess
	RollbackProcess
)

func (p Process) ActiveLabel() string {
	switch p {
	case UpdateProcess:
		return "    updating"
	case DeleteProcess:
		return "    deleting"
	case CreateProcess:
		return "    creating"
	case RollbackProcess:
		return "rolling back"
	}

	panic("invalid process")
}

func (p Process) CompletedLabel() string {
	switch p {
	case UpdateProcess:
		return "      update"
	case DeleteProcess:
		return "      delete"
	case CreateProcess:
		return "      create"
	case RollbackProcess:
		return "    rollback"
	}

	panic("invalid process")
}
