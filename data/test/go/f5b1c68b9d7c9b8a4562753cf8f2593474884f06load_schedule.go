package load

import ()

type LoadSchedule struct {
	LoadUnits map[int]*LoadUnit
}

func (loadSchedule *LoadSchedule) GetLoadUnit(index int) *LoadUnit {
	return loadSchedule.LoadUnits[index]
}

func (loadSchedule *LoadSchedule) Size() int {
	return len(loadSchedule.LoadUnits)
}

func (loadSchedule *LoadSchedule) MaxAgents() int {
	loadUnits := loadSchedule.LoadUnits
	max := int64(0)
	for _, loadUnit := range loadUnits {
		if loadUnit.NumberOfUsers > max {
			max = loadUnit.NumberOfUsers
		}
	}
	return int(max)
}

func NewLoadSchedule(loadUnits map[int]*LoadUnit) *LoadSchedule {
	return &LoadSchedule{loadUnits}
}
