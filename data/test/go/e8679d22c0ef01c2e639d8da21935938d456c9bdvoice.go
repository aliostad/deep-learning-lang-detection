package supergollider

// Voice can only play one sound at a time

import (
	"bytes"
	"fmt"
	"strconv"
	"strings"
)

type ParamsModifier interface {
	Modify(Parameter) Parameter
}

type ParamsModifierFunc func(Parameter) Parameter

func (p ParamsModifierFunc) Modify(param Parameter) Parameter {
	return p(param)
}

type Voice struct {
	generator
	instrument instrument
	scnode     int // the node id of the voice
	Group      int
	Bus        int
	mute       bool
	offset     float64
	// lastSampleFrequency float64 // frequency of the last played sample
	ParamsModifier ParamsModifier
	lastEvent      *Event
}

type playDur struct {
	pos Measure
	dur Measure
	*Voice
	Params Parameter
}

func (p *playDur) Events(barNum int, t Tracker) map[Measure][]*Event {
	m := map[Measure][]*Event{}
	m[p.pos] = []*Event{
		OnEvent(p.Voice, p.Params),
	}
	m[p.pos+p.dur] = []*Event{OffEvent(p.Voice)}
	return m
}

func (p *playDur) NumBars() int {
	return 1
}

func (v *Voice) PlayDur(pos, dur string, params ...Parameter) Pattern {
	return &playDur{M(pos), M(dur), v, MixParams(params...)}
}

type play struct {
	pos Measure
	*Voice
	Params Parameter
}

func (v *Voice) Sequencer(s Sequencer) Pattern {
	return &sequencer{
		seq: s,
		v:   v,
	}
}

func (v *Voice) SetOffset(o float64) {
	v.offset = o
}

func (p *play) Events(barNum int, t Tracker) map[Measure][]*Event {
	m := map[Measure][]*Event{}
	m[p.pos] = []*Event{
		OnEvent(p.Voice, p.Params),
	}
	return m
}

func (p *play) NumBars() int {
	return 1
}

/*
func (p *play) Pattern(t Tracker) {
	t.At(p.pos, OnEvent(p.Voice, p.Params))
}
*/

func (v *Voice) Phrase(pos string) *phrase {
	return newPhrase(v, pos)
}

func (v *Voice) Rhythm(start string, positions ...string) *rhythm {
	if len(positions) < 1 {
		panic("number of positions must be 1 at least")
	}
	return newRhythm(v, start, positions...)
}

func (v *Voice) Play(pos string, params ...Parameter) Pattern {
	return &play{M(pos), v, MixParams(params...)}
}

type exec_ struct {
	pos Measure
	// fn    func(t Tracker) (EventGenerator, Parameter)
	//fn      PatternFunc
	fn    func() *Event
	voice *Voice
	// numbars int
}

/*
func EventFuncPattern(pos string, fn func(e *Event)) Pattern {
	return PatternFunc(func(barNum int, t Tracker) map[Measure][]*Event {
		return map[Measure][]*Event{M(pos): []*Event{CustomEvent(fn)}}
	})
}
*/
func (e *exec_) Events(barNum int, t Tracker) map[Measure][]*Event {
	// fmt.Println("call func")
	ev := e.fn()
	ev.Voice = e.voice
	// fmt.Printf("setting ev %p voice %p\n", ev, ev.Voice)
	return map[Measure][]*Event{e.pos: []*Event{ev}}
}

/*
func (e *exec_) Events(barNum int, t Tracker) map[Measure][]*Event {
	m := e.fn(barNum, t)
	for _, events := range m {
		for _, ev := range events {
			ev.Voice = e.voice
		}
	}
	return m
}
*/

func (e *exec_) NumBars() int {
	// return e.numbars
	return 1
}

/*
func (e *exec_) Pattern(t Tracker) {
	evGen, param := e.fn(t)

	//ev := newEvent(e.voice, "CUSTOM")
	// ev.Runner = e.fn
	t.At(e.pos, evGen(e.voice, param))
}

func (v *Voice) Exec(pos string, fn func(t Tracker) (EventGenerator, Parameter)) Pattern {
	return &exec_{M(pos), fn, v}
}
*/

