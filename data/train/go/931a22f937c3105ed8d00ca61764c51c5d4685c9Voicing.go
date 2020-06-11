package theory


// An UnidentifiedVoicing is basically just a collection of plucked strings and their corresponding
// Instrument since we don't know kind it is (yet)
type UnidentifedVoicing interface {
	Strings() []InstrumentString
	Instrument() Instrument
	MidiValueForString(int) int8
	Notes(returnDisabled bool) []Note
}

// A Voicing is a given fingering for a chord. It provides the root of the chord, the chord type
// information about how the strings are play, and information about the instrument they are played on
type Voicing interface {
	UnidentifedVoicing
	Type() VocingType
	Root() Note
	Chord() Chord
	Name() string
}

type unidentifedVoicing struct {
	strings    []InstrumentString
	instrument Instrument
}

type voicing struct {
	unidentifedVoicing
	vType VocingType
	root  Note
	chord Chord
}

func (vc unidentifedVoicing) Strings() []InstrumentString {
	return vc.strings
}
func (vc unidentifedVoicing) Instrument() Instrument {
	return vc.instrument
}
func (vc unidentifedVoicing) MidiValueForString(i int) int8 {
	if vc.strings[i].Disabled() {
		return -1
	} else {
		return vc.strings[i].Fret() + int8(vc.instrument.MidiNoteNumbers()[i])
	}
}
func (vc unidentifedVoicing) Notes(returnDisabled bool) []Note {
	size := len(vc.instrument.MidiNoteNumbers())
	retval := make([]Note, 0, size)
	for i := 0; i < size; i ++ {
		midiValue := vc.MidiValueForString(i)
		if returnDisabled || midiValue != Disabled {
			retval = append(retval, CreateNoteInt(midiValue))
		}
	}
	return retval
}

func (vc voicing) Type() VocingType {
	return vc.vType
}
func (vc voicing) Root() Note {
	return vc.root
}
func (vc voicing) Chord() Chord {
	return vc.chord
}
func (vc voicing) Name() string {
	return vc.root.Name() + " " + vc.Chord().Name()
}

func CreateVoicing(strings []InstrumentString, instrument Instrument, root Note, chord Chord) Voicing {
	retval := voicing{root:root, chord:chord }
	retval.strings = strings
	retval.instrument = instrument

	//This algorithm could use some work, only really works for open
	var muted, open bool
	for _, str := range retval.Strings() {
		if str.Fret() == 0 {
			open = true
		} else if str.Fret() == -1 {
			muted = true
		}
	}
	if open {
		retval.vType = Open
	} else if muted {
		retval.vType = Shape
	} else {
		retval.vType = Bar
	}

	return retval
}
func CreateUnidentifedVoicing(strings []InstrumentString, instrument Instrument) UnidentifedVoicing {
	return unidentifedVoicing{strings, instrument}
}