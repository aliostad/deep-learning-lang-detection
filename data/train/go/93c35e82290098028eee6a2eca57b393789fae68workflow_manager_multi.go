package executor

import (
	"github.com/Clever/workflow-manager/gen-go/models"
)

// MultiWorkflowManager works with more than one WorkflowManager.
type MultiWorkflowManager struct {
	defaultt WorkflowManager
	wms      map[models.Manager]WorkflowManager
}

func NewMultiWorkflowManager(defaultt WorkflowManager, wms map[models.Manager]WorkflowManager) WorkflowManager {
	return &MultiWorkflowManager{
		defaultt: defaultt,
		wms:      wms,
	}
}

func (mwm MultiWorkflowManager) manager(typee models.Manager) (WorkflowManager, error) {
	wm, ok := mwm.wms[typee]
	if !ok {
		return mwm.defaultt, nil
	}
	return wm, nil
}

func (mwm *MultiWorkflowManager) CreateWorkflow(wd models.WorkflowDefinition, input string, namespace string, queue string, tags map[string]interface{}) (*models.Workflow, error) {
	wm, err := mwm.manager(wd.Manager)
	if err != nil {
		return nil, err
	}
	return wm.CreateWorkflow(wd, input, namespace, queue, tags)
}

func (mwm *MultiWorkflowManager) RetryWorkflow(workflow models.Workflow, startAt, input string) (*models.Workflow, error) {
	wm, err := mwm.manager(workflow.WorkflowDefinition.Manager)
	if err != nil {
		return nil, err
	}
	return wm.RetryWorkflow(workflow, startAt, input)
}

func (mwm *MultiWorkflowManager) CancelWorkflow(workflow *models.Workflow, reason string) error {
	wd := workflow.WorkflowDefinition
	wm, err := mwm.manager(wd.Manager)
	if err != nil {
		return err
	}
	return wm.CancelWorkflow(workflow, reason)
}

func (mwm *MultiWorkflowManager) UpdateWorkflowStatus(workflow *models.Workflow) error {
	wd := workflow.WorkflowDefinition
	wm, err := mwm.manager(wd.Manager)
	if err != nil {
		return err
	}
	return wm.UpdateWorkflowStatus(workflow)
}
