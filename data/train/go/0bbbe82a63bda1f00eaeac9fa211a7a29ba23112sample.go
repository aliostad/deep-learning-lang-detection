package music

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
)

type sCSample struct {
	*sCInstrument
	*Sample
}

func newSCSampleFreq(g generator, path string, freq float64, numVoices int) []*Voice {
	vs := newSCSample(g, path, numVoices)
	vs[0].instrument.(*sCSample).Sample.Frequency = freq
	return vs
}

func newSCSample(g generator, path string, numVoices int) []*Voice {
	sample := newSample(path)
	sample.sCBuffer = g.newSampleBuffer()
	instr := &sCInstrument{
		name: fmt.Sprintf("sample%d", sample.Channels),
		Path: "",
	}
	i := &sCSample{sCInstrument: instr, Sample: sample}
	return _voices(numVoices, g, i, -1)
}

type SampleLibrary interface {
	SamplePath(instrument string, params map[string]float64) string
	Channels() []int // channel variants
}

type sCSampleInstrument struct {
	SampleLibrary
	// path => *Sample
	Samples    map[string]*Sample
	instrument string
	g          generator
}

func (s *sCSampleInstrument) Name() string {
	return "samplelibrary"
}

func newSCSampleInstrument(g generator, instrument string, sampleLib SampleLibrary, numVoices int) []*Voice {
	i := &sCSampleInstrument{sampleLib, map[string]*Sample{}, instrument, g}
	return _voices(numVoices, g, i, -1)
}

func (s *sCSampleInstrument) Sample(params map[string]float64) *Sample {
	samplePath := s.SampleLibrary.SamplePath(s.instrument, params)
	sample, has := s.Samples[samplePath]
	if !has {
		sample = newSample(samplePath)
		s.Samples[samplePath] = sample
		sample.sCBuffer = s.g.newSampleBuffer()
	}
	return sample
}

type Sample struct {
	Path         string  // the path of the sample
	Offset       float64 // offset in milliseconds until max amplitude must be positiv
	MaxAmp       float64 // max amplitude value, must be between 0 and 1
	sCBuffer     int     // the sc buffer number
	Channels     uint    // number of channels
	NumFrames    int     // number of frames
	SampleRate   int     // e.g. 44100
	SampleFormat string  // e.g. int16
	Duration     float64 // duration in seconds
	HeaderFormat string  // e.g. WAV
	Frequency    float64
}

/*
	{
		"offset": 0.01124716553288,
		"maxAmp": 0.8631591796875,
		"numFrames": 64637,"sampleRate": 44100,"channels": 2,"sampleFormat": "int16","duration": 1.4656916099773,"headerFormat": "WAV"}
*/

func newSample(path string) *Sample {
	s := &Sample{Path: path}
	s.loadMeta()
	return s
}

func (s *Sample) loadMeta() {
	s.MaxAmp = 1
	s.Offset = 0
	s.Channels = 1
	metapath := s.Path + ".meta"
	data, err := ioutil.ReadFile(metapath)
	if err != nil {
		fmt.Printf("file not found: " + metapath + ", using defaults")
		return
	}

	err = json.Unmarshal(data, &s)
	if err != nil {
		panic("invalid json format for " + metapath)
	}
	s.Offset = s.Offset * 1000.0
}
