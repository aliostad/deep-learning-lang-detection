package parsing

import (
	"github.com/cptavatar/rofretta-go/theory"
	"os"
	"bufio"
)

func LoadVoicings(fileName string, instrument theory.Instrument) []theory.Voicing {
	file, err := os.Open(fileName)
	if err != nil {
		theory.Log.WithError(err).WithField("filename", fileName).Fatal("Could not open file")
	}

	defer file.Close()

	scanner := bufio.NewScanner(file)
	parser := CreateVoicingParser(theory.CreateInstrument(theory.GuitarStandardTuning))
	voicings := make([]theory.Voicing, 0, 5)
	for scanner.Scan() {
		voicing, valid := parser.ParseVoicing(scanner.Text())
		if valid {
			if len(voicings) == cap(voicings) {
				tempSlice := make([]theory.Voicing, len(voicings), cap(voicings) * 2)
				copy(tempSlice, voicings)
				voicings = tempSlice
			}
			voicings = append(voicings, voicing)
		}
	}

	if err := scanner.Err(); err != nil {
		theory.Log.WithError(err).Fatal("Error reading from file")
	}
	return voicings
}
