package state

import "github.com/untoldwind/trustless/api"

func (s *Store) ActionShowAll() {
	s.dispatch(func(state *State) *State {
		state.entryFilterDeleted = false
		state.entryFilterType = ""
		return state
	})
	s.dispatch(s.refresh)
}

func (s *Store) ActionShowType(secretType api.SecretType) {
	s.dispatch(func(state *State) *State {
		state.entryFilterDeleted = false
		state.entryFilterType = secretType
		return state
	})
	s.dispatch(s.refresh)
}

func (s *Store) ActionShowDeleted() {
	s.dispatch(func(state *State) *State {
		state.entryFilterDeleted = true
		state.entryFilterType = ""
		return state
	})
	s.dispatch(s.refresh)
}
