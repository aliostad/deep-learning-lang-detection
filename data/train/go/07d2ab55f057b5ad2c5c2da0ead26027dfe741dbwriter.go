package typedbytes

import (
	"encoding/binary"
	"fmt"
	"io"
	"reflect"
)

type WriteBasic func(i interface{}) error

type Encoder interface {
	Write(w io.Writer, v reflect.Value, b WriteBasic) error
}

type Writer struct {
	w        io.WriteCloser
	encoders map[reflect.Kind]Encoder
}

func NewWriter(w io.WriteCloser) *Writer {
	writer := &Writer{
		w:        w,
		encoders: make(map[reflect.Kind]Encoder),
	}
	writer.Register(reflect.Slice, SliceCodec)
	writer.Register(reflect.Chan, ChanCodec)
	writer.Register(reflect.Map, MapCodec)
	return writer
}

func (w *Writer) Close() error {
	return w.w.Close()
}

func (w *Writer) Register(t reflect.Kind, enc Encoder) {
	w.encoders[t] = enc
}

func (w *Writer) Write(i interface{}) error {
	switch t := i.(type) {
	case []byte:
		return w.writeBytes(t)
	case byte:
		return w.writeByte(t)
	case bool:
		return w.writeBool(t)
	case int32:
		return w.writeInt32(t)
	case int64:
		return w.writeInt64(t)
	case float32:
		return w.writeFloat32(t)
	case float64:
		return w.writeFloat64(t)
	case string:
		return w.writeString(t)
	}
	return w.writeComplex(i)
}

func (w *Writer) writeComplex(i interface{}) error {
	value := reflect.ValueOf(i)
	t := value.Type()
	enc, ok := w.encoders[t.Kind()]
	if !ok {
		return fmt.Errorf("No encoder for %T %v", i, i)
	}
	return enc.Write(w.w, value, w.Write)
}

func (w *Writer) writeBytes(i []byte) (err error) {
	return w.writeDelimited(Bytes, i)
}

func (w *Writer) writeByte(i byte) (err error) {
	return w.write(Byte, i)
}

func (w *Writer) writeBool(i bool) (err error) {
	if i {
		return w.write(Bool, byte(1))
	}
	return w.write(Bool, byte(0))
}

func (w *Writer) writeInt32(i int32) (err error) {
	return w.write(Int, i)
}

func (w *Writer) writeInt64(i int64) (err error) {
	return w.write(Long, i)
}

func (w *Writer) writeFloat32(i float32) (err error) {
	return w.write(Float, i)
}

func (w *Writer) writeFloat64(i float64) (err error) {
	return w.write(Double, i)
}

func (w *Writer) writeString(i string) (err error) {
	return w.writeDelimited(String, []byte(i))
}

func (w *Writer) write(t ByteType, i interface{}) (err error) {
	if err = binary.Write(w.w, binary.BigEndian, t); err != nil {
		return
	}

	return binary.Write(w.w, binary.BigEndian, i)
}

func (w *Writer) writeDelimited(t ByteType, i []byte) (err error) {
	if err = binary.Write(w.w, binary.BigEndian, t); err != nil {
		return
	}
	length := int32(len(i))
	if err = binary.Write(w.w, binary.BigEndian, length); err != nil {
		return
	}

	_, err = w.w.Write(i)
	return

	return binary.Write(w.w, binary.BigEndian, i)
}
