package logl

import (
	"bytes"
	"time"
)

var (
	tag_Critical = []byte("CRI")
	tag_Error    = []byte("ERR")
	tag_Warning  = []byte("WAR")
	tag_Info     = []byte("INF")
	tag_Debug    = []byte("DEB")
)

type TextFormat struct {
	HasLevel      bool
	Date          bool
	Time          bool
	Microseconds  bool
	ShieldSpecial bool // { '\n', '\r', '\t' }
}

func (f *TextFormat) Format(r *Record) []byte {
	var buf bytes.Buffer
	writeTextFormat(&buf, r, f)
	return buf.Bytes()
}

func writeTextFormat(buf *bytes.Buffer, r *Record, f *TextFormat) {

	if f.HasLevel {
		writeLevel(buf, r.Level)
		buf.WriteByte(' ')
	}

	if f.Date || f.Time || f.Microseconds {
		writeTime(buf, f, r.Time)
	}

	if f.ShieldSpecial {
		writeShieldSpecial(buf, r.Message)
	} else {
		buf.WriteString(r.Message)
	}
	if !lastByteIs(r.Message, '\n') {
		buf.WriteByte('\n')
	}
}

func writeLevel(buf *bytes.Buffer, level Level) {
	switch level {
	case LevelCritical:
		buf.Write(tag_Critical)
	case LevelError:
		buf.Write(tag_Error)
	case LevelWarning:
		buf.Write(tag_Warning)
	case LevelInfo:
		buf.Write(tag_Info)
	case LevelDebug:
		buf.Write(tag_Debug)
	}
}

func writeTime(buf *bytes.Buffer, f *TextFormat, t time.Time) {

	if f.Date {

		const dateSeparator = '/'

		year, month, day := t.Date()
		writeIntn(buf, year, 4)
		buf.WriteByte(dateSeparator)
		writeIntn(buf, int(month), 2)
		buf.WriteByte(dateSeparator)
		writeIntn(buf, day, 2)
		buf.WriteByte(' ')
	}

	if f.Time || f.Microseconds {

		const timeSeparator = ':'

		hour, min, sec := t.Clock()
		writeIntn(buf, hour, 2)
		buf.WriteByte(timeSeparator)
		writeIntn(buf, min, 2)
		buf.WriteByte(timeSeparator)
		writeIntn(buf, sec, 2)
		if f.Microseconds {
			buf.WriteByte('.')
			writeIntn(buf, t.Nanosecond()/1e3, 6)
		}
		buf.WriteByte(' ')
	}
}

func writeIntn(buf *bytes.Buffer, d int, n int) {
	const base = 10
	data := make([]byte, n)
	i := len(data)
	for range data {
		quo, rem := quoRem(d, base)
		i--
		data[i] = byte('0' + rem)
		d = quo
	}
	buf.Write(data)
}

func writeShieldSpecial(buf *bytes.Buffer, m string) {
	for _, r := range m {
		switch r {
		case '\n':
			buf.WriteByte('\\')
			buf.WriteByte('n')
		case '\r':
			buf.WriteByte('\\')
			buf.WriteByte('r')
		case '\t':
			buf.WriteByte('\\')
			buf.WriteByte('t')
		case '\\':
			buf.WriteByte('\\')
			buf.WriteByte('\\')
		default:
			buf.WriteRune(r)
		}
	}
}
