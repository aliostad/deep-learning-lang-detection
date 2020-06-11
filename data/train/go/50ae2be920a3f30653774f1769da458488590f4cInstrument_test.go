package theory

import "testing"

func TestInstrument(t *testing.T) {
	instrument := CreateInstrument(GuitarStandardTuning)
	if instrument.MaxFret() != 24 {
		t.Error("MaxFret should be 24")
	}
	if instrument.Name() != "Guitar, Standard Tuning" {
		t.Error("Name should be 'Guitar, Standard Tuning'")
	}
	notes := instrument.MidiNoteNumbers()
	if len(notes) != 6 {
		t.Error("MidiNoteNumbers should return an array of 6 values")
	}
	if notes[0] != 40 {
		t.Error("MidiNoteNumbers should return an array that begins with 40")
	}
}