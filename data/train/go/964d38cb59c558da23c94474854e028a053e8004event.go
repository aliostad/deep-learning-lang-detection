package pattern

// EventGen is implemented by anything that can generate Event's.
type EventGen interface {
	Next() (*Event, error)
}

// Event defines a generic event.
type Event struct {
	instrument string
	controls   map[string]float32
}

// Instrument returns the instrument for the event.
func (e *Event) Instrument() string {
	return e.instrument
}

// Controls gets the controls for the event.
func (e *Event) Controls() map[string]float32 {
	return e.controls
}

// AddCtrl adds a value to the event.
func (e *Event) AddCtrl(key string, val float32) {
	e.controls[key] = val
}

// NewEvent creates an event for the given instrument.
func NewEvent(instrument string) (*Event, error) {
	return &Event{
		instrument: instrument,
		controls:   map[string]float32{},
	}, nil
}
