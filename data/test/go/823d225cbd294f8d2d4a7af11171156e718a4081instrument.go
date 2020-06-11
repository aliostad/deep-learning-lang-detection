package game

import (
	"errors"
)

type InstrumentType string

const (
	UKULELE InstrumentType = "1"
	DRUMS   InstrumentType = "2"

	DEFAULT_INSTRUMENT = UKULELE
)

type Instrument interface {
	// Returns audio file name
	Play(command string) (string, error)
	Name() string
	Type() InstrumentType
}

type Ukulele struct {
}

func (u *Ukulele) Play(command string) (string, error) {
	switch command {
	case "1":
		return "ukulele_g.mp3", nil
	case "2":
		return "ukulele_c.mp3", nil
	case "3":
		return "ukulele_d.mp3", nil
	case "4":
		return "ukulele_a.mp3", nil
	}
	return "", errors.New("Unknown ukulele command")
}

func (u *Ukulele) Name() string {
	return "ukulele"
}

func (u *Ukulele) Type() InstrumentType {
	return UKULELE
}

type Drums struct {
}

func (d *Drums) Play(command string) (string, error) {
	switch command {
	case "1":
		return "hihat.wav", nil
	case "2":
		return "kick.wav", nil
	case "3":
		return "snare.wav", nil
	case "4":
		return "crash.wav", nil
	}
	return "", errors.New("Unknown drums command")
}

func (d *Drums) Name() string {
	return "drums"
}

func (d *Drums) Type() InstrumentType {
	return DRUMS
}

// Factory for create instrument
func CreateInstrument(t InstrumentType) Instrument {
	switch t {
	case UKULELE:
		return &Ukulele{}
	case DRUMS:
		return &Drums{}
	}

	return &Ukulele{}
}

func AvailableInstruments() map[InstrumentType]string {
	return map[InstrumentType]string{
		UKULELE: "Укулеле",
		DRUMS:   "Барабаны",
	}
}
