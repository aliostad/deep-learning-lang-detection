package audio

import (
	"fmt"
	"reflect"
	"sort"
)

type Pattern struct {
	Name       string
	Notes      []*Note
	Attributes map[string][]*ControlPoint
}

type Note struct {
	Time       float64
	Attributes map[string][]*ControlPoint
}

type PatternPlayer struct {
	pattern *Pattern
	inst    Instrument
	play    reflect.Value
	i       int
	t, dt   float64
}

func NewPatternPlayer(pattern *Pattern, inst Instrument) *PatternPlayer {
	return &PatternPlayer{pattern: pattern, inst: inst, play: InstrumentPlayMethod(inst)}
}

func (p *PatternPlayer) InitAudio(params Params) {
	Init(p.inst, params)
	p.dt = 1 / params.SampleRate
	p.SetTime(p.t)
}

func (p *PatternPlayer) GetTime() float64 { return p.t }
func (p *PatternPlayer) SetTime(t float64) {
	noteType := p.play.Type().In(0)
	for _, n := range p.pattern.Notes {
		for name := range n.Attributes {
			if _, ok := noteType.FieldByName(name); !ok {
				panic(fmt.Sprintf("Pattern %s: Instrument %T has no attribute %s.", p.pattern.Name, p.inst, name))
			}
		}
		for i := 0; i < noteType.NumField(); i++ {
			name := noteType.Field(i).Name
			if _, ok := n.Attributes[name]; !ok {
				panic(fmt.Sprintf("Pattern %s: Note has no attribute %s for instrument %T.", p.pattern.Name, name, p.inst))
			}
		}
	}
	sort.Sort(notesByTime(p.pattern.Notes))
	for p.i = 0; p.i < len(p.pattern.Notes) && p.pattern.Notes[p.i].Time < t; p.i++ {
	}

	for _, c := range InstrumentControls(p.inst) {
		c.SetPoints(p.pattern.Attributes[c.Name])
		c.SetTime(t)
	}

	p.t = t
}

type notesByTime []*Note

func (n notesByTime) Len() int           { return len(n) }
func (n notesByTime) Less(i, j int) bool { return n[i].Time < n[j].Time }
func (n notesByTime) Swap(i, j int)      { n[i], n[j] = n[j], n[i] }

func (p *PatternPlayer) Play() {
	for ; p.i < len(p.pattern.Notes); p.i++ {
		n := p.pattern.Notes[p.i]
		if n.Time > p.t {
			break
		}
		note := reflect.New(p.play.Type().In(0)).Elem()
		for name, val := range n.Attributes {
			note.FieldByName(name).Set(reflect.ValueOf(val))
		}
		p.play.Call([]reflect.Value{note})
	}
	p.t += p.dt
}

func (p *PatternPlayer) Sing() float64 {
	p.Play()
	return p.inst.Sing()
}

func (p *PatternPlayer) Done() bool {
	return p.i == len(p.pattern.Notes) && p.inst.Done()
}

// For an Instrument to play notes, it must have a method Play(noteType) where noteType is a struct with exported fields of type []*ControlPoint.
// For an Instrument to be controlled, it must export fields of type audio.Control.
type Instrument interface {
	Voice
	Stop()
}

func InstrumentPlayMethod(inst Instrument) reflect.Value {
	// TODO: Play method is optional.
	m := reflect.ValueOf(inst).MethodByName("Play")
	if !m.IsValid() {
		panic(fmt.Sprintf("Type %T must have a method named Play.", inst))
	}
	if m.Type().NumIn() != 1 {
		panic(fmt.Sprintf("Method (%T).Play must have a single parameter.", inst))
	}
	n := m.Type().In(0)
	if n.Kind() != reflect.Struct {
		panic(fmt.Sprintf("The parameter to method (%T).Play must be a struct.", inst))
	}
	t := reflect.TypeOf([]*ControlPoint(nil))
	for i := 0; i < n.NumField(); i++ {
		f := n.Field(i)
		if f.Type != t || f.PkgPath != "" {
			panic(fmt.Sprintf("The parameter to method (%T).Play must only have exported fields of type %s.", inst, t))
		}
	}
	return m
}

func InstrumentControls(inst Instrument) []NamedControl {
	c := []NamedControl{}
	v := reflect.Indirect(reflect.ValueOf(inst))
	t := v.Type()
	for i := 0; i < t.NumField(); i++ {
		f := t.Field(i)
		if f.Type == reflect.TypeOf(Control{}) && f.PkgPath == "" {
			c = append(c, NamedControl{f.Name, v.Field(i).Addr().Interface().(*Control)})
		}
	}
	return c
}

type NamedControl struct {
	Name string
	*Control
}

// TODO: remove me?  no longer relevant as Play method is optional
func IsInstrument(i Instrument) (ok bool) {
	defer func() { ok = recover() == nil }()
	InstrumentPlayMethod(i)
	return
}
