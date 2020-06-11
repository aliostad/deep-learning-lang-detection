package loads_test

import (
	"testing"
	"time"

	. "github.com/jaimegildesagredo/gomonitor/loads"
)

const (
	A_DELAY        = 10 * time.Millisecond
	A_LOAD_ONE     = 1.69
	A_LOAD_FIVE    = 2.32
	A_LOAD_FIFTEEN = 4.48
)

func TestMonitorSystemLoad(t *testing.T) {
	loadService := NewLoadService(newInMemoryLoadRepository(LoadValues{
		A_LOAD_ONE, A_LOAD_FIVE, A_LOAD_FIFTEEN}))

	loads := loadService.Monitor(A_DELAY)

	load := <-loads
	loadValues := load.Values

	if loadValues[0] != A_LOAD_ONE || loadValues[1] != A_LOAD_FIVE || loadValues[2] != A_LOAD_FIFTEEN {
		t.Fatal("Invalid load values", load, "expected", A_LOAD_ONE, A_LOAD_FIVE, A_LOAD_FIFTEEN)
	}
}

func newInMemoryLoadRepository(load LoadValues) LoadRepository {
	return &inMemoryLoadRepository{
		load: load,
	}
}

type inMemoryLoadRepository struct {
	load LoadValues
}

func (repo *inMemoryLoadRepository) Get() LoadValues {
	return repo.load
}
