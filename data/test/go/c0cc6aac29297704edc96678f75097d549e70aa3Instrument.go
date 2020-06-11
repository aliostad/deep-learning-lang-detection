package theory

// Instrument defines a stringed instrument and its tuning. It has a name
// a max fret, and series of array of midi note numbers that convey both
// how many strings it has as well has well as its tuning.
type Instrument interface {
	Name() string
	MaxFret() uint8
	MidiNoteNumbers() []uint8
}

// InstrumentType provides names for predefined Instrument definitions that can be used
type InstrumentType int

const (
	GuitarStandardTuning InstrumentType = iota
)

type instrument struct {
	name            string
	maxFret         uint8
	midiNoteNumbers []uint8
}

func (instrument instrument ) Name() string {
	return instrument.name
}
func (instrument instrument ) MaxFret() uint8 {
	return instrument.maxFret
}
func (instrument instrument ) MidiNoteNumbers() []uint8 {
	return instrument.midiNoteNumbers
}

var guitarStandardTuning = instrument{
	name: "Guitar, Standard Tuning",
	maxFret: 24,
	midiNoteNumbers: []uint8{40, 45, 50, 55, 59, 64}}

// Given an InstrumentType, return the corresponding Instrument
// TODO allow for user defined instruments
func CreateInstrument(t InstrumentType) Instrument {
	//for now, everyone gets standard tuning
	return &guitarStandardTuning;
}