package filestore

import (
	"bufio"
	"errors"
	"fmt"
	"github.com/crockeo/go-tuner/synth"
	"io"
)

// Dealing with snyth.RawDelayedNoteData from flat plaintext files in the legacy
// formerly-used legacy format.
type TextArrangement struct{}

func (a TextArrangement) ReadNoteArrangement(reader io.Reader) ([]synth.RawDelayedNoteData, error) {
	parseLine := func(line string) (synth.RawDelayedNoteData, error) {
		var delay float32
		var note string
		var duration float32
		var instrument string

		n, err := fmt.Sscanf(line, "%f %s %f %s\n", &delay, &note, &duration, &instrument)
		if n != 4 || err != nil {
			return synth.RawDelayedNoteData{}, errors.New("Malformed line: \"" + line + "\"")
		}

		return synth.RawDelayedNoteData{
			delay,
			note,
			duration,
			instrument,
		}, nil

		return synth.RawDelayedNoteData{}, nil
	}

	realReader := bufio.NewReader(reader)
	notes := []synth.RawDelayedNoteData{}
	var err error
	line := ""
	for bytes, prefix, err := realReader.ReadLine(); err == nil; bytes, prefix, err = realReader.ReadLine() {
		if prefix {
			line += string(bytes)
		} else {
			line += string(bytes)

			if line != "" && line[0] != '#' {
				note, err := parseLine(line)
				if err != nil {
					return []synth.RawDelayedNoteData{}, err
				}

				notes = append(notes, note)
			}

			line = ""
		}
	}

	if err == io.EOF {
		return []synth.RawDelayedNoteData{}, err
	}

	return notes, nil
}

func (a TextArrangement) WriteNoteArrangement(writer io.Writer, notes []synth.RawDelayedNoteData) error {
	formatLine := func(note synth.RawDelayedNoteData) string {
		return fmt.Sprintf("%f %s %f %s\n", note.Delay, note.Note, note.Duration, note.Instrument)
	}

	for _, v := range notes {
		_, err := writer.Write([]byte(formatLine(v)))
		if err != nil {
			return err
		}
	}

	return nil
}
