package commands

import "bytes"

const (
	crlf       = "\r\n"
	nullArray  = "*-1" + crlf
	nullBulk   = "$-1" + crlf
	emptyArray = "*0" + crlf
	emptyBulk  = "$0" + crlf + crlf
)

type Buffer struct {
	bytes.Buffer
}

func (b *Buffer) WriteArrayHeader(n int) {
	switch n {
	case 0:
		b.WriteString(emptyArray)
	case -1:
		b.WriteString(nullArray)
	default:
		b.WriteByte('*')
		b.writeInt(n, false)
	}
}

func (b *Buffer) WriteBulkBytes(str []byte) {
	if str == nil {
		b.WriteString(nullBulk)
		return
	}
	if len(str) == 0 {
		b.WriteString(emptyBulk)
		return
	}
	b.WriteByte('$')
	b.writeInt(len(str), false)
	b.Write(str)
	b.WriteString(crlf)
}

func (b *Buffer) WriteBulkInt(i int) {
	b.writeInt(i, true)
}

func (b *Buffer) WriteBulkString(str string) {
	if len(str) == 0 {
		b.WriteString(emptyBulk)
		return
	}
	b.WriteByte('$')
	b.writeInt(len(str), false)
	b.WriteString(str)
	b.WriteString(crlf)
}

func (b *Buffer) WriteCommand(cmd string, nArgs int) {
	b.WriteArrayHeader(nArgs + 1)
	b.WriteBulkString(cmd)
}

func (b *Buffer) WriteNullArray() {
	b.WriteString(nullArray)
}

func (b *Buffer) WriteNullBulkString() {
	b.WriteString(nullBulk)
}

func (b *Buffer) writeInt(v int, asBulk bool) {
	// 20 bytes for worst-case signed 64-bit integer in decimal.
	// 2 bytes for the CRLF.
	const bufLen = 20 + len(crlf)

	var (
		buf [bufLen]byte
		neg = v < 0
		i   = len(buf) - 2
	)

	// Write the CRLF.
	buf[i+0] = crlf[0]
	buf[i+1] = crlf[1]

	// Write all the digits.
	if neg {
		v = -v
	}
	uv := uint64(v)
	for uv >= 10 {
		i--
		next := uv / 10
		buf[i] = byte('0' + uv - next*10)
		uv = next
	}
	i--
	buf[i] = byte('0' + uv)

	// Write the sign, if any.
	if neg {
		i--
		buf[i] = '-'
	}

	if asBulk {
		b.WriteByte('$')
		b.writeInt(len(buf)-i, false)
	}
	b.Write(buf[i:])
}
