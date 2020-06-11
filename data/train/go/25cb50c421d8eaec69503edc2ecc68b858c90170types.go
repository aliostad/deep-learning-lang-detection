package drum

import "fmt"

// Pattern is the high level representation of the
// drum pattern contained in a .splice file.
type Pattern struct {
	Version string
	Tempo   float32
	Tracks  []Track
}

func (p Pattern) String() string {
	s := fmt.Sprintf(
		"Saved with HW Version: %s\nTempo: %g\n",
		p.Version, p.Tempo,
	)

	for _, t := range p.Tracks {
		s += t.String() + "\n"
	}

	return s

}

// Track represents a single track of a drum pattern
// for a single instrument.
type Track struct {
	ID         uint32
	Instrument string
	Steps      Steps
}

func (t Track) String() string {
	return fmt.Sprintf(
		"(%d) %v\t%v",
		t.ID, t.Instrument, t.Steps,
	)
}

// Steps represents an encoded byte slice of drum pattern steps
// where a 0 (zero) value represents a step not to be played
// and a value >0 (bigger zero) represents a step to be played.
type Steps []byte

func (steps Steps) String() string {
	var s string
	for i := 0; i < len(steps); i++ {
		if i%4 == 0 {
			s += "|"
		}

		if steps[i] > 0 {
			s += "x"
		} else {
			s += "-"
		}
	}
	s += "|"
	return s
}
