package module
import "encoding/binary"

type Instrument struct {
	name string
	length int64
	finetune int8
	volume int8
	repeatOffset uint16
	repeatLength uint16
	data []byte
}

func (i *Instrument) Name() string {
	return i.name
}

func (i *Instrument) Length() int64 {
	return i.length
}

func (i *Instrument) Load(data []byte) (error) {
	i.name = string(data[0:22])
	// Length is stored as number of words in the PT format, but we'll store it as number of bytes
	i.length = int64(binary.BigEndian.Uint16(data[22:24])) * 2
	i.finetune = int8(data[24])
	i.volume = int8(data[25])
	i.repeatOffset = binary.BigEndian.Uint16(data[25:27])
	i.repeatLength = binary.BigEndian.Uint16(data[27:29])

	return nil
}

func (i *Instrument) Data() []byte {
	return i.data
}