//func (v *Voice) Exec(numBars int, pos string, fn PatternFunc) Pattern {
//func (v *Voice) Exec(numBars int, pos string, fn PatternFunc) Pattern {
func (v *Voice) Exec(pos string, fn func() *Event) Pattern {
	return &exec_{M(pos), fn, v}
}

type stop struct {
	pos Measure
	*Voice
}

func (p *stop) Events(barNum int, t Tracker) map[Measure][]*Event {
	m := map[Measure][]*Event{}
	m[p.pos] = []*Event{
		OffEvent(p.Voice),
	}
	return m
}

func (p *stop) NumBars() int {
	return 1
}

/*
func (p *stop) Pattern(t Tracker) {
	t.At(p.pos, OffEvent(p.Voice))
}
*/

func (v *Voice) Stop(pos string) Pattern {
	return &stop{M(pos), v}
}

type mod struct {
	pos Measure
	*Voice
	Params Parameter
}

func (m *mod) Events(barNum int, t Tracker) map[Measure][]*Event {
	return map[Measure][]*Event{
		m.pos: []*Event{
			ChangeEvent(m.Voice, m.Params),
		},
	}
}

func (m *mod) NumBars() int {
	return 1
}

/*
func (p *mod) Pattern(t Tracker) {
	t.At(p.pos, ChangeEvent(p.Voice, p.Params))
}
*/

type mute struct {
	v    *Voice
	pos  Measure
	mute bool
}

func (m *mute) NumBars() int {
	return 1
}

func (m *mute) Events(barNum int, t Tracker) map[Measure][]*Event {
	if m.mute {
		return map[Measure][]*Event{
			m.pos: []*Event{
				MuteEvent(m.v),
			},
		}
	}
	return map[Measure][]*Event{
		m.pos: []*Event{
			UnMuteEvent(m.v),
		},
	}
	// t.At(m.pos, UnMuteEvent(m.v))
}

/*
func (m *mute) Pattern(t Tracker) {
	if m.mute {
		t.At(m.pos, MuteEvent(m.v))
		return
	}
	t.At(m.pos, UnMuteEvent(m.v))
}
*/

func (v *Voice) Mute(pos string) Pattern {
	return &mute{v, M(pos), true}
}

func (v *Voice) UnMute(pos string) Pattern {
	return &mute{v, M(pos), false}
}

func (v *Voice) Modify(pos string, params ...Parameter) Pattern {
	return &mod{M(pos), v, MixParams(params...)}
}

func (v *Voice) Metronome(unit Measure, parameter ...Parameter) *metronome {
	m := &metronome{voice: v, unit: unit, eventProps: MixParams(parameter...)}
	// t.SetLoop("metronome", m)
	return m
}

func (v *Voice) Bar(parameter ...Parameter) Pattern {
	return &bar{voice: v, eventProps: MixParams(parameter...)}
}

type metronome struct {
	last       Measure
	voice      *Voice
	unit       Measure
	eventProps Parameter
	// t          *Track
}

// TODO maybe make it more intelligent about barMeasure
func (m *metronome) Events(barNum int, t Tracker) (res map[Measure][]*Event) {
	res = map[Measure][]*Event{}
	//n := int(m.t.CurrentBar() / m.unit)
	n := int(t.CurrentBar() / m.unit)
	half := m.unit / 2
	for i := 0; i < n; i++ {
		pos1 := m.unit * Measure(i)
		res[pos1] = append(res[pos1], OnEvent(m.voice, m.eventProps))
		pos2 := m.unit*Measure(i) + half
		res[pos2] = append(res[pos2], OffEvent(m.voice))
		// t.At(m.unit*Measure(i), OnEvent(m.voice, m.eventProps))
		// t.At(m.unit*Measure(i)+half, OffEvent(m.voice))
	}
	return res
}

// NumBars() returns 1 because it repeats every bar
func (m *metronome) NumBars() int {
	return 1
}

// Tracker must be a *Track
/*
func (m *metronome) Pattern(t Tracker) {
	n := int(t.(*Track).CurrentBar() / m.unit)
	half := m.unit / 2
	for i := 0; i < n; i++ {
		t.At(m.unit*Measure(i), OnEvent(m.voice, m.eventProps))
		t.At(m.unit*Measure(i)+half, OffEvent(m.voice))
	}
}
*/

type bar struct {
	voice *Voice
	// counter    float64
	eventProps Parameter
}

