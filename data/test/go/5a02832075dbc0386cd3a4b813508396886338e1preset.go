package main

import (
	"bytes"
	"encoding/gob"
	"github.com/boltdb/bolt"
)

type Preset struct {
	Settings
	Grids map[string]GridDef
}

type Settings struct {
	MasterVolume int
	Duration     int
	Instruments  []ActiveInstrument
}

type Instrument struct {
	ID    int
	Name  string
	Tuned bool
}

type ActiveInstrument struct {
	Instrument
	Velocity int
}

func DefaultPreset() Preset {
	preset := Preset{Settings: Settings{Duration: 50, MasterVolume: 100}}
	preset.Instruments = []ActiveInstrument{
		{instruments[0], 100},
		{instruments[24], 100},
		{instruments[117], 100},
		{Instrument{-1, "Drums", false}, 100},
	}
	preset.Grids = grids
	return preset
}

func (inst Instrument) Similar() []Instrument {
	insts := make([]Instrument, 0)
	for _, in := range instruments {
		if in.Tuned == inst.Tuned {
			insts = append(insts, in)
		}
	}
	return insts
}

func presets() map[string]Preset {
	presets := make(map[string]Preset)
	db.View(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte("Presets"))
		b.ForEach(func(k, v []byte) error {
			buf := bytes.NewBuffer(v)
			dec := gob.NewDecoder(buf)
			preset := Preset{}
			err := dec.Decode(&preset)
			if err != nil {
				return err
			}
			presets[string(k)] = preset
			return nil
		})
		return nil
	})
	return presets
}

func savePreset(name string, preset Preset, t *bolt.Tx) error {
	updateFunc := func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte("Presets"))

		var buf bytes.Buffer
		enc := gob.NewEncoder(&buf)
		err := enc.Encode(preset)
		if err != nil {
			return err
		}

		return b.Put([]byte(name), buf.Bytes())
	}
	// If tx isn't nil, we're already in the block
	if t == nil {
		return db.Update(func(tx *bolt.Tx) error {
			return updateFunc(tx)
		})
	} else {
		return updateFunc(t)
	}
}
