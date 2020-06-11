package manager

import (
	"testing"
)

func TestNewManager(t *testing.T) {

	var routineNum uint
	routineNum = 5
	manager := NewRoutineManager(routineNum)

	if manager.Used() != 0 {
		t.Error("new manager used num != 0")
	}

	manager.GetOne()
	if manager.Used() != 1 {
		t.Error("manager used num wrong")
	}

	manager.GetOne()
	if manager.Used() != 2 {
		t.Error("manager used num wrong")
	}

	if manager.Left()+manager.Used() != routineNum {
		t.Error("wrong Left num")
	}

	manager.FreeOne()
	if manager.Used() != 1 {
		t.Error("manager used num wrong")
	}
}