func (b *bar) NumBars() int {
	return 1
}

// TODO: make it more intelligent with respect to measure
func (m *bar) Events(barNum int, t Tracker) (res map[Measure][]*Event) {
	return map[Measure][]*Event{
		M("0"): []*Event{
			OnEvent(m.voice, m.eventProps),
		},
		M("1/8"): []*Event{
			OffEvent(m.voice),
		},
	}
}

/*
func (m *bar) Pattern(t Tracker) {
	t.At(M("0"), OnEvent(m.voice, m.eventProps))
	t.At(M("1/8"), OffEvent(m.voice))
	m.counter++
}
*/

func (v *Voice) paramsStr(params map[string]float64) string {
	var buf bytes.Buffer

	for k, v := range params {
		if k[0] != '_' {
			fmt.Fprintf(&buf, `, \%s, %s`, k, strconv.FormatFloat(v, 'f', -1, 32)) //  float32(v))
		}
	}

	return buf.String()
}

func (v *Voice) donothing(ev *Event) {}

/*
func (v *Voice) setMute(ev *Event) {
	v.mute = true
	v.OffEvent(ev)
}

func (v *Voice) unsetMute(*Event) {
	v.mute = false
}
*/

func ratedOffset(sampleOffset float64, params map[string]float64) float64 {
	rate, hasRate := params["rate"]
	if !hasRate || rate == 1 {
		return sampleOffset * (-1)
	}
	return (-1) * sampleOffset / rate
}

func (v *Voice) ptr() string {
	return fmt.Sprintf("%p", v)[6:]
}

// getCode is executed after the events have been sorted, respecting their offset
func (v *Voice) getCode(ev *Event) string {
	//fmt.Println(ev.Type)
	res := ""
	switch ev.type_ {
	case "FREE":
		// [\n_set, 2002, \gate, -0.0000001]
		// return fmt.Sprintf(`, [\n_free, %d]`, ev.reference.synthID)
		return fmt.Sprintf(`, [\n_set, %d, \gate, -0.0000001]`, ev.reference.synthID)
	case "CUSTOM":
		// fmt.Println("running custom event")
		//ev.Runner(ev)
		return ev.sccode.String()
	case "MUTE":
		// println("muted")
		// fmt.Printf("muting %s\n", v.ptr())
		v.mute = true
	case "UNMUTE":
		// println("unmuted")
		v.mute = false
	case "ON":
		var bf bytes.Buffer
		/*
			oldNode := v.scnode
			_, isSample := v.instrument.(*sCSample)
			_, isSampleInstrument := v.instrument.(*sCSampleInstrument)

			if oldNode != 0 && oldNode > 2000 {
				if isSample || isSampleInstrument {
					// is freed automatically
					fmt.Fprintf(&bf, `, [\n_set, %d, \gate, -1]`, oldNode)
				} else {
					// fmt.Fprintf(&bf, `, [\n_free, %d]`, oldNode)
				}
				// if oldNode != 0 {
				// fmt.Fprintf(&bf, `, [\n_free, %d]`, oldNode)
			}
		*/

		/*
			if isSample || isSampleInstrument {
				v.lastSampleFrequency = ev.sampleInstrumentFrequency
			}
		*/

		if v.mute {
			// println("muted (On)")
			v.scnode = 0
			ev.synthID = 0
			return bf.String()
		}
		// fmt.Printf("ON %s\n", v.ptr())

		v.scnode = v.newNodeId()
		ev.synthID = v.scnode
		//s := strings.Replace(ev.sccode.String(), "##OLD_NODE##", fmt.Sprintf("%d", v.scnode), -1)
		bf.WriteString(strings.Replace(ev.sccode.String(), "##NODE##", fmt.Sprintf("%d", v.scnode), -1))
		//bf.WriteString(ev.sccode.String())
		res = bf.String()
		//fmt.Sprintf(ev.sccode.String(), ...)
	case "OFF":
		// v.lastSampleFrequency = 0

		if ev.reference == nil || ev.reference.synthID == 0 {
			return ""
		}

		/*
			if v.scnode == 0 {
				return ""
			}
			res = strings.Replace(ev.sccode.String(), "##NODE##", fmt.Sprintf("%d", v.scnode), -1)
		*/
		res = strings.Replace(ev.sccode.String(), "##NODE##", fmt.Sprintf("%d", ev.reference.synthID), -1)
		//res = ev.sccode.String()
	case "CHANGE":
		if _, isBus := v.instrument.(*bus); isBus {
			return ev.sccode.String()
		}

		if _, isGroup := v.instrument.(group); isGroup {
			return ev.sccode.String()
		}

		/*
			if v.scnode == 0 || v.mute {
				return ""
			}
		*/
		if ev.reference == nil {
			return ""
			// fmt.Printf("change event without reference: %v\n", ev.Params.Params())
		}

		if ev.reference.synthID == 0 || v.mute {
			return ""
		}

		isSample := false

		if _, ok := v.instrument.(*sCSample); ok {
			isSample = true
		}

		if _, ok := v.instrument.(*sCSampleInstrument); ok {
			isSample = true
		}
		_ = isSample

		if isSample {
			if ev.reference.sampleInstrumentFrequency != 0 && ev.changedParamsPrepared["freq"] != 0 && ev.reference.sampleInstrumentFrequency != ev.changedParamsPrepared["freq"] {
				if _, isSet := ev.changedParamsPrepared["rate"]; !isSet {
					ev.changedParamsPrepared["rate"] = ev.changedParamsPrepared["freq"] / ev.reference.sampleInstrumentFrequency
				}
			}
		}

		var res bytes.Buffer

		//res.WriteString(strings.Replace(ev.sccode.String(), "##NODE##", fmt.Sprintf("%d", v.scnode), -1))
		res.WriteString(strings.Replace(ev.sccode.String(), "##NODE##", fmt.Sprintf("%d", ev.reference.synthID), -1))

		//fmt.Fprintf(&ev.sccode, `, [\n_set, %d%s]`, v.scnode, v.paramsStr(params))
		//fmt.Fprintf(&res, `, [\n_set, %d%s]`, v.scnode, v.paramsStr(ev.changedParamsPrepared))
		fmt.Fprintf(&res, `, [\n_set, %d%s]`, ev.reference.synthID, v.paramsStr(ev.changedParamsPrepared))

		return res.String()

		//res = ev.sccode.String()
	}

	// fmt.Printf("%s %p %s %s\n", v.instrument.Name(), v, ev.Type, res)
	return res
}

