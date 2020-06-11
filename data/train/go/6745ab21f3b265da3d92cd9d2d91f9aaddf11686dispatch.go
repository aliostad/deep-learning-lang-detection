package flux

// Action represents an action to be dispatched.
type Action struct {
	Name    string
	Payload interface{}
}

// Dispatch dispatches actions to the registered stores.
// Each actions contained in a are dispatched sequentially within the call.
// eg a[1] will be dispached once a[0] dispatch is complete.
// Each Dispatch call is perform within a new goroutine,
// which mean 2 different dispatch call will be executed in parallel.
func Dispatch(a ...Action) {
	go dispatchActions(a)
}

func dispatchActions(actions []Action) {
	for _, a := range actions {
		if err := dispatch(a); err != nil {
			return
		}
	}
}

func dispatch(a Action) error {
	storesMutex.Lock()
	storescpy := make([]Storer, len(stores))
	copy(storescpy, stores)
	storesMutex.Unlock()

	for _, s := range storescpy {
		if err := s.OnDispatch(a); err != nil {
			return err
		}
	}
	return nil
}
