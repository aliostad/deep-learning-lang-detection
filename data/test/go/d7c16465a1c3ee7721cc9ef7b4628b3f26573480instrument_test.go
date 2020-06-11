package impulse

import (
	"bytes"
	"testing"
)

var testITI = []byte("IMPIfilename\x00\x00\x00\x00\x00\x01\x01\x01\x00\x01" +
	"\xff<\x80 d\x02\x14\x02\x00\x00name\x00\x00\x00\x00\x00\x00\x00\x00\x00" +
	"\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\u007f\u007f\x00" +
	"\xff\x01\x02\x00\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\a" +
	"\x00\b\x00\t\x00\n\x00\v\x00\f\x00\r\x00\x0e\x00\x0f\x00\x10\x00\x11" +
	"\x00\x12\x00\x13\x00\x14\x00\x15\x00\x16\x00\x17\x00\x18\x00\x19\x00" +
	"\x1a\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x1f\x00 \x00!\x00\"\x00#\x00$" +
	"\x00%\x00&\x00'\x00(\x00)\x00*\x00+\x00,\x00-\x00.\x00/\x000\x001\x002" +
	"\x003\x004\x005\x006\x007\x008\x009\x00:\x00;\x00<\x00=\x00>\x00?\x00@" +
	"\x00A\x00B\x00C\x00D\x00E\x00F\x00G\x00H\x00I\x00J\x00K\x00L\x00M\x00N" +
	"\x00O\x00P\x00Q\x00R\x00S\x00T\x00U\x00V\x00W\x00X\x00Y\x00Z\x00[\x00\\" +
	"\x00]\x00^\x00_\x00`\x00a\x00b\x00c\x00d\x00e\x00f\x00g\x00h\x00i\x00j" +
	"\x00k\x00l\x00m\x00n\x00o\x00p\x00q\x00r\x00s\x00t\x00u\x00v\x00w\x00\a" +
	"\x03\x01\x02\x01\x02@\x00\x00 2\x00\x00d\x00\x00\x00\x00\x00\x00\x00" +
	"\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" +
	"\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" +
	"\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" +
	"\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\a\x03\x01\x02\x01\x02\xe0\x00" +
	"\x00\x002\x00 d\x00\xe0\x00\x00\xe0\x00\x00\xe0\x00\x00\xe0\x00\x00\xe0" +
	"\x00\x00\xe0\x00\x00\xe0\x00\x00\xe0\x00\x00\xe0\x00\x00\xe0\x00\x00" +
	"\xe0\x00\x00\xe0\x00\x00\xe0\x00\x00\xe0\x00\x00\xe0\x00\x00\xe0\x00" +
	"\x00\xe0\x00\x00\xe0\x00\x00\xe0\x00\x00\xe0\x00\x00\xe0\x00\x00\xe0" +
	"\x00\x00\x00\a\x03\x01\x02\x01\x02\xf0\x00\x00\x102\x00\xf0d\x00\xe0" +
	"\x00\x00\xe0\x00\x00\xe0\x00\x00\xe0\x00\x00\xe0\x00\x00\xe0\x00\x00" +
	"\xe0\x00\x00\xe0\x00\x00\xe0\x00\x00\xe0\x00\x00\xe0\x00\x00\xe0\x00" +
	"\x00\xe0\x00\x00\xe0\x00\x00\xe0\x00\x00\xe0\x00\x00\xe0\x00\x00\xe0" +
	"\x00\x00\xe0\x00\x00\xe0\x00\x00\xe0\x00\x00\xe0\x00\x00\x00\x00\x00" +
	"\x00\x00")

