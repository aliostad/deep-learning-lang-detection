package packet

import "bytes"

func (m *Message) dataInBytes() []byte {
	// rfc7143 11.7
	buf := &bytes.Buffer{}
	buf.WriteByte(byte(OpSCSIIn))
	var b byte
	b = 0x80
	if m.HasStatus {
		b |= 0x01
	}
	buf.WriteByte(b)
	buf.WriteByte(0x00)
	if m.HasStatus {
		b = byte(m.Status)
	}
	buf.WriteByte(b)

	buf.WriteByte(0x00)                                  // 4
	buf.Write(MarshalUint64(uint64(len(m.RawData)))[5:]) // 5-8
	buf.WriteByte(0x00)
	buf.WriteByte(byte(m.LUN))
	// Skip through to byte 16
	for i := 0; i < 6; i++ {
		buf.WriteByte(0x00)
	}
	buf.Write(MarshalUint64(uint64(m.TaskTag))[4:])
	for i := 0; i < 4; i++ {
		// 11.7.4
		buf.WriteByte(0xff)
	}
	buf.Write(MarshalUint64(uint64(m.StatSN))[4:])
	buf.Write(MarshalUint64(uint64(m.ExpCmdSN))[4:])
	buf.Write(MarshalUint64(uint64(m.MaxCmdSN))[4:])
	buf.Write(MarshalUint64(uint64(m.DataSN))[4:])
	buf.Write(MarshalUint64(uint64(m.BufferOffset))[4:])
	for i := 0; i < 4; i++ {
		buf.WriteByte(0x00)
	}
	buf.Write(m.RawData)
	dl := len(m.RawData)
	for dl%4 > 0 {
		dl++
		buf.WriteByte(0x00)
	}

	return buf.Bytes()
}
