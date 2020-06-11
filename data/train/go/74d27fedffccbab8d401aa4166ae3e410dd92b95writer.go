package d2protocol

import (
	"encoding/binary"
	"io"
)

// Writer is the minimal interface required to serialiaze any
// protocol message/type
type Writer interface {
	WriteBoolean(bool) error
	WriteInt8(int8) error
	WriteUInt8(uint8) error
	WriteInt16(int16) error
	WriteUInt16(uint16) error
	WriteInt32(int32) error
	WriteUInt32(uint32) error
	WriteFloat(float32) error
	WriteDouble(float64) error
	WriteString(string) error
	WriteVarInt16(int16) error
	WriteVarUInt16(uint16) error
	WriteVarInt32(int32) error
	WriteVarUInt32(uint32) error
	WriteVarInt64(int64) error
	WriteVarUInt64(uint64) error
}

type writer struct {
	w io.Writer
}

func NewWriter(w io.Writer) Writer {
	return &writer{w}
}

func (w *writer) write(x interface{}) error {
	return binary.Write(w.w, binary.BigEndian, x)
}

func (w *writer) writeVar(x uint64) error {
	for x != 0 {
		b := uint8(x & 0x7f)
		x >>= 7
		if x != 0 {
			b |= 0x80
		}
		if err := w.WriteUInt8(b); err != nil {
			return err
		}
	}
	return nil
}

func (w *writer) WriteBoolean(x bool) error {
	var b uint8
	if x {
		b = 1
	} else {
		b = 0
	}
	return w.write(b)
}

func (w *writer) WriteInt8(x int8) error {
	return w.write(x)
}

func (w *writer) WriteUInt8(x uint8) error {
	return w.write(x)
}

func (w *writer) WriteInt16(x int16) error {
	return w.write(x)
}

func (w *writer) WriteUInt16(x uint16) error {
	return w.write(x)
}

func (w *writer) WriteInt32(x int32) error {
	return w.write(x)
}

func (w *writer) WriteUInt32(x uint32) error {
	return w.write(x)
}

func (w *writer) WriteFloat(x float32) error {
	return w.write(x)
}

func (w *writer) WriteDouble(x float64) error {
	return w.write(x)
}

func (w *writer) WriteString(x string) error {
	if err := w.WriteUInt16(uint16(len(x))); err != nil {
		return err
	}
	return w.write([]byte(x))
}

func (w *writer) WriteVarInt16(x int16) error {
	return w.writeVar(uint64(x))
}

func (w *writer) WriteVarUInt16(x uint16) error {
	return w.writeVar(uint64(x))
}

func (w *writer) WriteVarInt32(x int32) error {
	return w.writeVar(uint64(x))
}

func (w *writer) WriteVarUInt32(x uint32) error {
	return w.writeVar(uint64(x))
}

func (w *writer) WriteVarInt64(x int64) error {
	return w.writeVar(uint64(x))
}

func (w *writer) WriteVarUInt64(x uint64) error {
	return w.writeVar(x)
}
