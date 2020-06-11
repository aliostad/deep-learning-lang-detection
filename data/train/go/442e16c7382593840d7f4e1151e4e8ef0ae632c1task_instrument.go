package instruments

import (
	"github.com/cloudfoundry-incubator/receptor"
	"github.com/cloudfoundry-incubator/runtime-schema/metric"
	"github.com/pivotal-golang/lager"
)

const (
	pendingTasks   = metric.Metric("TasksPending")
	runningTasks   = metric.Metric("TasksRunning")
	completedTasks = metric.Metric("TasksCompleted")
	resolvingTasks = metric.Metric("TasksResolving")
)

type taskInstrument struct {
	logger         lager.Logger
	receptorClient receptor.Client
}

func NewTaskInstrument(logger lager.Logger, receptorClient receptor.Client) Instrument {
	return &taskInstrument{logger: logger, receptorClient: receptorClient}
}

func (t *taskInstrument) Send() {
	pendingCount := 0
	runningCount := 0
	completedCount := 0
	resolvingCount := 0

	allTasks, err := t.receptorClient.Tasks()

	if err == nil {
		for _, task := range allTasks {
			switch task.State {
			case receptor.TaskStatePending:
				pendingCount++
			case receptor.TaskStateRunning:
				runningCount++
			case receptor.TaskStateCompleted:
				completedCount++
			case receptor.TaskStateResolving:
				resolvingCount++
			}
		}
	} else {
		t.logger.Error("failed-to-get-tasks", err)

		pendingCount = -1
		runningCount = -1
		completedCount = -1
		resolvingCount = -1
	}

	pendingTasks.Send(pendingCount)
	runningTasks.Send(runningCount)
	completedTasks.Send(completedCount)
	resolvingTasks.Send(resolvingCount)
}
