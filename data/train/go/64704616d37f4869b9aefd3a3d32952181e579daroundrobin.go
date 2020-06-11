package gomsg

import (
	"sync"
)

var _ LBPolicy = &RoundRobinPolicy{}

type rrLoad uint64

func (l rrLoad) Compare(c Comparer) int {
	if other, ok := c.(rrLoad); ok {
		if l < other {
			return -1
		} else if l > other {
			return 1
		} else {
			return 0
		}
	}
	return 10
}

type RoundRobinPolicy struct {
	sync.RWMutex
	load rrLoad
}

func (this *RoundRobinPolicy) Borrow(topic string, initializer func(topic string) Comparer) Comparer {
	this.Lock()
	defer this.Unlock()

	if this.load == 0 {
		if load := initializer(topic); load != nil {
			this.load = initializer(topic).(rrLoad)
		}
	}
	this.load++
	return this.load
}

func (this *RoundRobinPolicy) Return(topic string, comp Comparer, err error) {

}

// Load is the current load for a service
func (this *RoundRobinPolicy) Load(topic string) Comparer {
	this.Lock()
	defer this.Unlock()
	return this.load
}

// Quarantined returns if it is in quarantine
func (this *RoundRobinPolicy) Quarantined(topic string) bool {
	return false
}
