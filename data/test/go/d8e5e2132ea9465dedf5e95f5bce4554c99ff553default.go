package music

var DefaultStage = New()

func NewTrack(bar string, tempo Tempo) *Track {
	return DefaultStage.Track(bar, tempo)
}

func NewInstrument(name string, dir string, numVoices int) []*Voice {
	return DefaultStage.Instrument(name, dir, numVoices)
}

func NewSampleInstrument(instrument string, sampleLib SampleLibrary, numVoices int) []*Voice {
	return DefaultStage.SampleInstrument(instrument, sampleLib, numVoices)
}

func NewRoute(name, dir string, numVoices int) []*Voice {
	return DefaultStage.Route(name, dir, numVoices)
}

func NewSample(path string, numVoices int) []*Voice {
	return DefaultStage.Sample(path, numVoices)
}

func NewSampleFreq(path string, freq float64, numVoices int) []*Voice {
	return DefaultStage.SampleFreq(path, freq, numVoices)
}

func NewGroup(parent int) *Voice {
	return DefaultStage.Group(parent)
}

func NewBus(name string, numchannels int) *Voice {
	return DefaultStage.Bus(name, numchannels)
}

func PlayAll(startOffset uint) {
	DefaultStage.Play(startOffset)
}
