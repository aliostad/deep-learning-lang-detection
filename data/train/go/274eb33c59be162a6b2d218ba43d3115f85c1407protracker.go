package module

import (
	"fmt"
	"github.com/alexcesaro/log/stdlog"
	"errors"
)

type ProTracker struct {
	title string
	numChannels int8
	songLength int8
	restartPos int8
	sequenceTable [128]int8
	instruments [31]Instrument
	patterns []Pattern
	Module
}

func (m *ProTracker) Load(data []byte) error {
	name := string(data[0:20])
	length := len(data)
	m.title = name

	// Load sample metadata
	offset := int(20)
	// Todo: If there's no magic number we should assume only 15 samples, not 31
	for i := 0; i < 31; i++ {
		sampleMeta := data[offset:offset+30]
		instrument := Instrument{}
		instrument.Load(sampleMeta)
		offset += 30
		m.instruments[i] = instrument
	}

	m.songLength = int8(data[offset])
	offset++
	m.restartPos = int8(data[offset])
	offset++
	for i := 0; i < 128; i++ {
		m.sequenceTable[i] = int8(data[offset+i])
	}
	offset += 128
	magicNumber := string(data[offset:offset+4])
	offset += 4

	// Validate our magic number against known possible values and hence number of channels
	if (magicNumber == "M.K." || magicNumber == "FLT4" || magicNumber == "M!K!") {
		m.numChannels = 4
	} else if (magicNumber == "6CHN") {
		m.numChannels = 6
	} else if (magicNumber == "8CHN" || magicNumber == "FLT8") {
		m.numChannels = 8
	} else {
		// Assume 4 channels and that the magic number starting offset is actually
		// the start of the pattern data, so let's roll back
		m.numChannels = 4
		offset -= 4
	}

	// Start reading the pattern data
	numPatterns := m.NumPatterns()
	stdlog.GetFromFlags().Debugf("Starting to read %d patterns starting at offset %d",numPatterns,offset)
	m.patterns = make([]Pattern, numPatterns, numPatterns)
	for i := 0; i < numPatterns; i++ {
		pattern := Pattern{rows:make([]Row,64), numChannels:m.numChannels}
		// Sanity check for enough data remaining in the buffer
		for j := 0; j < pattern.NumRows(); j++ {
			row := Row{notes:make([]Note, m.numChannels)}
			for k := 0; k < pattern.NumChannels(); k++ {
				n := Note{}
				n.Load(data[offset:offset+4])
				row.notes[k] = n
				offset += 4
			}
			pattern.SetRow(j,row)
		}
/*
		if (offset + 1024) > length {
			errtxt := fmt.Sprintf("Exceeded remaining data length on pattern %d",i)
			return errors.New(errtxt)
		}*/
//		pattern.data = make([]byte, 1024)
//		copy(pattern.data, data[offset:offset+1024])
		//offset += 1024
		m.patterns[i] = pattern
	}

	// Start reading the sample data
	for i := 0; i < len(m.instruments); i++ {
		instrument := m.instruments[i]
		stdlog.GetFromFlags().Debugf("Loading sample %d at offset %d of length %d (%s)",i,offset,instrument.length,instrument.name)
		instrument.data = make([]byte, instrument.length)
		// Sanity check for enough data remaining in the buffer
		if (offset + int(instrument.length) > length) {
			errtxt := fmt.Sprintf("Exceeded remaining data length on sample %d (%s)",i,instrument.name)
			return errors.New(errtxt)
		}
		copy(instrument.data, data[offset:offset+int(instrument.length)])
		m.instruments[i] = instrument
		offset += int(instrument.length)
	}

	stdlog.GetFromFlags().Debugf("I'm done at offset %d and length was %d",offset,length)
	return nil
}

func (m *ProTracker) GetInstrument(i int) (Instrument,error) {
	if (i < 0 || i > len(m.instruments)) {
		return Instrument{},errors.New("Invalid instrument")
	} else {
		return m.instruments[i],nil
	}

}

func (m *ProTracker) Instruments() [31]Instrument {
	return m.instruments
}

func (m *ProTracker) SongLength() int8 {
	return m.songLength
}

func (m *ProTracker) SequenceTable() [128]int8 {
	return m.sequenceTable
}

func (m *ProTracker) Patterns() []Pattern {
	return m.patterns
}

func (m *ProTracker) NumPatterns() int {
	numPatterns := int(m.sequenceTable[0])
	for i := 0; i < len(m.sequenceTable); i++ {
		if int(m.sequenceTable[i]) > numPatterns {
			numPatterns = int(m.sequenceTable[i])
		}
	}
	// Increment num patterns because we count from zero, so we actually have highest-pattern-id+1 patterns.
	numPatterns++
	return numPatterns
}
func (m *ProTracker) Title() (string) {
	return m.title
}

func (m *ProTracker) Play() {
	fmt.Printf("Playing PT..\n")
}

func (m *ProTracker) GetPattern(patternNumber int8) (Pattern,error) {
	if (patternNumber < 0 || patternNumber > 127) {
		return Pattern{},errors.New("Pattern index out of range.")
	} else {
		return m.patterns[patternNumber], nil
	}
}