package impulse

import (
	"bytes"
	"encoding/binary"
	"errors"
	"io"
)

// NoteSample contains a note-sample pairing for use in an instrument's
// keyboard table.
type NoteSample struct {
	Note   uint8 // range 0->119 (C-0 -> B-9)
	Sample uint8 // range 0->99  (0 = no sample)
}

// NodePoint is a point in an Envelope.
type NodePoint struct {
	Value int8   // range 0->64 for volume, -32->32 for panning/pitch
	Tick  uint16 // range 0->9999
}

type rawEnvelope struct {
	Flg        byte
	Num        uint8
	LpB, LpE   uint8
	SLB, SLE   uint8
	NodePoints [25]NodePoint
	_          byte
}

type rawInstrument struct {
	MagicString     [4]byte
	DOSFilename     [12]byte
	_               byte
	NNA, DCT, DCA   byte
	FadeOut         uint16
	PPS             int8
	PPC             uint8
	GbV, DfP        uint8
	RV, RP          uint8
	TrkVers         [2]byte
	NoS             uint8
	_               byte
	Name            [26]byte
	IFC, IFR        int8
	MCh             byte
	MPr             int8
	MIDIBnk         [2]int8
	KeyboardTable   [120]NoteSample
	VolumeEnvelope  rawEnvelope
	PanningEnvelope rawEnvelope
	PitchEnvelope   rawEnvelope
}

type NewNoteAction uint8

const (
	NewNoteCut NewNoteAction = iota
	NewNoteContinue
	NewNoteOff
	NewNoteFade
)

type DuplicateCheckType uint8

const (
	DuplicateCheckOff DuplicateCheckType = iota
	DuplicateCheckNote
	DuplciateCheckSample
	DuplicateCheckInstrument
)

type DuplicateCheckAction uint8

const (
	DuplicateCheckCut DuplicateCheckAction = iota
	DuplicateCheckNoteOff
	DuplicateCheckNoteFade
)

type EnvelopeFlag uint8

const (
	EnvelopeOn EnvelopeFlag = 1 << iota
	EnvelopeLoopOn
	EnvelopeSusLoopOn
	EnvelopeUseFilter = 0x80
)

// Envelope is a volume, panning, or pitch envelope for an Instrument.
type Envelope struct {
	Flags        EnvelopeFlag
	LoopBegin    uint8
	LoopEnd      uint8
	SusLoopBegin uint8
	SusLoopEnd   uint8
	NodePoints   []NodePoint
}

// Instrument is an Impulse Tracker instrument.
type Instrument struct {
	Filename             string // max 12 bytes
	NewNoteAction        NewNoteAction
	DuplicateCheckType   DuplicateCheckType
	DuplicateCheckAction DuplicateCheckAction
	FadeOut              uint16 // range 0->256
	PitchPanSeparation   int8   // range -32->32
	PitchPanCenter       uint8  // range 0->119
	GlobalVolume         uint8  // range 0->128
	DefaultPan           uint8  // range 0->64
	DefaultPanOn         bool
	VolumeSwing          uint8 // range 0->100
	PanSwing             uint8 // range 0->64
	NumSamples           uint8
	Name                 string // max 26 bytes
	DefaultCutoff        int8   // range -1->127
	DefaultResonance     int8   // range -1->127
	MIDIChannel          byte
	MIDIProgram          int8 // range -1->127
	MIDIBankLow          int8 // range -1->127
	MIDIBankHigh         int8 // range -1->127
	KeyboardTable        [120]NoteSample
	VolumeEnvelope       *Envelope
	PanningEnvelope      *Envelope
	PitchEnvelope        *Envelope
}

func envelopeFromRaw(raw *rawEnvelope) *Envelope {
	return &Envelope{
		Flags:        EnvelopeFlag(raw.Flg),
		LoopBegin:    raw.LpB,
		LoopEnd:      raw.LpE,
		SusLoopBegin: raw.SLB,
		SusLoopEnd:   raw.SLE,
		NodePoints:   raw.NodePoints[:raw.Num],
	}
}