func (v *Voice) OnEvent(ev *Event) {
	// fmt.Printf("OnEvent for event %p voice %p (self: %p)\n", ev, ev.Voice, v)
	if v == nil && ev.Voice != nil {
		v = ev.Voice
	}

	if _, isBus := v.instrument.(*bus); isBus {
		panic("On not supported for busses")
	}

	if _, isGroup := v.instrument.(group); isGroup {
		panic("On not supported for groups")
	}

	/*
		if v.mute {
			return
		}
	*/

	if cl, ok := v.instrument.(codeLoader); ok {
		cl.Use()
	}

	v.lastEvent = ev

	params := ev.Params.Params()

	if v.ParamsModifier != nil {
		params = v.ParamsModifier.Modify(ParamsMap(params)).Params()
	}

	groupParam, hasGroupParam := params["group"]

	if hasGroupParam {
		v.Group = int(groupParam)
		delete(params, "group")
	}

	group := 1010

	if v.Group != 0 {
		group = v.Group
	}

	offsetParam, hasOffsetParam := params["offset"]

	if hasOffsetParam {
		delete(params, "offset")
	}

	/*
		oldNode := v.scnode
		_ = oldNode
		v.scnode = v.newNodeId()
	*/

	//if oldNode != 0 && oldNode > 2000 {
	// fmt.Fprintf(&ev.SCCode, `, [\n_set, %d, \gate, -1]`, oldNode)
	//fmt.Fprintf(&ev.sccode, `, [\n_free, %d]`, oldNode)
	//}

	//fmt.Fprintf(&ev.sccode, `, [\n_free, %d]`, oldNode)

	switch i := v.instrument.(type) {
	case *sCInstrument:
		// ev.offset = i.Offset + offsetParam
		ev.offset = v.offset + offsetParam
	case *sCSample:
		if i.Sample.Frequency != 0 && params["freq"] != 0 && i.Sample.Frequency != params["freq"] {
			if _, isSet := params["rate"]; !isSet {
				params["rate"] = params["freq"] / i.Sample.Frequency
			}
		}
		bufnum := i.Sample.sCBuffer
		ev.sampleInstrumentFrequency = i.Sample.Frequency
		fmt.Fprintf(
			&ev.sccode,
			//`, [\s_new, \%s, %d, 0, 0, \bufnum, %d%s]`,
			`, [\s_new, \%s, ##NODE##, 0, 0, \bufnum, %d%s]`,
			v.instrument.Name(),
			// v.scnode,
			bufnum,
			v.paramsStr(params),
		)
		ev.offset = v.offset + ratedOffset(i.Sample.Offset, params) + offsetParam
		return

	case *sCSampleInstrument:
		sample := i.Sample(params)
		if sampleFreq, hasSampleFreq := params["samplefreq"]; hasSampleFreq {
			sample.Frequency = sampleFreq
			delete(params, "samplefreq")
		}

		bufnum := sample.sCBuffer
		ev.sampleInstrumentFrequency = sample.Frequency
		// v.lastInstrumentSample = sample
		fmt.Fprintf(
			&ev.sccode,
			//`, [\s_new, \%s, %d, 0, 0, \bufnum, %d%s]`,
			`, [\s_new, \%s, ##NODE##, 0, 0, \bufnum, %d%s]`,
			fmt.Sprintf("sample%d", sample.Channels),
			// v.scnode,
			bufnum,
			v.paramsStr(params),
		)

		ev.offset = v.offset + ratedOffset(sample.Offset, params) + offsetParam
		return
	}

	// fmt.Fprintf(&ev.sccode, `, [\s_new, \%s, %d, 1, %d%s]`, v.instrument.Name(), v.scnode, group, v.paramsStr(params))
	fmt.Fprintf(&ev.sccode, `, [\s_new, \%s, ##NODE##, 1, %d%s]`, v.instrument.Name(), group, v.paramsStr(params))

}

