package detection

import (
	"github.com/cptavatar/rofretta-go/theory"
	"github.com/cptavatar/rofretta-go/parsing"
)

type VoicingDetector interface {
	ParseAndIdentifyVoicing(line string) (voicing []theory.Voicing, valid bool)
	IdentifyVoicing(vc theory.UnidentifedVoicing) []theory.Voicing
}

type detectionAlgorithm interface {
	Detect(vc theory.UnidentifedVoicing) []theory.Voicing
}

type voicingDetector struct {
	algorithm detectionAlgorithm
}

func (vd voicingDetector) ParseAndIdentifyVoicing(line string) (voicing []theory.Voicing, valid bool) {
	instrument := theory.CreateInstrument(theory.GuitarStandardTuning)
	parser := parsing.CreateVoicingParser(instrument)
	var stringz []theory.InstrumentString
	stringz, valid = parser.ParseStrings(line)
	if ! valid {
		return
	}

	voicing = vd.IdentifyVoicing(theory.CreateUnidentifedVoicing(stringz, instrument))
	return
}

func (vd voicingDetector) IdentifyVoicing(vc theory.UnidentifedVoicing) []theory.Voicing {
	return vd.algorithm.Detect(vc)
}

func CreateVoicingDetector() VoicingDetector {
	return voicingDetector{noteSetSizeDetector{}}
}

