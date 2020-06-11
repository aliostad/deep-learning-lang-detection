package drummachine

import (
	"fmt"
	"io"
)

// Device is a sound device that is able to play a sound
type Device interface {
	Play(interface{})
}

// StdDevice is a device using a standard io.Writer
// as its output. The device can use any implementation of io.Writer.
type StdDevice struct {
	Out io.Writer
}

// Play plays a sound on the device.
func (out *StdDevice) Play(sound interface{}) {
	fmt.Fprint(out.Out, sound)
}

// Song represents a song
type Song struct {
	title string
	bpm   int
	beat  int // number of beats per measure
	bar   int // number of bars per beat
	drum  grid
}

// grid represents the grid of a song, as a slice of steps.
type grid struct {
	steps []step
}

// A step is a group of sounds.
type step struct {
	sounds []Instrument
}

// Instrument is an object that can play a sound to an output.
type Instrument interface {
	Play(Device)
}

// DrumSound is an Instrument that can play a drum sound.
type DrumSound struct {
	name  string
	sound string
}