func (v *Voice) ChangeEvent(ev *Event) {
	if v == nil && ev.Voice != nil {
		v = ev.Voice
	}

	params := ev.Params.Params()

	groupParam, hasGroupParam := params["group"]

	if hasGroupParam {
		v.Group = int(groupParam)
		delete(params, "group")
	}

	offsetParam, hasOffsetParam := params["offset"]

	if hasOffsetParam {
		delete(params, "offset")
	}

	// only respect offset per parameter in change events
	ev.offset = v.offset + offsetParam

	ev.reference = v.lastEvent

	if _, isBus := v.instrument.(*bus); isBus {
		for name, val := range params {
			busno, has := busses[name]

			if !has {
				panic("unknown bus " + name)
			}
			fmt.Fprintf(&ev.sccode, `, [\c_set, \%d, %v]`, busno, val)
		}
		return
	}

	if _, isGroup := v.instrument.(group); isGroup {
		fmt.Fprintf(&ev.sccode, `, [\n_set, %d%s]`, v.Group, v.paramsStr(params))
		return
	}

	for k, val := range params {
		if k[0] == '_' {
			idx := strings.Index(k, "-")

			if idx == -1 {
				panic("invalid special parameter must be '_map-[key] or _mapa-[key]")
			}

			pre := k[:idx]
			param := k[idx+1:]

			switch pre {
			case "_map":
				//fmt.Fprintf(&ev.sccode, `, [\n_map, %d, \%s, %d]`, v.scnode, param, int(val))
				fmt.Fprintf(&ev.sccode, `, [\n_map, ##NODE##, \%s, %d]`, param, int(val))
			case "_mapa":
				//fmt.Fprintf(&ev.sccode, `, [\n_mapa, %d, \%s, %d]`, v.scnode, param, int(val))
				fmt.Fprintf(&ev.sccode, `, [\n_mapa, ##NODE##, \%s, %d]`, param, int(val))
			default:
				panic("unknown special parameter must be '_map-[key] or _mapa-[key]")
			}
			delete(params, k)
		}
	}

	ev.changedParamsPrepared = params

	/*
		if i, ok := v.instrument.(*sCSample); ok {
			if i.Sample.Frequency != 0 && params["freq"] != 0 && i.Sample.Frequency != params["freq"] {
				if _, isSet := params["rate"]; !isSet {
					params["rate"] = params["freq"] / i.Sample.Frequency
				}
			}
		}

		if _, ok := v.instrument.(*sCSampleInstrument); ok {
			if v.lastInstrumentSample != nil && v.lastInstrumentSample.Frequency != 0 && params["freq"] != 0 && v.lastInstrumentSample.Frequency != params["freq"] {
				if _, isSet := params["rate"]; !isSet {
					params["rate"] = params["freq"] / v.lastInstrumentSample.Frequency
				}
			}
		}

		//fmt.Fprintf(&ev.sccode, `, [\n_set, %d%s]`, v.scnode, v.paramsStr(params))
		fmt.Fprintf(&ev.sccode, `, [\n_set, ##NODE##%s]`, v.paramsStr(params))
	*/
}