func checkInstrument(ins *Instrument, t *testing.T) {
	if got, want := ins.Filename, "filename"; got != want {
		t.Errorf("Instrument.Filename == %#v; want %#v", got, want)
	}
	if got, want := ins.NewNoteAction, NewNoteContinue; got != want {
		t.Errorf("Instrument.NewNoteAction == %v; want %v", got, want)
	}
	if got, want := ins.DuplicateCheckType, DuplicateCheckNote; got != want {
		t.Errorf("Instrument.DuplicateCheckType == %v; want %v", got, want)
	}
	if got, want := ins.DuplicateCheckAction,
		DuplicateCheckNoteOff; got != want {
		t.Errorf("Instrument.DuplicateCheckAction == %v; want %v", got, want)
	}
	if got, want := ins.FadeOut, uint16(256); got != want {
		t.Errorf("Instrument.FadeOut == %v; want %v", got, want)
	}
	if got, want := ins.PitchPanSeparation, int8(-1); got != want {
		t.Errorf("Instrument.PitchPanSeparation == %v; want %v", got, want)
	}
	if got, want := ins.PitchPanCenter, uint8(60); got != want {
		t.Errorf("Instrument.PitchPanCenter == %v; want %v", got, want)
	}
	if got, want := ins.GlobalVolume, uint8(128); got != want {
		t.Errorf("Instrument.GlobalVolume == %v; want %v", got, want)
	}
	if got, want := ins.DefaultPan, uint8(32); got != want {
		t.Errorf("Instrument.DefaultPan == %v; want %v", got, want)
	}
	if got, want := ins.DefaultPanOn, true; got != want {
		t.Errorf("Instrument.DefaultPanOn == %v; want %v", got, want)
	}
	if got, want := ins.VolumeSwing, uint8(100); got != want {
		t.Errorf("Instrument.VolumeSwing == %v; want %v", got, want)
	}
	if got, want := ins.PanSwing, uint8(2); got != want {
		t.Errorf("Instrument.PanSwing == %v; want %v", got, want)
	}
	if got, want := ins.NumSamples, uint8(0); got != want {
		t.Errorf("Instrument.NumSamples == %v; want %v", got, want)
	}
	if got, want := ins.Name, "name"; got != want {
		t.Errorf("Instrument.Name == %#v; want %#v", got, want)
	}
	if got, want := ins.MIDIChannel, byte(0); got != want {
		t.Errorf("Instrument.MIDIChannel == %v; want %v", got, want)
	}
	if got, want := ins.MIDIProgram, int8(-1); got != want {
		t.Errorf("Instrument.MIDIProgram == %v; want %v", got, want)
	}
	if got, want := ins.MIDIBankLow, int8(1); got != want {
		t.Errorf("Instrument.MIDIBankLow == %v; want %v", got, want)
	}
	if got, want := ins.MIDIBankHigh, int8(2); got != want {
		t.Errorf("Instrument.MIDIBankHigh == %v; want %v", got, want)
	}
	for i := range ins.KeyboardTable {
		if got, want := ins.KeyboardTable[i].Note, uint8(i); got != want {
			t.Errorf("KeyboardTable[%d].Note == %v; want %v", i, got, want)
		}
		if got, want := ins.KeyboardTable[i].Sample, uint8(0); got != want {
			t.Errorf("KeyboardTable[%d].Sample == %v; want %v", i, got, want)
		}
	}
	envelopes := []*Envelope{ins.VolumeEnvelope, ins.PanningEnvelope,
		ins.PitchEnvelope}
	envNames := []string{"VolumeEnvelope", "PanningEnvelope", "PitchEnvelope"}
	for i, env := range envelopes {
		if got, want := env.Flags,
			EnvelopeOn|EnvelopeLoopOn|EnvelopeSusLoopOn; got != want {
			t.Errorf("%s.Flags == %v; want %v", envNames[i], got, want)
		}
		if got, want := env.LoopBegin, uint8(1); got != want {
			t.Errorf("%s.LoopBegin == %v; want %v", envNames[i], got, want)
		}
		if got, want := env.LoopEnd, uint8(2); got != want {
			t.Errorf("%s.LoopEnd == %v; want %v", envNames[i], got, want)
		}
		if got, want := env.SusLoopBegin, uint8(1); got != want {
			t.Errorf("%s.SusLoopBegin == %v; want %v", envNames[i], got, want)
		}
		if got, want := env.SusLoopEnd, uint8(2); got != want {
			t.Errorf("%s.SusLoopEnd == %v; want %v", envNames[i], got, want)
		}
		if got, want := len(env.NodePoints), 3; got != want {
			t.Fatalf("len(%s.NodePoints) == %v; want %v", envNames[i], got,
				want)
		}
	}
	for i, want := range []NodePoint{{64, 0}, {32, 50}, {0, 100}} {
		if got, want := ins.VolumeEnvelope.NodePoints[i], want; got != want {
			t.Errorf("VolumeEnvelope.NodePoints[%d] == %v; want %v", i, got,
				want)
		}
	}
	for i, want := range []NodePoint{{-32, 0}, {0, 50}, {32, 100}} {
		if got, want := ins.PanningEnvelope.NodePoints[i], want; got != want {
			t.Errorf("PanningEnvelope.NodePoints[%d] == %v; want %v", i, got,
				want)
		}
	}
	for i, want := range []NodePoint{{-16, 0}, {16, 50}, {-16, 100}} {
		if got, want := ins.PitchEnvelope.NodePoints[i], want; got != want {
			t.Errorf("PitchEnvelope.NodePoints[%d] == %v; want %v", i, got,
				want)
		}
	}
}

func TestReadInstrument(t *testing.T) {
	// test invalid read on empty data
	r := bytes.NewReader([]byte{})
	if _, err := ReadInstrument(r); err == nil {
		t.Errorf("ReadInstrument() did not return error for empty data")
	}

	// test invalid read on bad data
	data := append([]byte("NOPE"), testITI[4:]...)
	r = bytes.NewReader(data)
	if _, err := ReadInstrument(r); err == nil {
		t.Errorf("ReadInstrument() did not return error for bad data")
	}

	// test valid read
	r = bytes.NewReader(testITI)
	ins, err := ReadInstrument(r)
	if err != nil {
		t.Fatalf("ReadInstrument() returned error: %v", err)
	}

	// test fields
	checkInstrument(ins, t)
}

func TestInstrumentWrite(t *testing.T) {
	// read instrument
	r := bytes.NewReader(testITI)
	ins, err := ReadInstrument(r)
	if err != nil {
		t.Fatalf("ReadInstrument() returned error: %v", err)
	}

	// write sample to buffer
	buf := new(bytes.Buffer)
	if err := ins.Write(buf); err != nil {
		t.Fatalf("Sample.Write() returned error: %v", err)
	}

	// read sample from buffer
	ins, err = ReadInstrument(bytes.NewReader(buf.Bytes()))
	if err != nil {
		t.Fatalf("ReadInstrument() returned error: %v", err)
	}

	// test fields
	checkInstrument(ins, t)
}