func instrumentFromRaw(raw *rawInstrument) *Instrument {
	return &Instrument{
		Filename:             string(bytes.Trim(raw.DOSFilename[:], "\x00")),
		NewNoteAction:        NewNoteAction(raw.NNA),
		DuplicateCheckType:   DuplicateCheckType(raw.DCT),
		DuplicateCheckAction: DuplicateCheckAction(raw.DCA),
		FadeOut:              raw.FadeOut,
		PitchPanSeparation:   raw.PPS,
		PitchPanCenter:       raw.PPC,
		GlobalVolume:         raw.GbV,
		DefaultPan:           raw.DfP & 0x7f,
		DefaultPanOn:         raw.DfP&0x80 == 0,
		VolumeSwing:          raw.RV,
		PanSwing:             raw.RP,
		NumSamples:           raw.NoS,
		Name:                 string(bytes.Trim(raw.Name[:], "\x00")),
		DefaultCutoff:        raw.IFC,
		DefaultResonance:     raw.IFR,
		MIDIChannel:          raw.MCh,
		MIDIProgram:          raw.MPr,
		MIDIBankLow:          int8(raw.MIDIBnk[0]),
		MIDIBankHigh:         int8(raw.MIDIBnk[1]),
		KeyboardTable:        raw.KeyboardTable,
		VolumeEnvelope:       envelopeFromRaw(&raw.VolumeEnvelope),
		PanningEnvelope:      envelopeFromRaw(&raw.PanningEnvelope),
		PitchEnvelope:        envelopeFromRaw(&raw.PitchEnvelope),
	}
}

// ReadInstrument reads an Instrument in ITI format from r.
func ReadInstrument(r io.Reader) (*Instrument, error) {
	raw := new(rawInstrument)
	if err := binary.Read(r, binary.LittleEndian, raw); err != nil {
		return nil, err
	}
	if string(raw.MagicString[:]) != "IMPI" {
		return nil, errors.New("data is not Impulse Tracker instrument")
	}
	return instrumentFromRaw(raw), nil
}

func envelopeToRaw(env *Envelope) rawEnvelope {
	raw := rawEnvelope{
		Flg: uint8(env.Flags),
		Num: uint8(len(env.NodePoints)),
		LpB: env.LoopBegin,
		LpE: env.LoopEnd,
		SLB: env.SusLoopBegin,
		SLE: env.SusLoopEnd,
	}
	for i := range raw.NodePoints {
		if i < len(env.NodePoints) {
			raw.NodePoints[i] = env.NodePoints[i]
		}
	}
	return raw
}

// Write writes the Instrument to w in ITI format.
func (ins *Instrument) Write(w io.Writer) error {
	raw := &rawInstrument{
		MagicString:     [4]byte{'I', 'M', 'P', 'I'},
		NNA:             byte(ins.NewNoteAction),
		DCT:             byte(ins.DuplicateCheckType),
		DCA:             byte(ins.DuplicateCheckAction),
		FadeOut:         ins.FadeOut,
		PPS:             ins.PitchPanSeparation,
		PPC:             ins.PitchPanCenter,
		GbV:             ins.GlobalVolume,
		DfP:             ins.DefaultPan,
		RV:              ins.VolumeSwing,
		RP:              ins.PanSwing,
		NoS:             ins.NumSamples,
		IFC:             ins.DefaultCutoff,
		IFR:             ins.DefaultResonance,
		MCh:             ins.MIDIChannel,
		MPr:             ins.MIDIProgram,
		MIDIBnk:         [2]int8{ins.MIDIBankLow, ins.MIDIBankHigh},
		KeyboardTable:   ins.KeyboardTable,
		VolumeEnvelope:  envelopeToRaw(ins.VolumeEnvelope),
		PanningEnvelope: envelopeToRaw(ins.PanningEnvelope),
		PitchEnvelope:   envelopeToRaw(ins.PitchEnvelope),
	}
	for i := range raw.DOSFilename {
		if i < len(ins.Filename) {
			raw.DOSFilename[i] = ins.Filename[i]
		}
	}
	if !ins.DefaultPanOn {
		raw.DfP |= 0x80
	}
	for i := range raw.Name {
		if i < len(ins.Name) {
			raw.Name[i] = ins.Name[i]
		}
	}
	return binary.Write(w, binary.LittleEndian, raw)
}
