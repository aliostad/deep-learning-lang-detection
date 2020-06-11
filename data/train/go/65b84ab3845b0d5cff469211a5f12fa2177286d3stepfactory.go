package pipeline

import (
	"github.com/gantsign/alt-galaxy/internal/util"
)

type factoryStep struct {
	StepBase
	processRole ProcessRole
}

func (step *factoryStep) processRoles() {
	for role := range step.RoleQueue {
		step.ConcurrentlyProcessRole(role, step.processRole)
	}
}

func (step *factoryStep) Start() {
	go step.processRoles()
}

func NewStep(processRole ProcessRole, maxConcurrent int) Step {
	return &factoryStep{
		processRole: processRole,
		StepBase: StepBase{
			Semaphore: util.NewSemaphore(maxConcurrent),
		},
	}
}
