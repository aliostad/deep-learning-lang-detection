package mio

import (
	"bytes"
	"io"
)

// WriteLines
func WriteLines(out io.Writer, lines []string) (int64, error) {
	buf := bytes.NewBufferString("")
	for _, line := range lines {
		buf.WriteString(line)
		buf.WriteString("\n")
	}
	return buf.WriteTo(out)
}

// WriteText
func WriteText(out io.Writer, text string) (int64, error) {
	return NewBufferReader(text).WriteTo(out)
}

// WriteStrings
func WriteStrings(out io.Writer, args ...string) (int64, error) {
	buf := bytes.NewBufferString("")
	for _, arg := range args {
		buf.WriteString(arg)
	}
	return buf.WriteTo(out)
}
