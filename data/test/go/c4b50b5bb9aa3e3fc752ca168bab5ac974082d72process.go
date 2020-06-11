package process

import (
	"github.com/cristian-sima/Wisply/models/action"
	"github.com/cristian-sima/Wisply/models/harvest"
)

// Process represents a harvesting process
type Process struct {
	Controller
}

// Display displays the log of a process
func (controller *Process) Display() {
	controller.show()
	controller.LoadTemplate("home")
}

// ShowAdvanceOptions displays the advance options for a process
func (controller *Process) ShowAdvanceOptions() {
	controller.SetCustomTitle("Advance options")
	controller.LoadTemplate("advance-options")
}

// Delete deletes a process
func (controller *Process) Delete() {
	process := controller.GetProcess()
	process.Delete()
	controller.LoadTemplate("advance-options")
}

// ShowHistory displays the entire log of a process
func (controller *Process) ShowHistory() {
	controller.show()
	controller.LoadTemplate("progress-history")
}

// ShowProcess displays the log of a process
func (controller *Process) show() {
	process := controller.GetProcess()

	if process.IsRunning {
		operationID := process.GetCurrentOperation().ID
		operation := action.NewOperation(operationID)
		controller.Data["operation"] = operation
	}
	controller.Data["operations"] = process.GetOperations()
	controller.Data["harvestProcess"] = harvest.NewProcess(process.Action.ID)
}
