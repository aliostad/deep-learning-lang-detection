package store

import (
	"github.com/haleyrc/godux"
	"github.com/haleyrc/godux/actions"
	"github.com/haleyrc/godux/reducers"
)

type Store struct {
	root *godux.Root
}

func Create() *Store {
	root := godux.CombineReducers(
		[]string{"auth", "vehicles"},
		[]godux.Reducer{reducers.NewAuth(), reducers.NewVehicles()},
	)

	return &Store{root: root}
}

func (s *Store) UpdateEmail(email string) {
	s.root.Dispatch(actions.UpdateEmail(email))
}

func (s *Store) UpdatePassword(password string) {
	s.root.Dispatch(actions.UpdatePassword(password))
}

func (s *Store) FetchVehicles() {
	s.root.Dispatch(actions.FetchVehicles())
}

func (s *Store) GetState() map[string]interface{} {
	rs := s.root.GetState()

	state := make(map[string]interface{})
	for k, v := range rs {
		state[k] = v.State
	}

	return state
}

func (s *Store) History() []godux.Event {
	return s.root.History()
}
