package audio

import (
	"fmt"
	"reflect"
	"sort"
)

type Score struct {
	Parts []*Part
}

type Part struct {
	Name   string
	Events []*PatternEvent
}

type PatternEvent struct {
	Time    float64
	Pattern *Pattern
}

type ScorePlayer struct {
	params      Params
	score       *Score
	band        Band
	instruments map[string]Instrument
	events      []*patternEvent
	i, t        int
	players     map[*PatternPlayer]struct{}
}

func NewScorePlayer(score *Score, band Band) *ScorePlayer {
	return &ScorePlayer{params: Params{96000 /* so Get/SetTime work before InitAudio */}, score: score, band: band, instruments: BandInstruments(band)}
}

func (p *ScorePlayer) InitAudio(params Params) {
	t := p.GetTime() // handle sample rate change
	p.params = params
	Init(p.band, params)
	p.SetTime(t)
}

func (p *ScorePlayer) GetTime() float64 { return float64(p.t) / p.params.SampleRate }
func (p *ScorePlayer) SetTime(t float64) {
loop:
	for name := range p.instruments {
		for _, part := range p.score.Parts {
			if part.Name == name {
				continue loop
			}
		}
		fmt.Println("no part for instrument " + name)
	}
	p.events = nil
	for _, part := range p.score.Parts {
		inst, ok := p.instruments[part.Name]
		if !ok {
			fmt.Println("no instrument for part " + part.Name)
			continue
		}
		for _, e := range part.Events {
			p.events = append(p.events, &patternEvent{int(e.Time * p.params.SampleRate), e.Pattern, inst})
		}
	}
	sort.Sort(eventsByTime(p.events))
	p.i = 0
	p.t = int(t * p.params.SampleRate)
	p.players = map[*PatternPlayer]struct{}{}
}

type patternEvent struct {
	time    int
	pattern *Pattern
	inst    Instrument
}

type eventsByTime []*patternEvent

func (e eventsByTime) Len() int           { return len(e) }
func (e eventsByTime) Less(i, j int) bool { return e[i].time < e[j].time }
func (e eventsByTime) Swap(i, j int)      { e[i], e[j] = e[j], e[i] }

func (p *ScorePlayer) Play() {
	for ; p.i < len(p.events); p.i++ {
		e := p.events[p.i]
		if p.t < e.time {
			break
		}
		player := NewPatternPlayer(e.pattern, e.inst)
		player.InitAudio(p.params)
		player.SetTime(float64(p.t-e.time) / p.params.SampleRate)
		p.players[player] = struct{}{}
	}
	for player := range p.players {
		player.Play()
		if player.Done() {
			delete(p.players, player)
		}
	}
	p.t++
}

func (p *ScorePlayer) Sing() float64 {
	p.Play()
	return p.band.Sing()
}

func (p *ScorePlayer) Done() bool {
	return p.i == len(p.events) && len(p.players) == 0 && p.band.Done()
}

// A Band must be a struct with exported fields of type Instrument.
type Band interface {
	Voice
}

func BandInstruments(b Band) map[string]Instrument {
	insts := map[string]Instrument{}
	v := reflect.Indirect(reflect.ValueOf(b))
	t := v.Type()
	if t.Kind() != reflect.Struct {
		panic(fmt.Sprintf("%T must be a struct.", b))
	}
	for i := 0; i < v.NumField(); i++ {
		f := v.Field(i)
		sf := t.Field(i)
		if f.CanAddr() && sf.Type.Kind() != reflect.Ptr && sf.Type.Kind() != reflect.Interface {
			f = f.Addr()
		}
		if !f.CanInterface() || sf.Tag.Get("audio") == "noscore" {
			continue
		}
		i, ok := f.Interface().(Instrument)
		if !ok || !IsInstrument(i) {
			panic(fmt.Sprintf("(%T).%s is not an Instrument nor is it tagged with `audio:\"noscore\"`.", b, sf.Name))
			continue
		}
		insts[sf.Name] = i
	}
	return insts
}
