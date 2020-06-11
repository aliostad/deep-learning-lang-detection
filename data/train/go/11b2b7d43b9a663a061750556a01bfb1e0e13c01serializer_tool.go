package serializertool

import (
	"bytes"
	"errors"
	"github.com/yankai913/go-tools/bytetool"
)

type WriteBuffer struct {
	buffer bytes.Buffer
}

func (writeBuffer *WriteBuffer) Bytes() []byte {
	return writeBuffer.buffer.Bytes()
}

func (writeBuffer *WriteBuffer) WriteBytes(b []byte) {
	writeBuffer.buffer.Write(b)
}

func (writeBuffer *WriteBuffer) WriteByte(b byte) {
	writeBuffer.buffer.WriteByte(b)
}

func (writeBuffer *WriteBuffer) WriteUint16(b uint16) {
	writeBuffer.WriteBytes(bytetool.Uint16ToBytes(b))
}

func (writeBuffer *WriteBuffer) WriteUint32(b uint32) {
	writeBuffer.WriteBytes(bytetool.Uint32ToBytes(b))
}

func (writeBuffer *WriteBuffer) WriteUint64(b uint64) {
	writeBuffer.WriteBytes(bytetool.Uint64ToBytes(b))
}

func (writeBuffer *WriteBuffer) WriteString(str string) {
	size := len([]byte(str))
	writeBuffer.WriteUint64(uint64(size))
	writeBuffer.WriteBytes([]byte(str))
}

type ReadBuffer struct {
	buffer *bytes.Buffer
}

func NewReadBuffer(b []byte) (readBuffer *ReadBuffer) {
	temBuffer := bytes.NewBuffer(b)
	readBuffer = &ReadBuffer{buffer: temBuffer}
	return
}

func (readBuffer *ReadBuffer) Read(p []byte) (n int, err error) {
	n, err = readBuffer.buffer.Read(p)
	if len(p) != n {
		err = errors.New("readBuffer.Read([]byte) fail")
		n = 0
	}
	return
}

func (readBuffer *ReadBuffer) ReadByte() (c byte, err error) {
	c, err = readBuffer.buffer.ReadByte()
	return
}

func (readBuffer *ReadBuffer) ReadUint16() (c uint16, err error) {
	p := make([]byte, 2)
	_, err2 := readBuffer.Read(p)
	if err2 != nil {
		c = 0
		err = err2
		return
	}
	c = bytetool.BytesToUint16(p)
	err = nil
	return
}

func (readBuffer *ReadBuffer) ReadUint32() (c uint32, err error) {
	p := make([]byte, 4)
	_, err2 := readBuffer.Read(p)
	if err2 != nil {
		c = 0
		err = err2
		return
	}
	c = bytetool.BytesToUint32(p)
	err = nil
	return
}

func (readBuffer *ReadBuffer) ReadUint64() (c uint64, err error) {
	p := make([]byte, 8)
	_, err2 := readBuffer.Read(p)
	if err2 != nil {
		c = 0
		err = err2
		return
	}
	c = bytetool.BytesToUint64(p)
	err = nil
	return
}

func (readBuffer *ReadBuffer) ReadString() (c string, err error) {
	n2, err2 := readBuffer.ReadUint64()
	c = ""
	if err2 != nil {
		err = err2
		return
	}
	p := make([]byte, n2)
	_, err3 := readBuffer.Read(p)
	if err3 != nil {
		err = err3
		return
	}
	c = string(p)
	err = nil
	return
}
