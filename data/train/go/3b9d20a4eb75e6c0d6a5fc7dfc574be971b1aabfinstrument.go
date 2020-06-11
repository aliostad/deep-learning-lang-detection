package music

import "io/ioutil"

type generator interface {
	newNodeId() int
	newBusId() int
	newGroupId() int
	newSampleBuffer() int
}

type instrument interface {
	Name() string
}

type sCInstrument struct {
	name string // name of the instrument must not have characters other than [a-zA-Z0-9_]
	Path string // path of the instrument
	// Offset float64 // offset applied to every instance of the instrument
	used bool
}

// the outer invoker may use the first voices instrument to query loadcode etc
func newSCInstrument(g generator, name, path string, numVoices int) []*Voice {
	i := &sCInstrument{
		name: name,
		Path: path,
	}
	return _voices(numVoices, g, i, -1)
}

func (i *sCInstrument) Name() string {
	return i.name
}

func (i *sCInstrument) IsUsed() bool {
	return i.used
}

func (i *sCInstrument) Use() {
	i.used = true
}

func (i *sCInstrument) LoadCode() []byte {
	data, err := ioutil.ReadFile(i.Path)
	if err != nil {
		panic("can't read instrument " + i.Path)
	}
	return data
}

func _voices(num int, g generator, instr instrument, groupid int) []*Voice {
	voices_ := make([]*Voice, num)

	for i := 0; i < num; i++ {
		voices_[i] = &Voice{generator: g, instrument: instr}
		if groupid > -1 {
			voices_[i].Group = groupid
		}
	}

	return voices_
}
