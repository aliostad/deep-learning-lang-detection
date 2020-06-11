package instrument

import (
	"errors"
	"fmt"
	"reflect"
	"strings"
)

// These can be used in the call to Tune() or exporting/displaying the tablature
const (
	MusicFlat  = "\u266D"
	MusicSharp = "\u266F"
)

const openPlayerString = "---"
const testVersion = 2

// Convenience constants which can be used to initialize a new Instrument.
const (
	InstGuitar      = "guitar"
	InstBass        = "bass"
	InstUkulele     = "ukulele"
	InstGuitarSeven = "guitar-seven"
	InstMandolin    = "mandolin"
	InstBassFive    = "bass-five"
)

// Instrument defines behavior that is common across the instruments used in this package, such as setting the tuning.
type Instrument interface {
	Tune(tuning []string) error
	Fretboard() Fretboard
	Order() TuningOrder
	NumOfStrings() int
}

// TuningOrder defines the order in which the strings would be physically on the guitar.
// TuningOrder can be used to display the strings properly and consistently.
type TuningOrder []string

// Fretboard represents the string/fretnumber relationship that is a single note or an entire chord.
type Fretboard map[string]string

// Guitar represents a standard 6 string guitar with a default tuning of Eadgbe.
// Tuning can be changed by calling Tune()
type Guitar struct {
	fretBoard    Fretboard
	order        TuningOrder
	numOfStrings int
}

// GuitarSeven represents a standard seven string guitar with a default tuning of BEadgbe.
// Tuning can be changed by calling Tune()
type GuitarSeven struct {
	fretBoard    Fretboard
	order        TuningOrder
	numOfStrings int
}

// Mandolin represents a standard 8 string mandolin (which will be treated as 4 strings since
// they are just different octaves) with a default tuning of Gdae.
// Tuning can be changed by calling Tune()
type Mandolin struct {
	fretBoard    Fretboard
	order        TuningOrder
	numOfStrings int
}

// Ukulele represents a standard 4 string ukulele with a default tuning of Gcea.
// Tuning can be changed by calling Tune()
type Ukulele struct {
	fretBoard    Fretboard
	order        TuningOrder
	numOfStrings int
}

// Bass represents a standard 4 string bass guitar with a default tuning of Eadg.
// Tuning can be changed by calling Tune()
type Bass struct {
	fretBoard    Fretboard
	order        TuningOrder
	numOfStrings int
}

// BassFive represents a five string bass guitar with a default tuning of BEadg.
// Tuning can be changed by calling Tune()
type BassFive struct {
	fretBoard    Fretboard
	order        TuningOrder
	numOfStrings int
}

// LapSteel represents a standard lap steel guitar with 6 strings and a default tuning of CEgace.
// Tuning can be changed by calling Tune()
type LapSteel struct {
	fretBoard    Fretboard
	order        TuningOrder
	numOfStrings int
}

// NewInstrument returns the configured instrument in its default tuning.  A Guitar in standard tuning will be returned by
// default if the desired instrument is not available.
func NewInstrument(i string) Instrument {
	var instrument Instrument

	switch i {
	case "guitar":
		instrument = newGuitar()
	case "bass":
		instrument = newBass()
	case "ukulele":
		instrument = newUkulele()
	case "guitar-seven":
		instrument = newGuitarSeven()
	case "mandolin":
		instrument = newMandolin()
	case "bass-five":
		instrument = newBassFive()
	case "lap-steel":
		instrument = newLapSteel()
	default:
		instrument = newGuitar()
	}

	return instrument
}

