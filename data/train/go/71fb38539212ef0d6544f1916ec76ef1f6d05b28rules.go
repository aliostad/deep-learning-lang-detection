package pansi

type State int

const (
	Ground State = iota
	OscString
	SosPmApcString

	Escape
	EscapeIntermediate

	CsiEntry
	CsiIgnore
	CsiParam
	CsiIntermediate

	DcsEntry
	DcsParam
	DcsIgnore
	DcsPassthrough
	DcsIntermediate
)

type Rule struct {
	Start, End byte
	Transition Transition
	State      State
}

var globalRules = map[byte]Rule{
	0x1B: Rule{0, 0, clear, Escape},
}

var states = map[State][]Rule{
	Ground: []Rule{},
	Escape: []Rule{
		Rule{0x20, 0x2F, collect, EscapeIntermediate},
		Rule{0x5B, 0x5B, noTransition, CsiEntry},
		Rule{0x30, 0x4F, escDispatch, Ground},
		Rule{0x52, 0x57, escDispatch, Ground},
		Rule{0x59, 0x59, escDispatch, Ground},
		Rule{0x5A, 0x5A, escDispatch, Ground},
		Rule{0x5C, 0x5C, escDispatch, Ground},
		Rule{0x60, 0x7E, escDispatch, Ground},
		Rule{0x50, 0x50, noTransition, DcsEntry},
		Rule{0x5D, 0x5D, noTransition, OscString},
		Rule{0x58, 0x58, noTransition, SosPmApcString},
		Rule{0x5E, 0x5F, noTransition, SosPmApcString},
		Rule{0x58, 0x58, noTransition, SosPmApcString},
	},
	EscapeIntermediate: []Rule{
		Rule{0x30, 0x7E, escDispatch, Ground},
	},
	DcsEntry: []Rule{
		Rule{0x20, 0x2F, collect, DcsIntermediate},
		Rule{0x3A, 0x3A, noTransition, DcsIgnore},
		Rule{0x30, 0x39, param, DcsParam},
		Rule{0x3B, 0x3B, param, DcsParam},
		Rule{0x3C, 0x3F, collect, DcsParam},
		Rule{0x40, 0x7E, noTransition, DcsPassthrough},
	},
	DcsIntermediate: []Rule{
		Rule{0x30, 0x3F, noTransition, DcsIgnore},
	},
	CsiEntry: []Rule{
		Rule{0x3A, 0x3A, noTransition, CsiIgnore},
		Rule{0x20, 0x2F, collect, CsiIntermediate},
		Rule{0x3B, 0x3B, param, CsiParam},
		Rule{0x30, 0x39, param, CsiParam},
		Rule{0x3C, 0x3F, collect, CsiParam},
		Rule{0x40, 0x7E, csiDispatch, Ground},
	},
	CsiParam: []Rule{
		Rule{0x20, 0x2F, noTransition, CsiIntermediate},
		Rule{0x3B, 0x3B, param, CsiParam},
		Rule{0x30, 0x39, param, CsiParam},
		Rule{0x3A, 0x3A, noTransition, CsiIgnore},
		Rule{0x40, 0x7E, csiDispatch, Ground},
	},
}
