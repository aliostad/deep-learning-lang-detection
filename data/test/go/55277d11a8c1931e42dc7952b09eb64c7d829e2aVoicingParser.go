package parsing

import (
	"strings"
	"strconv"
	"github.com/cptavatar/rofretta-go/theory"
)

// VoicingParser can extract voicing information from strings, based on our standard encoding
type VoicingParser interface {
	ParseVoicing(line string) (theory.Voicing, bool)
	ParseStrings(line string) ([]theory.InstrumentString, bool)
}

type voicingParser struct {
	instrument theory.Instrument
}

func (vp voicingParser) ParseVoicing(line string) (voicing theory.Voicing, valid bool) {
	valid = false
	if strings.Index(line, "#") != -1 {
		theory.Log.WithField("line", line).Debug("skipping line with comments")
		return
	}
	fields := strings.Fields(line)
	if (len(fields) != 4) {
		theory.Log.WithField("line", line).Debug("skipping line that did not have exactly 4 fields")
		return
	}
	desiredSize := len(vp.instrument.MidiNoteNumbers())
	frets := vp.parseInts(fields[0], desiredSize)
	fingers := vp.parseInts(fields[1], desiredSize)

	voicing = theory.CreateVoicing(
		vp.createStrings(frets, fingers),
		vp.instrument,
		theory.CreateNote(fields[2]),
		theory.CreateChordByShortName(fields[3]))
	valid = true
	return
}
func (vp voicingParser) ParseStrings(line string) (strgs []theory.InstrumentString, valid bool) {
	frets := vp.parseInts(line, len(vp.instrument.MidiNoteNumbers()))
	strgs = vp.createStrings(frets, nil)
	valid = true
	return
}

func (vp voicingParser) createStrings(frets *[]int, fingers *[]int) []theory.InstrumentString {
	size := len(*frets)

	retval := make([]theory.InstrumentString, 0, size)
	for i, val := range *frets {
		var tempFingers = -1
		if (fingers != nil) {
			tempFingers = (*fingers)[i]
		}

		retval = append(retval, theory.CreateInstrumentStringInt(int8(val), tempFingers))
	}

	return retval
}

// TODO improve error handling
func (vp voicingParser) parseInts(str string, size int) *[]int {
	var retval = make([]int, 0, size)
	var index = 0
	var carryOver = false

	for _, r := range str {
		s := string(r)
		switch(s){
		case "x":
			retval = append(retval, -1)
			index++
			carryOver = false
		case "!":
			fallthrough
		case "|":
			carryOver = true
		default:
			val, err := strconv.ParseInt(s, 10, 16)
			if (err != nil) {
				theory.Log.WithError(err).WithField("input", str).Fatal("Unexpected character while trying to covert field. Only 'x','!','|', and numbers allowed.")
			}
			retval = append(retval, int(val))
			if (carryOver) {
				retval[index] = retval[index] + 10
				carryOver = false
			}
			index++
		}

	}

	return &retval
}

func CreateVoicingParser(instrument theory.Instrument) VoicingParser {
	return voicingParser{instrument}
}