// Tune updates the tuning configuration of the current Guitar.  The order of the strings will also be the order in which the
// tuning was input to Tune().  Validation of the input will occur to make sure that the number of instrument strings is the same
// as the count of the input.
func (g *Guitar) Tune(tuning []string) error {
	for _, v := range tuning {
		if valid := validMusicNote(v); !valid {
			return errors.New("one or more of the note provided in the requested tuning is invalid")
		}
	}
	if ok := validCount(g, tuning); !ok {
		errMsg := tuningLengthError(g, tuning)
		return errors.New(errMsg)
	}
	for k := range g.fretBoard {
		delete(g.fretBoard, k)
	}
	for _, v := range tuning {
		g.fretBoard[v] = openPlayerString
	}
	g.order = TuningOrder(tuning)
	return nil
}

// Fretboard returns the current map which represents the Guitar pointer"s tuning.
func (g *Guitar) Fretboard() Fretboard {
	return g.fretBoard
}

// NumOfStrings returns the number of strings that the instrument has.
func (g *Guitar) NumOfStrings() int {
	return g.numOfStrings
}

// Order returns the current tuning order for the current Guitar
func (g *Guitar) Order() TuningOrder {
	return g.order
}

// returns a pointer to a guitar with standard tuning by default.
func newGuitar() *Guitar {
	return &Guitar{fretBoard: Fretboard{
		"E": openPlayerString,
		"a": openPlayerString,
		"d": openPlayerString,
		"g": openPlayerString,
		"b": openPlayerString,
		"e": openPlayerString,
	},
		order:        TuningOrder{"e", "b", "g", "d", "a", "E"},
		numOfStrings: 6,
	}
}

// Tune updates the tuning configuration of the current Bass.  The order of the strings will also be the order in which the
// tuning was input to Tune().  Validation of the input will occur to make sure that the number of instrument strings is the same
// as the count of the input.
func (b *Bass) Tune(tuning []string) error {
	for _, v := range tuning {
		if ok := validMusicNote(v); !ok {
			return errors.New("one or more of the note provided in the requested tuning is invalid")
		}
	}
	if ok := validCount(b, tuning); !ok {
		errMsg := tuningLengthError(b, tuning)
		return errors.New(errMsg)
	}
	return nil
}

// Order returns the current tuning order for the current Bass
func (b *Bass) Order() TuningOrder {
	return b.order
}

// Fretboard returns the current map which represents the Bass pointer"s tuning.
func (b *Bass) Fretboard() Fretboard {
	return b.fretBoard
}

// NumOfStrings returns the number of strings that the instrument has.
func (b *Bass) NumOfStrings() int {
	return b.numOfStrings
}

// returns a pointer to a guitar with a standard tuning by default.
func newBass() *Bass {
	return &Bass{fretBoard: Fretboard{
		"E": openPlayerString,
		"a": openPlayerString,
		"d": openPlayerString,
		"g": openPlayerString,
	},
		order:        TuningOrder{"g", "d", "a", "E"},
		numOfStrings: 4,
	}
}

func newUkulele() *Ukulele {
	return &Ukulele{fretBoard: Fretboard{
		"G": openPlayerString,
		"c": openPlayerString,
		"e": openPlayerString,
		"a": openPlayerString,
	},
		order:        TuningOrder{"a", "e", "c", "G"},
		numOfStrings: 4,
	}
}

// returns a pointer to a guitar with a standard tuning by default.
func newLapSteel() *LapSteel {
	return &LapSteel{fretBoard: Fretboard{
		"C": openPlayerString,
		"E": openPlayerString,
		"g": openPlayerString,
		"a": openPlayerString,
		"c": openPlayerString,
		"e": openPlayerString,
	},
		order:        TuningOrder{"e", "c", "a", "g", "E", "C"},
		numOfStrings: 6,
	}
}

// Tune updates the tuning configuration of the current Ukulele.  The order of the strings will also be the order in which the
// tuning was input to Tune().  Validation of the input will occur to make sure that the number of instrument strings is the same
// as the count of the input.
func (u *Ukulele) Tune(tuning []string) error {
	for _, v := range tuning {
		if ok := validMusicNote(v); !ok {
			return errors.New("one or more of the note provided in the requested tuning is invalid")
		}
	}
	if ok := validCount(u, tuning); !ok {
		errMsg := tuningLengthError(u, tuning)
		return errors.New(errMsg)
	}
	return nil
}

