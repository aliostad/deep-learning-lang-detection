package main

import (
	"bytes"
)

type PacketWriter struct {
	opcode uint16
	writer *bytes.Buffer
}

func NewPacketWriter(opcode uint16) *PacketWriter {
	return &PacketWriter{
		opcode,
		new(bytes.Buffer)}
}

func (m *PacketWriter) WriteByte(input byte) {
	m.writer.WriteByte(input)
}

func (m *PacketWriter) WriteInt16(input int16) {
	m.WriteByte(byte((input >> 0) & 0xFF))
	m.WriteByte(byte((input >> 8) & 0xFF))
}

func (m *PacketWriter) WriteInt32(input int32) {
	m.WriteByte(byte((input >> 0) & 0xFF))
	m.WriteByte(byte((input >> 8) & 0xFF))
	m.WriteByte(byte((input >> 16) & 0xFF))
	m.WriteByte(byte((input >> 24) & 0xFF))
}

func (m *PacketWriter) WriteInt64(input int64) {
	m.WriteUInt32(uint32(input >> 0))
	m.WriteUInt32(uint32(input >> 32))
}

func (m *PacketWriter) WriteUInt16(input uint16) {
	m.WriteByte(byte((input >> 0) & 0xFF))
	m.WriteByte(byte((input >> 8) & 0xFF))
}

func (m *PacketWriter) WriteUInt32(input uint32) {
	m.WriteByte(byte((input >> 0) & 0xFF))
	m.WriteByte(byte((input >> 8) & 0xFF))
	m.WriteByte(byte((input >> 16) & 0xFF))
	m.WriteByte(byte((input >> 24) & 0xFF))
}

func (m *PacketWriter) WriteUInt64(input uint64) {
	m.WriteUInt32(uint32(input >> 0))
	m.WriteUInt32(uint32(input >> 32))
}

func (m *PacketWriter) WriteBytes(buffer []byte) {
	m.writer.Write(buffer)
}

func (m *PacketWriter) WriteString(input string, ascii bool) {
	buffer := bytes.NewBufferString(input).Bytes()
	size := len(buffer)
	m.WriteInt16(int16(size))
	if ascii {
		m.WriteBytes(buffer)
	} else {
		for i := 0; i < size; i++ {
			m.writer.WriteByte(byte(buffer[i]))
			m.writer.WriteByte(0)
		}
	}
}
