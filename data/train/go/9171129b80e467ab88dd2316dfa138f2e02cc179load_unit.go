package load

import (
	"time"
)

type LoadUnit struct {
	Interval, TransitionTime, NumberOfUsers int64
	OpenLoopsMaxPerSec                      int
	ActivationCount, TimeStarted            int64
}

func (loadUnit *LoadUnit) Activiate() {
	loadUnit.ActivationCount++
	loadUnit.TimeStarted = time.Now().UnixNano()
}

func (loadUnit *LoadUnit) IntervalEnd() int64 {
	return loadUnit.TimeStarted + loadUnit.Interval
}

func NewLoadUnit(interval, numberOfUsers int64) *LoadUnit {
	loadUnit := &LoadUnit{}
	loadUnit.Interval = interval
	loadUnit.NumberOfUsers = numberOfUsers
	loadUnit.TransitionTime = 0
	loadUnit.OpenLoopsMaxPerSec = 0
	loadUnit.TimeStarted = -1
	loadUnit.ActivationCount = 0
	return loadUnit
}