// Fretboard returns the current map which represents the Ululele pointer"s tuning.
func (u *Ukulele) Fretboard() Fretboard {
	return u.fretBoard
}

// NumOfStrings returns the number of strings that the instrument has.
func (u *Ukulele) NumOfStrings() int {
	return u.numOfStrings
}

// Order returns the current tuning order for the current Ukulele
func (u *Ukulele) Order() TuningOrder {
	return u.order
}

func newGuitarSeven() *GuitarSeven {
	return &GuitarSeven{fretBoard: Fretboard{
		"B": openPlayerString,
		"E": openPlayerString,
		"a": openPlayerString,
		"d": openPlayerString,
		"g": openPlayerString,
		"b": openPlayerString,
		"e": openPlayerString,
	},
		order:        TuningOrder{"e", "b", "g", "d", "a", "E", "B"},
		numOfStrings: 7,
	}
}

// Tune updates the tuning configuration of the current Seven-string guitar.  The order of the strings will also be the order in which the
// tuning was input to Tune().  Validation of the input will occur to make sure that the number of instrument strings is the same
// as the count of the input.
func (gs *GuitarSeven) Tune(tuning []string) error {
	for _, v := range tuning {
		if ok := validMusicNote(v); !ok {
			return errors.New("one or more of the note provided in the requested tuning is invalid")
		}
	}
	if ok := validCount(gs, tuning); !ok {
		errMsg := tuningLengthError(gs, tuning)
		return errors.New(errMsg)
	}
	return nil
}

// Fretboard returns the current map which represents the seven string guitar pointer"s tuning.
func (gs *GuitarSeven) Fretboard() Fretboard {
	return gs.fretBoard
}

// Order returns the current tuning order for the current seven string Guitar
func (gs *GuitarSeven) Order() TuningOrder {
	return gs.order
}

// NumOfStrings returns the number of strings that the instrument has.
func (gs *GuitarSeven) NumOfStrings() int {
	return gs.numOfStrings
}

func newMandolin() *Mandolin {
	return &Mandolin{fretBoard: Fretboard{
		"G": openPlayerString,
		"d": openPlayerString,
		"a": openPlayerString,
		"e": openPlayerString,
	},
		order:        TuningOrder{"e", "a", "d", "G"},
		numOfStrings: 4,
	}
}

// Tune updates the tuning configuration of the current mandolin.  The order of the strings will also be the order in which the
// tuning was input to Tune().  Validation of the input will occur to make sure that the number of instrument strings is the same
// as the count of the input.
func (m *Mandolin) Tune(tuning []string) error {
	for _, v := range tuning {
		if ok := validMusicNote(v); !ok {
			return errors.New("one or more of the note provided in the requested tuning is invalid")
		}
	}
	if ok := validCount(m, tuning); !ok {
		errMsg := tuningLengthError(m, tuning)
		return errors.New(errMsg)
	}
	return nil
}

// Fretboard returns the current map which represents the mandolin pointer"s tuning.
func (m *Mandolin) Fretboard() Fretboard {
	return m.fretBoard
}

// Order returns the current tuning order for the current Mandolin
func (m *Mandolin) Order() TuningOrder {
	return m.order
}

// NumOfStrings returns the number of strings that the instrument has.
func (m *Mandolin) NumOfStrings() int {
	return m.numOfStrings
}

func newBassFive() *BassFive {
	return &BassFive{fretBoard: Fretboard{
		"B": openPlayerString,
		"E": openPlayerString,
		"a": openPlayerString,
		"d": openPlayerString,
		"g": openPlayerString,
	},
		order:        TuningOrder{"g", "d", "a", "E", "B"},
		numOfStrings: 5,
	}
}

// Fretboard returns the current map which represents the 5 string bass pointer"s tuning.
func (bf *BassFive) Fretboard() Fretboard {
	return bf.fretBoard
}

