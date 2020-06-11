package instruments

import (
	"github.com/cloudfoundry-incubator/receptor"
	"github.com/cloudfoundry-incubator/runtime-schema/metric"
)

const (
	desiredLRPs         = metric.Metric("LRPsDesired")
	startingLRPs        = metric.Metric("LRPsStarting")
	runningLRPs         = metric.Metric("LRPsRunning")
	crashedActualLRPs   = metric.Metric("CrashedActualLRPs")
	crashingDesiredLRPs = metric.Metric("CrashingDesiredLRPs")
)

type lrpInstrument struct {
	receptorClient receptor.Client
}

func NewLRPInstrument(receptorClient receptor.Client) Instrument {
	return &lrpInstrument{receptorClient: receptorClient}
}

func (t *lrpInstrument) Send() {
	desiredCount := 0
	runningCount := 0
	startingCount := 0
	crashedCount := 0

	allDesiredLRPs, err := t.receptorClient.DesiredLRPs()
	if err == nil {
		for _, lrp := range allDesiredLRPs {
			desiredCount += lrp.Instances
		}
	} else {
		desiredCount = -1
	}

	crashingDesireds := map[string]struct{}{}

	allActualLRPs, err := t.receptorClient.ActualLRPs()
	if err == nil {
		for _, lrp := range allActualLRPs {
			switch lrp.State {
			case receptor.ActualLRPStateClaimed:
				startingCount++
			case receptor.ActualLRPStateRunning:
				runningCount++
			case receptor.ActualLRPStateCrashed:
				crashingDesireds[lrp.ProcessGuid] = struct{}{}
				crashedCount++
			}
		}
	} else {
		startingCount = -1
		runningCount = -1
	}

	desiredLRPs.Send(desiredCount)
	startingLRPs.Send(startingCount)
	runningLRPs.Send(runningCount)
	crashedActualLRPs.Send(crashedCount)
	crashingDesiredLRPs.Send(len(crashingDesireds))
}
