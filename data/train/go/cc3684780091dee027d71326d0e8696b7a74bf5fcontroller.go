package process

import (
	"strconv"

	harvestController "github.com/cristian-sima/Wisply/controllers/admin/log/harvest"
	"github.com/cristian-sima/Wisply/models/action"
)

// Controller manages the operations with the processes
type Controller struct {
	harvestController.Controller
	process *action.Process
}

// Prepare loads the process
func (controller *Controller) Prepare() {
	controller.Controller.Prepare()
	controller.SetTemplatePath("admin/log/harvest/process")
	controller.loadProcess()
}

// GetProcess returns the reference to the process
func (controller *Controller) GetProcess() *action.Process {
	return controller.process
}

func (controller *Controller) loadProcess() {
	ID := controller.Ctx.Input.Param(":process")
	intID, err := strconv.Atoi(ID)
	if err == nil {
		process := action.NewProcess(intID)
		controller.Data["process"] = process
		controller.process = process
		controller.SetCustomTitle("Process #" + strconv.Itoa(process.ID))
	}
}
