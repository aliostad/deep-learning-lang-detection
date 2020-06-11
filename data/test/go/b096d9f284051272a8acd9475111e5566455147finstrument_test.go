package instrument

import (
	"reflect"
	"testing"
)

const targetTestVersion = 2

func TestTestVersion(t *testing.T) {
	if testVersion != targetTestVersion {
		t.Fatalf("Found testVersion = %v, want %v.", testVersion, targetTestVersion)
	}
}

// TestNewInstrument confirms that the default values for each test case are appropriate
func TestNewInstrument(t *testing.T) {
	for _, tt := range newInstrumentCases {
		got := NewInstrument(tt.inputType)
		if reflect.TypeOf(got) != reflect.TypeOf(tt.expectedType) {
			t.Fatalf("NewInstrument(%q) = %q which is not the desired return type.", tt.inputType, reflect.TypeOf(got))
		}
		fb := got.Fretboard()
		for k := range fb {
			if _, ok := fb[k]; !ok {
				t.Fatalf("NewInstrument(%q) = %q which is not a valid default value.", tt.inputType, fb[k])
			}
		}

		gotOrder := got.Order()
		wantOrder := tt.expectedType.Order()
		if len(fb) != len(tt.expectedType.Fretboard()) {
			t.Fatalf("Fretboard() = %q ::: length of got %d want %d", fb, len(fb), len(tt.expectedType.Fretboard()))
		}
		for i := range gotOrder {
			if gotOrder[i] != wantOrder[i] {
				t.Fatalf("Order() = %q ::: got %q want %q", gotOrder, gotOrder[i], wantOrder[i])
			}
		}
	}
}

func TestTune(t *testing.T) {
	for _, tt := range tuneCases {
		got := NewInstrument(tt.input)
		if err := got.Tune(tt.newTuning); (err != nil) != tt.wantErr {
			t.Fatalf("Tune(%q) error = %v, wantErr %v", tt.newTuning, err, tt.wantErr)
		}
	}
}

func TestParseFingerBoard(t *testing.T) {
	for _, tt := range parseFingerBoardCases {
		if _, _, err := ParseFingerBoard(tt.input); (err != nil) != tt.wantErr {
			t.Fatalf("ParseFingerBoard(%q) error = %v, wantErr %v", tt.input, err, tt.wantErr)
		}
	}
}

func BenchmarkParseFingerBoard(b *testing.B) {
	b.ReportAllocs()
	for i := 0; i < b.N; i++ {
		ParseFingerBoard(parseFingerBoardCases[0].input)
	}
}

func BenchmarkNewInstrument(b *testing.B) {
	b.ReportAllocs()
	for i := 0; i < b.N; i++ {
		NewInstrument(newInstrumentCases[0].inputType)
	}
}

func BenchmarkUpdateCurrentTab(b *testing.B) {
	player := NewInstrument(newInstrumentCases[0].inputType)

	b.ReportAllocs()
	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		UpdateCurrentTab(player, "E", "22")
	}
}
