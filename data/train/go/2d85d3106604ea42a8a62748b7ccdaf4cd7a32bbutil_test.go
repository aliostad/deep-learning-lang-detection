package redis

import (
	"bytes"
	"strconv"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestWriteInt(t *testing.T) {
	var buf bytes.Buffer

	writeInt(&buf, ':', -9223372036854775808)
	assert.Equal(t, ":-9223372036854775808\r\n", buf.String())
	buf.Reset()

	writeInt(&buf, '$', 9223372036854775807)
	assert.Equal(t, "$9223372036854775807\r\n", buf.String())
	buf.Reset()

	writeInt(&buf, '$', -1)
	assert.Equal(t, "$-1\r\n", buf.String())
	buf.Reset()

	writeInt(&buf, ':', 0)
	assert.Equal(t, ":0\r\n", buf.String())
	buf.Reset()

	writeInt(&buf, '*', 45)
	assert.Equal(t, "*45\r\n", buf.String())
	buf.Reset()
}

func BenchmarkWriteCRLF(b *testing.B) {
	var buf bytes.Buffer
	for i := 0; i < b.N; i++ {
		buf.WriteString("\r\n")
		buf.Reset()
	}
}

func BenchmarkAltWriteCRLF(b *testing.B) {
	var buf bytes.Buffer
	for i := 0; i < b.N; i++ {
		buf.WriteByte('\r')
		buf.WriteByte('\n')
		buf.Reset()
	}
}

func BenchmarkWriteInt(b *testing.B) {
	var buf bytes.Buffer
	for i := 0; i < b.N; i++ {
		writeInt(&buf, '$', 9223372036854775807)
		buf.Reset()
	}
}

func BenchmarkAltWriteInt(b *testing.B) {
	var buf bytes.Buffer
	for i := 0; i < b.N; i++ {
		altWriteInt(&buf, '$', 9223372036854775807)
		buf.Reset()
	}
}

func altWriteInt(w *bytes.Buffer, t byte, v int64) {
	w.WriteByte(t)
	w.WriteString(strconv.FormatInt(v, 10))
	w.WriteString(crlf)
}
