package state

import (
	"sync"
	"time"

	"github.com/apiarian/go-ipgs/cachedshell"
	"github.com/pkg/errors"
)

type Broker struct {
	state   *State
	mx      *sync.Mutex
	nodeDir string
	s       *cachedshell.Shell
	unpin   bool
}

func NewBroker(st *State, nodeDir string, s *cachedshell.Shell, unpin bool) *Broker {
	return &Broker{
		state:   st,
		mx:      &sync.Mutex{},
		nodeDir: nodeDir,
		s:       s,
		unpin:   unpin,
	}
}

func (b *Broker) Checkout() *State {
	b.mx.Lock()

	return b.state
}

func (b *Broker) Return() {
	b.mx.Unlock()
}

func (b *Broker) Checkin() error {
	b.state.LastUpdated = time.Now()

	err := b.state.Commit(b.nodeDir, b.s, b.unpin)
	if err != nil {
		return errors.Wrap(err, "failed to commit state")
	}

	return nil
}
