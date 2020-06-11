package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
	"time"

	"github.com/campoy/audio/audio"
	"github.com/campoy/audio/note"
)

const sampleRate = 44100

var instruments = map[string]func(float64, float64) audio.Instrument{
	"sine":   audio.NewSine,
	"square": audio.NewSquare,
	"saw":    audio.NewSaw,
}

var currentInstrument = "sine"

type voice struct {
	ins   audio.Instrument
	notes []string
}

var voices = make(map[string]*voice)

func (v *voice) play(name string) {
	go func() {
		for {
			for _, txt := range v.notes {
				n, err := note.FromString(txt)
				if err == nil {
					v.ins.SetFreq(n.Freq())
				} else {
					v.ins.SetFreq(0)
				}
				time.Sleep(500 * time.Millisecond)
			}
		}
	}()

	err := v.ins.Play()
	if err != nil {
		panic(err)
	}
	fmt.Println(name, "done")
}

func melody(name string, notes []string) {
	if _, ok := voices[name]; !ok {
		voices[name] = &voice{
			ins: instruments[currentInstrument](0, sampleRate),
		}
		go voices[name].play(name)
	}
	voices[name].notes = notes
}

func action(name string, args []string) error {
	switch name {

	case "/list":
		for k, v := range voices {
			fmt.Println(k, v.notes)
		}

	case "/stop":
		if len(args) < 1 {
			return fmt.Errorf("use /stop voice")
		}
		v, ok := voices[args[0]]
		if !ok {
			return fmt.Errorf("%v is not a voice", args[0])
		}
		v.ins.Stop()
		delete(voices, args[0])

	case "/stop-all":
		for k, v := range voices {
			v.ins.Stop()
			delete(voices, k)
		}

	case "/currins":
		if len(args) < 1 {
			return fmt.Errorf("use /currins instrument")
		}
		_, ok := instruments[args[0]]
		if !ok {
			return fmt.Errorf("%v is not an instrument", args[0])
		}
		currentInstrument = args[0]

	case "/ins":
		if len(args) < 2 {
			return fmt.Errorf("use /ins voice instrument")
		}
		voice, ok := voices[args[0]]
		if !ok {
			return fmt.Errorf("%v is not a voice", args[0])
		}
		ins, ok := instruments[args[1]]
		if !ok {
			return fmt.Errorf("%v is not an instrument", args[1])
		}
		voice.ins.Stop()
		voice.ins = ins(0, sampleRate)
		go voice.play(name)
	}

	return fmt.Errorf("%v is not an action", name)
}

func main() {
	audio.Initialize()
	defer audio.Terminate()

	s := bufio.NewScanner(os.Stdin)
	for s.Scan() {
		fs := strings.Fields(s.Text())
		if len(fs) == 0 {
			continue
		}

		name, args := fs[0], fs[1:]
		switch name[0] {
		case '/':
			if err := action(name, args); err != nil {
				fmt.Println(err)
			}
		default:
			if len(args) == 0 {
				fmt.Println("melodies need at least one note")
			}
			melody(name, args)
		}
	}
	if err := s.Err(); err != nil {
		panic(err)
	}

}
