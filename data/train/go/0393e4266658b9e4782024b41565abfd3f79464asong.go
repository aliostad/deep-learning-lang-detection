package drummachine

import (
	"context"
	"strconv"
	"strings"
	"time"
)

// NewSong creates a new song.
// signature must be in the form "beats/bars"
func NewSong(title string, bpm int, signature string) *Song {
	sig := strings.Split(signature, "/")
	if len(sig) != 2 {
		panic("Incorrect time signature, expected beat/bar")
	}
	beat, err := strconv.Atoi(sig[0])
	if err != nil {
		panic("Incorrect time signature, expected beat/bar")
	}
	bar, err := strconv.Atoi(sig[1])
	if err != nil {
		panic("Incorrect time signature, expected beat/bar")
	}
	return &Song{
		title: title,
		bpm:   bpm,
		beat:  beat,
		bar:   bar,
		drum:  newGrid(beat, bar),
	}
}

// AddInstrument adds a new instrument at the given steps.
func (s *Song) AddInstrument(steps []int, inst Instrument) {
	for _, step := range steps {
		s.drum.steps[step].sounds = append(s.drum.steps[step].sounds, inst)
	}
}

// Play plays a song, repeating the grid steps indefinitely.
func (s *Song) Play(ctx context.Context, out Device) {
	interval := 60 * 1000 / (s.bpm * s.bar)
	c := time.Tick(time.Duration(interval) * time.Millisecond)
	var tick int
	for {
		select {
		case <-c:
			step := s.drum.steps[tick%len(s.drum.steps)]
			playStep(step, out)
			tick++
		case <-ctx.Done():
			return
		}
	}
}

// For now the sounds are not played, but only printed.
func playStep(step step, out Device) {
	var played bool
	for _, sound := range step.sounds {
		sound.Play(out)
		played = true
	}
	if !played {
		out.Play("_")
	}
}