// Order returns the current tuning order for the current 5 string bass
func (bf *BassFive) Order() TuningOrder {
	return bf.order
}

// NumOfStrings returns the number of strings that the instrument has.
func (bf *BassFive) NumOfStrings() int {
	return bf.numOfStrings
}

// Tune updates the tuning configuration of the current 5 string bass.  The order of the strings will also be the order in which the
// tuning was input to Tune().  Validation of the input will occur to make sure that the number of instrument strings is the same
// as the count of the input.
func (bf *BassFive) Tune(tuning []string) error {
	for _, v := range tuning {
		if ok := validMusicNote(v); !ok {
			return errors.New("one or more of the note provided in the requested tuning is invalid")
		}
	}
	if ok := validCount(bf, tuning); !ok {
		errMsg := tuningLengthError(bf, tuning)
		return errors.New(errMsg)
	}
	return nil
}

// Tune updates the tuning configuration of the current lap steel guitar.  The order of the strings will also be the order in which the
// tuning was input to Tune().  Validation of the input will occur to make sure that the number of instrument strings is the same
// as the count of the input.
func (l *LapSteel) Tune(tuning []string) error {
	for _, v := range tuning {
		if ok := validMusicNote(v); !ok {
			return errors.New("one or more of the note provided in the requested tuning is invalid")
		}
	}
	if ok := validCount(l, tuning); !ok {
		errMsg := tuningLengthError(l, tuning)
		return errors.New(errMsg)
	}
	return nil
}

// Fretboard returns the current map which represents the lap steel guitar tuning
func (l *LapSteel) Fretboard() Fretboard {
	return l.fretBoard
}

// Order returns the current tuning order for the current lap steel guitar
func (l *LapSteel) Order() TuningOrder {
	return l.order
}

// NumOfStrings returns the number of strings that the instrument has.
func (l *LapSteel) NumOfStrings() int {
	return l.numOfStrings
}

// UpdateCurrentTab accepts the guitarString and fret to be updated on the Instrument.
func UpdateCurrentTab(i Instrument, instrumentString string, fret string) {
	switch len(fret) {
	case 1:
		if fret == "0" {
			i.Fretboard()[instrumentString] = openPlayerString
			break
		}
		i.Fretboard()[instrumentString] = "--" + fret
	case 2:
		i.Fretboard()[instrumentString] = "-" + fret
	case 3:
		i.Fretboard()[instrumentString] = fret
	}
	return
}

func validCount(i Instrument, tuning []string) bool {
	return i.NumOfStrings() == len(tuning)
}

// validates that the fret number is numeric
func validFretCount(s string) bool {
	for _, v := range s {
		if v < '0' || v > '9' {
			return false
		}
	}
	return true
}

func tuningLengthError(i Instrument, tuning []string) string {
	return fmt.Sprintf("attempted to reconfigure the %s with %d strings which does not match the allowed %d number of strings",
		reflect.TypeOf(i),
		len(tuning),
		i.NumOfStrings())
}

// TODO(guitarbum722) define more valid characters such as hammer-ons, pull-offs and dead string 2017-04-15T18:00 4

// ParseFingerBoard validates input for the next tab fingering, validates it and returns the parsed values.
// The string and the fret number must be separated by a colon (:)
func ParseFingerBoard(i string) (string, string, error) {

	entry := strings.Split(i, ":")
	if len(entry) > 2 {
		return "", "-", errors.New("invalid entry: make sure the format is [string#]:[fret#] and the fret number is <= 999")
	}

	if !validMusicNote(entry[0]) {
		return "", "-", errors.New("invalid entry: make sure the string is a valid music note")
	}

	if len(entry[1]) > 3 {
		return "", "-", errors.New("invalid entry: fret cannot be more than 999")
	}

	if !validFretCount(entry[1]) {
		return "", "-", errors.New("invalid entry: make sure the fret number is numeric")
	}

	return entry[0], entry[1], nil
}
