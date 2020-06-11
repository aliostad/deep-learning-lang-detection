package main

import (
	"encoding/binary"
	"io"
)

func WriteWav(w io.Writer, s io.Reader, length, chans, sps int) (err error) {

	defer func() {
		if e := recover(); e != nil {
			err = e.(error)
		}
	}()

	const (
		RIFF_MARK = 0x46464952
		WAVE_MARK = 0x45564157
		fmt__MARK = 0x20746D66
		data_MARK = 0x61746164
		bps       = 16 // bits per sample
	)

	write_u32(w, RIFF_MARK)
	write_u32(w, uint32(length+24+12))
	write_u32(w, WAVE_MARK)
	write_u32(w, fmt__MARK)
	write_u32(w, 16)

	write_u16(w, 1) // format PCM
	write_u16(w, uint16(chans))

	write_u32(w, uint32(sps))
	write_u32(w, uint32(bps/8*chans*sps)) // average bytes per sec

	write_u16(w, uint16(bps/8*chans)) // block align
	write_u16(w, bps)

	write_u32(w, data_MARK)
	write_u32(w, uint32(length))

	_, err = io.Copy(w, s)
	return
}

func write_u16(w io.Writer, u16 uint16) {
	order := binary.LittleEndian
	err := binary.Write(w, order, &u16)
	if err != nil {
		panic(err)
	}
}

func write_u32(w io.Writer, u32 uint32) {
	order := binary.LittleEndian
	err := binary.Write(w, order, &u32)
	if err != nil {
		panic(err)
	}
}
