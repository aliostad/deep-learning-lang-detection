package main

import (
	"fmt"
	"github.com/mkb218/gosndfile/sndfile"
	"github.com/rubyist/drum"
	"path/filepath"
	"time"
)

// Sequencer takes a sequence of Pattern objects and provides
// audio data necessary to play the patterns. Sequencer loops
// the patterns in order until Stop() is called.
type Sequencer struct {
	Step        int
	Running     bool
	patterns    []*drum.Pattern
	instruments map[int32]*instrument
	pattern     int
	ticker      *time.Ticker
	stop        chan int
}

// NewSequencer creates a new Sequencer object.
func NewSequencer() *Sequencer {
	return &Sequencer{
		Running:     false,
		instruments: make(map[int32]*instrument),
		stop:        make(chan int, 1),
	}
}

// Add adds a Pattern to the sequence
func (s *Sequencer) Add(p *drum.Pattern) error {
	s.patterns = append(s.patterns, p)
	for _, track := range p.Tracks {
		if _, ok := s.instruments[track.ID]; !ok {
			instrument, err := newInstrument(track)
			if err != nil {
				return err
			}
			s.instruments[track.ID] = instrument
		}
	}
	return nil
}

// Read fills a data buffer with audio data
func (s *Sequencer) Read(data []int32) {
	// We should probably buffer a couple ticks worth of data
	sum := int32(0)
	scale := int32(len(s.patterns[s.pattern].Tracks))

	for i := 0; i < len(data); i++ {
		sum = 0
		for _, instrument := range s.instruments {
			sum += instrument.Read() / scale
		}
		data[i] = sum
	}
}

// Start starts the sequencer. Once the sequencer starts, audio
// data will be available via Read.
func (s *Sequencer) Start() {
	period := time.Millisecond * time.Duration(((1.0/(s.patterns[s.pattern].Tempo/60.0))/4.0)*1000.0)
	go func() {
		timer := time.NewTicker(period)
		for {
			select {
			case <-timer.C:
				s.tick()
			case <-s.stop:
				timer.Stop()
				return
			}
		}
	}()
	s.Running = true
}

// Stop stops the sequencer from running.
func (s *Sequencer) Stop() {
	s.stop <- 1
	s.Running = false
}

func (s *Sequencer) Reset() {
	if s.Running {
		s.Stop()
	}
	s.Step = 0
	s.pattern = 0
}

func (s *Sequencer) tick() {
	p := s.patterns[s.pattern]
	for i := 0; i < len(p.Tracks); i++ {
		track := p.Tracks[i]
		if track.Steps[s.Step] {
			s.instruments[track.ID].Hit()
		}
	}
	s.Step++
	if s.Step == 16 {
		s.pattern++
		s.pattern %= len(s.patterns)
		s.Stop()
		s.Start()
	}

	s.Step %= 16
}

type instrument struct {
	sample []int32
	cursor int
}

func newInstrument(t *drum.Track) (*instrument, error) {
	fileName := filepath.Join("sounds", fmt.Sprintf("%s.wav", t.Name))
	var info sndfile.Info
	f, err := sndfile.Open(fileName, sndfile.Read, &info)
	if err != nil {
		return nil, err
	}
	defer f.Close()

	buffer := make([]int32, int(info.Frames)*int(info.Channels))
	_, err = f.ReadFrames(buffer)
	if err != nil {
		return nil, err
	}

	return &instrument{
		sample: buffer,
		cursor: len(buffer),
	}, nil
}

func (i *instrument) Read() int32 {
	value := int32(0)
	if i.cursor < len(i.sample) {
		value = i.sample[i.cursor]
		i.cursor++
	}
	return value
}

func (i *instrument) Hit() {
	i.cursor = 0
}
