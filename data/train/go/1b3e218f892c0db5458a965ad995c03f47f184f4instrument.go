package main

import (
	"fmt"
	"github.com/hypebeast/go-osc/osc"
	"strconv"
	"time"
)

// Maps OSC messages to controls, to be scaled by Instrument.intensity
type OscControl struct {
	Name   string  `json:"name"`
	MaxVal float32 `json:"maxVal"`
	MinVal float32 `json:"minVal"`
	CurVal float32 `json:"curVal"`
}

type Note struct {
	Threshold float32 `json:"threshold"`
	Value     int     `json:"value"`
	Velocity  int     `json:"velocity"`
	Active    bool
}

// mock out modulator instrument, refactor into interfaces later
type Instrument struct {
	// identify this instrument, should match sensor id?
	Id int `json:"id"`
	// midi device ID to bind to, multiple instruments can share
	MidiDeviceId int `json:"midiDeviceId"`
	// midi channel for notes
	NotesMidiChannel int `json:"notesMidiChannel"`
	// midi channel for volume
	VolumeMidiChannel int `json:"volumeMidiChannel"`
	// osc client, each instrument must have it's own
	clients []*osc.Client
	// store sensor value
	SensorVal int `json:"sensorVal"`
	// calculated "intensity" value, value 0-1
	Intensity float32 `json:"intensity"`
	// ticker to handle send intervals
	oscTick *time.Ticker
	// active threshold
	Threshold int `json:"threshold"`
	// sensor type
	SensorType SensorType `json:"sensorType"`
	// individual things for OSC to control
	Controls []OscControl `json:"controls"`
	// base OSC path
	BasePath string `json:"basePath"`
	// notes!
	Notes []Note `json:"notes"`
}

func (ins *Instrument) translate(val int, fromMax int, fromMin int, toMax int, toMin int) float32 {
	fromSpan := fromMax - fromMin
	toSpan := toMax - toMin

	valueScaled := float32(val-fromMin) / float32(fromSpan)
	return valueScaled * float32(toSpan)

}

func (ins *Instrument) start() {
	fmt.Printf("starting instrument %d\n", ins.Id)
	go func() {
		for {
			select {
			case <-ins.oscTick.C:
				ins.send()
			}
		}
	}()
}

func (ins *Instrument) update(m measurement) {
	// fmt.Printf("updating %d: %v\n", ins.Id, m)

	// store value in case we need it elsewhere
	ins.SensorVal = m.value

	// calculate intensity as range a float between 0 and 1
	ins.Intensity = ins.translate(m.value, ins.SensorType.MaxVal, ins.SensorType.MinVal, 1, 0)
	// turn on some notes
	for i, note := range ins.Notes {
		if ins.Intensity > note.Threshold {
			ins.Notes[i].Active = true
		} else {
			ins.Notes[i].Active = false
		}
	}
	// update controls
	for i, control := range ins.Controls {
		controlSpan := float32(control.MaxVal - control.MinVal)
		ins.Controls[i].CurVal = (controlSpan * ins.Intensity) + control.MinVal
	}
}

func (ins *Instrument) send() {

	go func() {
		bundle := osc.NewBundle(time.Now())

		for _, note := range ins.Notes {
			noteMsg := osc.NewMessage(ins.BasePath + "/note")
			noteMsg.Append(int32(ins.Id))
			noteMsg.Append(int32(ins.MidiDeviceId))
			noteMsg.Append(int32(ins.NotesMidiChannel))
			noteMsg.Append(int32(note.Value))
			noteMsg.Append(note.Active)
			noteMsg.Append(int32(note.Velocity))
			bundle.Append(noteMsg)
		}

		// TODO: is this message useful?
		// intensityMsg := osc.NewMessage(ins.basePath + "/intensity")
		// intensityMsg.Append(int32(ins.intensity))
		// bundle.Append(intensityMsg)

		for _, control := range ins.Controls {
			controlMsg := osc.NewMessage(ins.BasePath + strconv.Itoa(ins.Id) + "/controls/" + control.Name)
			controlMsg.Append(control.CurVal)
			bundle.Append(controlMsg)
		}

		for _, client := range ins.clients {
			// fmt.Println("sending")
			client.Send(bundle)
		}
	}()
}
