package utils

// Interface for general worker manager
type WorkerManagerInterface interface {
	GetWorkerCtAttribute() int
}

// Struct for general worker manager
type WorkerManager struct {
	WorkerCt int
}

// Return worker manager worker ct attribute
func (manager WorkerManager) GetWorkerCtAttribute() int {
	if manager.WorkerCt == 0 {

		// Default worker ct attribute to 1
		return 1
	}

	return manager.WorkerCt
}

// Set worker manager worker ct attribute
func (manager *WorkerManager) SetWorkerCtAttribute(n int) {
	manager.WorkerCt = n
}
