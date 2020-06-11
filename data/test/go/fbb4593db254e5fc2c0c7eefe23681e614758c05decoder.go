package drum

import (
	"fmt"
	"encoding/binary"
	"os"
	"bytes"
	"io"
	"log"
)

// DecodeFile decodes the drum machine file found at the provided path
// and returns a pointer to a parsed pattern which is the entry point to the
// rest of the data.
// TODO: implement
func DecodeFile(path string) (*Pattern, error) {
	var p Pattern;

	buf := make([]byte,14,32)
	f, err := os.Open(path)
	if err != nil {
	   panic(err)
	}

	defer f.Close()

	//read SPLICE and empty characters
	binary.Read(f,binary.LittleEndian,buf)

	//32 bytes for version string
	buf = buf[0:32]
	binary.Read(f,binary.LittleEndian,buf)
	p.version = string(bytes.Trim(buf,"\x00"))

	//get tempo from 4 bytes (int32)
	binary.Read(f,binary.LittleEndian,&p.tempo)

	//remaining bytes are instruments
	dec := &InstrumentDecoder{f}
	for {
		var i Instrument
		if err := dec.Decode(&i); err == io.EOF {
			break
		} else if err != nil {
			log.Fatal(err)
			panic(err)
		}
		p.instruments = append(p.instruments,i)
	}

	return &p, nil
}

type InstrumentDecoder struct{
	reader io.Reader
}

func (dec *InstrumentDecoder) Decode(i *Instrument) error{
	buf := make([]byte,0,100)
	var length uint8;
	e := binary.Read(dec.reader,binary.LittleEndian,&i.id)
	if(e != nil){
		if(e == io.ErrUnexpectedEOF){
			return io.EOF
		}else{
			return e
		}
	}

	//hit SPLICE, return 
	if(i.id == 1229738067){
		return io.EOF
	}

	//get length of name
	e = binary.Read(dec.reader,binary.LittleEndian,&length)
	if(e != nil){
		return e;
	}
	buf = buf[0:length]

	//read name into buffer
	e = binary.Read(dec.reader,binary.LittleEndian,buf)
	if(e != nil){
		return e;
	}
	i.name = string(buf)

	//read 16 bytes for steps
	buf = buf[0:16]
	e = binary.Read(dec.reader,binary.LittleEndian,buf)
	if(e != nil){
		return e;
	}

	for index,value := range buf{
		if(value != 0x00){
			i.steps[index] = true;
		}
	}
	return nil
}


// Pattern is the high level representation of the
// drum pattern contained in a .splice file.
// TODO: implement
type Pattern struct{
	version string
	instruments []Instrument
	tempo float32
}

type Instrument struct{
	name string
	id int32
	steps [16]bool

}

func (i Instrument) String() string{
	str := fmt.Sprintf("(%v) %v\t",i.id,i.name)
	for index,value := range i.steps {
		if(index % 4 == 0){
			str += "|"
		}
		if(value == true){
			str += "x"
		}else{
			str += "-"
		}
	}
	return str + "|"
}

func (p Pattern) String() string{
	str := fmt.Sprintln("Saved with HW Version:",p.version)
	str += fmt.Sprintln("Tempo:",p.tempo)
	for _,value := range p.instruments {
		str += value.String() + "\n"
	}
	return str
}