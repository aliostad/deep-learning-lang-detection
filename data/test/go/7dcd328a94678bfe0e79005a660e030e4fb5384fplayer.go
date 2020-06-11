package game

import (
	"log"
)

type Player struct {
	name       string
	instrument Instrument
	action     string
}

func NewPlayer(name string, instrument Instrument) *Player {
	p := new(Player)
	p.name = name
	p.instrument = instrument
	return p
}

func (p *Player) Name() string {
	return p.name
}

func (p *Player) SetAction(action string) {

	log.Println("AddAction: '", action, "' received by player: ", p.name)
	p.action = action
}

func (p *Player) Action() string {
	return p.action
}

func (p *Player) PlayedAudio() (string, error) {
	return p.instrument.Play(p.action)
}
