package iris2

import (
	"fmt"
)

type CondUnit struct {
	running                     bool
	out                         chan Word
	err                         chan error
	Error                       <-chan error
	Result, Control             <-chan Word
	operation, source0, source1 <-chan Word
}

const (
	Equal = iota
	NotEqual
	LessThan
	GreaterThan
	LessThanOrEqual
	GreaterThanOrEqual
	SelectSource0
	SelectSource1
	PassTrue
	PassFalse
	NumberOfCondStates
)

func NewCondUnit(control, operation, source0, source1 <-chan Word) *CondUnit {
	var s CondUnit
	s.out = make(chan Word)
	s.err = make(chan error)
	s.operation = operation
	s.source0 = source0
	s.source1 = source1
	s.Error = s.err
	s.Control = control
	s.Result = s.out
	return &s
}
func buildIntegerFunction(cond func(Word, Word) bool) func(Word, Word) Word {
	return func(a, b Word) Word {
		if cond(a, b) {
			return 1
		} else {
			return 0
		}
	}
}

var dispatchTable [NumberOfCondStates]func(Word, Word) Word

func init() {
	dispatchTable[Equal] = buildIntegerFunction(func(a, b Word) bool { return a == b })
	dispatchTable[NotEqual] = buildIntegerFunction(func(a, b Word) bool { return a != b })
	dispatchTable[LessThan] = buildIntegerFunction(func(a, b Word) bool { return a < b })
	dispatchTable[GreaterThan] = buildIntegerFunction(func(a, b Word) bool { return a > b })
	dispatchTable[LessThanOrEqual] = buildIntegerFunction(func(a, b Word) bool { return a <= b })
	dispatchTable[GreaterThanOrEqual] = buildIntegerFunction(func(a, b Word) bool { return a >= b })
	dispatchTable[SelectSource0] = func(a, _ Word) Word { return a }
	dispatchTable[SelectSource1] = func(_, b Word) Word { return b }
	dispatchTable[PassTrue] = func(_, _ Word) Word { return 1 }
	dispatchTable[PassFalse] = func(_, _ Word) Word { return 0 }

}
func (this *CondUnit) body() {
	for this.running {
		select {
		case op := <-this.operation:
			if op >= NumberOfCondStates {
				this.err <- fmt.Errorf("operation index %d is an undefined instruction!", op)
			} else if op < 0 {
				this.err <- fmt.Errorf("Send an operation index %d which is less than zero", op)
			} else {
				this.out <- dispatchTable[op](<-this.source0, <-this.source1)
			}
		}
	}
}

func (this *CondUnit) controlQuery() {
	<-this.Control
	this.shutdown()
}

func (this *CondUnit) shutdown() {
	this.running = false
}

func (this *CondUnit) Startup() error {
	if this.running {
		return fmt.Errorf("Given conditional unit is already running!")
	} else {
		this.running = true
		go this.body()
		go this.controlQuery()
		return nil
	}
}
