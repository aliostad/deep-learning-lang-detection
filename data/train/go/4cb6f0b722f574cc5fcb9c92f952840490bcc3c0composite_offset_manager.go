package kafka

type CompositeOffsetManager struct {
	managers []OffsetManager
}

func NewCompositeOffsetManager(offsetManagers ...OffsetManager) *CompositeOffsetManager {
	m := &CompositeOffsetManager{
		managers: make([]OffsetManager, 0, len(offsetManagers)),
	}
	m.managers = append(m.managers, offsetManagers...)
	return m
}

func (m *CompositeOffsetManager) Close() {
	for _, manager := range m.managers {
		manager.Close()
	}
}

func (m *CompositeOffsetManager) InitOffset(partitionId int, offset int64) (err error) {
	var success bool

	for _, manager := range m.managers {
		if err = manager.InitOffset(partitionId, offset); err == nil {
			success = true
		}
	}

	if success {
		err = nil
	}
	return
}

func (m *CompositeOffsetManager) GetOffset(partitionId int) (offset int64, err error) {
	for _, manager := range m.managers {
		if offset, err = manager.GetOffset(partitionId); err == nil {
			return
		}
	}
	return
}

func (m *CompositeOffsetManager) SetOffset(partitionId int, offset int64) (err error) {
	var success bool

	for _, manager := range m.managers {
		if err = manager.SetOffset(partitionId, offset); err == nil {
			success = true
		}
	}

	if success {
		err = nil
	}
	return
}
