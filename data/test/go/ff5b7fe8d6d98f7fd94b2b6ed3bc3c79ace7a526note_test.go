package module

import (
	"testing"
)

//Info for each note:
//
//_____byte 1_____   byte2_    _____byte 3_____   byte4_
///                \ /      \  /                \ /      \
//0000          0000-00000000  0000          0000-00000000
//
//Upper four    12 bits for    Lower four    Effect command.
//bits of sam-  note period.   bits of sam-
//ple number.                  ple number.

// A#6-01
// 0000-0000-0111-1000-0001-0000-0000-0000
// sample number: 0000-0001
// period: 0000-0111-1000
var testNote1 = []byte{0x00,0x78,0x10,0x00}
// A#6-03
// 0000-0000-0111-1000-0011-0000-0000-0000
// sample number: 0000-0011
// period: 0000-0111-1000
var testNote2 = []byte{0x00,0x78,0x30,0x00}
// A#6-01 90F
// 0000-0000-0111-1000-0001-1001-0000-1111
// period: 0000-0111-1000
var testNote3 = []byte{0x00,0x78,0x19,0x0f}
// A#6-03 90F
// 0000-0000-0111-1000-0011-1001-0000-1111
// period: 0000-0111-1000
var testNote4 = []byte{0x00,0x78,0x39,0x0f}

func TestNoteLoad(t *testing.T) {
	n := Note{}
	n.Load(testNote1)

	if (n.period != 120 || n.instrument != 1 || n.effect != 0 || n.parameter != 0) {
		t.Errorf("Expected 120,1,0,0 got %d,%d,%d,%d",n.period,n.instrument,n.effect,n.parameter)
	}
	notestr,_ := n.ToString()
	if (notestr != "A#3") {
		t.Errorf("Expected %s, got %s","A#3")
	}

	n.Load(testNote3)
	if (n.period != 120 || n.instrument != 1 || n.effect != 9 || n.parameter != 15) {
		t.Errorf("Expected 120,1,9,15 got %d,%d,%d,%d",n.period,n.instrument,n.effect,n.parameter)
	}
	notestr,_ = n.ToString()
	if (notestr != "A#3") {
		t.Errorf("Expected %s, got %s","A#3")
	}

	n.Load(testNote4)
	if (n.period != 120 || n.instrument != 3 || n.effect != 9 || n.parameter != 15) {
		t.Errorf("Expected 120,3,9,15 got %d,%d,%d,%d",n.period,n.instrument,n.effect,n.parameter)
	}
	notestr,_ = n.ToString()
	if (notestr != "A#3") {
		t.Errorf("Expected %s, got %s","A#3")
	}

}