func (v *Voice) OffEvent(ev *Event) {
	if v == nil && ev.Voice != nil {
		v = ev.Voice
	}

	if _, isBus := v.instrument.(*bus); isBus {
		panic("Off not supported for busses")
	}

	if _, isGroup := v.instrument.(group); isGroup {
		panic("Off not supported for groups")
	}

	ev.reference = v.lastEvent
	ev.offset = v.offset

	// v.lastInstrumentSample = nil
	//fmt.Fprintf(&ev.sccode, `, [\n_set, %d, \gate, -1]`, v.scnode)
	//fmt.Fprintf(&ev.sccode, `, [\n_set, ##NODE##, \gate, -1]`)
	fmt.Fprintf(&ev.sccode, `, [\n_set, ##NODE##, \gate, -0.0000001]`)
}

type codeLoader interface {
	IsUsed() bool
	Use()
}

type voices []*Voice

// v may be []*Voice or *Voice
func Voices(v ...interface{}) voices {
	vs := []*Voice{}

	for _, x := range v {
		switch t := x.(type) {
		case *Voice:
			vs = append(vs, t)
		case []*Voice:
			vs = append(vs, t...)
		default:
			panic(fmt.Sprintf("unsupported type %T, supported are *Voice and []*Voice", x))
		}
	}

	return voices(vs)
}

func (vs voices) Exec(pos string, fn func() *Event) Pattern {
	ps := []Pattern{}
	for _, v := range vs {
		ps = append(ps, v.Exec(pos, fn))
	}
	return MixPatterns(ps...)
}

func (vs voices) Modify(pos string, params ...Parameter) Pattern {
	ps := []Pattern{}
	for _, v := range vs {
		ps = append(ps, v.Modify(pos, params...))
	}
	return MixPatterns(ps...)
}

func (vs voices) PlayDur(pos, dur string, params ...Parameter) Pattern {
	ps := []Pattern{}
	for _, v := range vs {
		ps = append(ps, v.PlayDur(pos, dur, params...))
	}
	return MixPatterns(ps...)
}

func (vs voices) Stop(pos string) Pattern {
	ps := []Pattern{}
	for _, v := range vs {
		ps = append(ps, v.Stop(pos))
	}
	return MixPatterns(ps...)
}

func (vs voices) Play(pos string, params ...Parameter) Pattern {
	ps := []Pattern{}
	for _, v := range vs {
		ps = append(ps, v.Play(pos, params...))
	}
	return MixPatterns(ps...)
}

func (vs voices) Mute(pos string) Pattern {
	ps := []Pattern{}
	for _, v := range vs {
		ps = append(ps, v.Mute(pos))
	}
	return MixPatterns(ps...)
}

func (vs voices) SetOffset(o float64) {
	for _, v := range vs {
		v.SetOffset(o)
	}
}

func (vs voices) UnMute(pos string) Pattern {
	ps := []Pattern{}
	for _, v := range vs {
		ps = append(ps, v.UnMute(pos))
	}
	return MixPatterns(ps...)
}

func (vs voices) SetBus(bus int) {
	if bus < 1 {
		panic("bus number must be > 0")
	}
	for _, v := range vs {
		v.Bus = bus
	}
}

func (vs voices) SetGroup(group int) {
	for _, v := range vs {
		v.Group = group
	}
}

func (vs voices) SetParamsModifier(m ParamsModifier) {
	for _, v := range vs {
		v.ParamsModifier = m
	}
}

/*
MultiSet(Random(20), Offset(15), Random(1.4), Amp(1.5))
*/
