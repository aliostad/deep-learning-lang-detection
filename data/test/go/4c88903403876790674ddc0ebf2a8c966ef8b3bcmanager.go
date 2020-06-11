// MIT License

// Copyright (c) 2015 rutcode-go

package target_manager

var (
	manager       *Manager
	mapDemensions map[string]map[string]*Demension
)

type Manager struct {
}

type TargetValues map[string]interface{}
type CompareValues map[string]interface{}

func NewManager() TragetManagerRepo {
	if manager == nil {
		manager = new(Manager)
		mapDemensions = make(map[string]map[string]*Demension)
	}
	return manager
}

func (p *Manager) GetTargetMapDemensions(name string) map[string]*Demension {
	return mapDemensions[name]
}
