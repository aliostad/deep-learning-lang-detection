package jsonwriter

import (
	"bufio"
	"encoding/json"
	"io"
	"strconv"
)

//go:generate genwritefield

type Writer struct {
	w *bufio.Writer
}

func New(w io.Writer) *Writer {
	return &Writer{bufio.NewWriter(w)}
}

func (w *Writer) WriteObjectStart() { w.w.WriteByte('{') }
func (w *Writer) WriteObjectEnd()   { w.w.WriteByte('}') }
func (w *Writer) WriteArrayStart()  { w.w.WriteByte('[') }
func (w *Writer) WriteArrayEnd()    { w.w.WriteByte(']') }

func (w *Writer) WriteKey(s string) {
	w.WriteString(s)
	w.w.WriteByte(':')
}

func (w *Writer) WriteComma() {
	w.w.WriteByte(',')
}

func (w *Writer) WriteString(s string) {
	w.w.WriteByte('"')
	w.w.WriteString(s)
	w.w.WriteByte('"')
}

func (w *Writer) WriteInt64(n int64)     { w.w.WriteString(strconv.FormatInt(n, 10)) }
func (w *Writer) WriteFloat64(n float64) { w.w.WriteString(strconv.FormatFloat(n, 'g', -1, 64)) }
func (w *Writer) WriteBool(b bool)       { w.w.WriteString(strconv.FormatBool(b)) }

func (w *Writer) WriteRawMessage(m json.RawMessage) {
	w.w.Write([]byte(m))
}

func (w *Writer) Flush() error {
	return w.w.Flush()
}

func (w *Writer) Reset(newW io.Writer) {
	w.w.Reset(newW)
}

type Marshaler interface {
	MarshalJSONTo(w *Writer) error
}
