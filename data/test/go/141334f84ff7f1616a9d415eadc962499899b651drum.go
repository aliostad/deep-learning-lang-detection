package drum

import (
	"bytes"
	"encoding/binary"
	"fmt"
	"io"
	"os"
	"strings"
)

// numSteps is the number of 'steps' played by an instrument each song.
const numSteps = 16

// Instrument is a high level representation of a single instrument in the
// pattern.
type Instrument struct {
	id    int
	name  string
	steps [numSteps]bool
}

// Pattern is a high level representation of a track pattern contained within a
// .splice file.
type Pattern struct {
	version     string
	tempo       float32
	instruments []Instrument
}

// String implements the stringer.
func (p *Pattern) String() string {

	// Create string of track information according to specification;
	//	Saved with HW Version: 0.708-alpha
	//	Tempo: 999
	//	(1) Kick	|x---|----|x---|----|
	//	(2) HiHat	|x-x-|x-x-|x-x-|x-x-|

	var buf bytes.Buffer

	versTrim := strings.Trim(p.version, "\x00")
	buf.WriteString(fmt.Sprintf("Saved with HW Version: %s\n", versTrim))
	buf.WriteString(fmt.Sprintf("Tempo: %v\n", p.tempo))

	for _, inst := range p.instruments {
		buf.WriteString(fmt.Sprintf("(%v) %s\t", inst.id, inst.name))

		for i, step := range inst.steps {
			if i%4 == 0 {
				buf.WriteString("|")
			}

			switch {
			case step:
				buf.WriteString("x")
			default:
				buf.WriteString("-")
			}
		}

		buf.WriteString("|\n")
	}

	return buf.String()
}

// header is a string that is expected to be present
// on `.splice` files to be decoded.
const header = "SPLICE"

// Decode opens the specified drum machine file and decodes it into a pattern.
func Decode(path string) (*Pattern, error) {
	file, err := os.Open(path)
	if err != nil {
		return nil, err
	}
	defer file.Close()

	p, err := decodePattern(file)
	if err != nil {
		fmt.Println("Error in parseSpliceToPattern: ", err)
		return nil, err
	}

	return p, nil
}

// decodePattern reads the drum machine data and performs the unmarshaling.
func decodePattern(r io.Reader) (*Pattern, error) {
	var p Pattern

	var hdr [len(header)]byte
	if err := binary.Read(r, binary.BigEndian, &hdr); err != nil {
		return nil, fmt.Errorf("unable to decode splice header: %v", err)
	}

	if header != string(hdr[:]) {
		return nil, fmt.Errorf("decoded file header does not match %v", header)
	}

	var patSize int64
	if err := binary.Read(r, binary.BigEndian, &patSize); err != nil {
		return nil, fmt.Errorf("unable to decode patSize: %v", err)
	}

	var version [32]byte
	if err := binary.Read(r, binary.BigEndian, &version); err != nil {
		return nil, fmt.Errorf("unable to decode version: %v", err)
	}
	p.version = string(version[:])

	if err := binary.Read(r, binary.LittleEndian, &p.tempo); err != nil {
		return nil, fmt.Errorf("unable to decode tempo: %v", err)
	}

	// LimitReader needs to be offset by `-36` = (version(32) + tempo(4))
	// since we've already read in version and tempo.
	const offset = 36
	lr := io.LimitReader(r, patSize-offset)

	for {
		inst, err := decodeInstrument(lr)
		if err != nil {
			if err == io.EOF {
				break
			}
			return nil, err
		}

		p.instruments = append(p.instruments, inst)
	}

	return &p, nil
}

// decodeInstrument decodes and returns the instrument information contained
// within the body of the Pattern.
func decodeInstrument(lr io.Reader) (Instrument, error) {
	var inst Instrument

	var id uint8
	if err := binary.Read(lr, binary.BigEndian, &id); err != nil {
		if err == io.EOF {
			return Instrument{}, err
		}
		return Instrument{}, fmt.Errorf("unable to decode id: %v", err)
	}
	inst.id = int(id)

	var nameLen int32
	if err := binary.Read(lr, binary.BigEndian, &nameLen); err != nil {
		return Instrument{}, fmt.Errorf("unable to decode instrument nameLen: %v", err)
	}

	name := make([]byte, nameLen)
	if err := binary.Read(lr, binary.LittleEndian, &name); err != nil {
		return Instrument{}, fmt.Errorf("unable to decode instrument name: %v", err)
	}
	inst.name = string(name)

	var steps [numSteps]byte
	if err := binary.Read(lr, binary.LittleEndian, &steps); err != nil {
		return Instrument{}, fmt.Errorf("unable to decode instrument steps: %v", err)
	}
	for i := range steps {
		switch steps[i] {
		case 0x01:
			inst.steps[i] = true
		case 0x00:
			inst.steps[i] = false
		default:
			return Instrument{}, fmt.Errorf("unexpected values in encoded instrument steps")
		}
	}

	return inst, nil
}
