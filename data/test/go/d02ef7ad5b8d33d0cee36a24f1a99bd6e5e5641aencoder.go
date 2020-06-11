package binny

import (
	"bufio"
	"encoding"
	"encoding/gob"
	"io"
	"math"
	"reflect"
	"unsafe"
)

const DefaultEncoderBufferSize = 4096

// Marshaler is the interface implemented by objects that can marshal themselves into a binary representation.
// Implementing this bypasses reflection and is generally faster but not nessecery optimized.
type Marshaler interface {
	MarshalBinny(enc *Encoder) error
}

type Encoder struct {
	w *bufio.Writer

	NoAutoFlushOnEncode bool // Do not auto flush after calling .Encode.
}

// NewEncoder returns a new encoder with the DefaultEncoderBufferSize
func NewEncoder(w io.Writer) *Encoder {
	return NewEncoderSize(w, DefaultEncoderBufferSize)
}

// NewEncoder returns a new encoder with the specific buffer size, minimum is 24 bytes.
func NewEncoderSize(w io.Writer, sz int) *Encoder {
	if sz < 24 {
		sz = 24
	}
	return &Encoder{
		w: bufio.NewWriterSize(w, sz),
	}
}

// Reset discards any unflushed buffered data, clears any error, and
// resets b to write its output to w.
func (enc *Encoder) Reset(w io.Writer) {
	enc.w.Reset(w)
}

func (enc *Encoder) writeType(t Type) error {
	return enc.w.WriteByte(byte(t))
}

func (enc *Encoder) WriteVarUint(x uint64) error {
	enc.writeType(VarUint)
	return enc.writeVarUint(x)
}

func (enc *Encoder) writeVarUint(x uint64) error {
	for x >= 0x80 {
		enc.w.WriteByte(byte(x) | 0x80)
		x >>= 7
	}
	return enc.w.WriteByte(byte(x))
}

func (enc *Encoder) WriteVarInt(x int64) error {
	enc.writeType(VarInt)
	return enc.writeVarInt(x)
}

func (enc *Encoder) writeVarInt(x int64) error {
	ux := uint64(x) << 1
	if x < 0 {
		ux = ^ux
	}
	return enc.writeVarUint(ux)
}

func (enc *Encoder) WriteString(v string) error {
	enc.writeType(String)
	enc.writeLen(len(v))
	_, err := enc.w.WriteString(v)
	return err
}

func (enc *Encoder) WriteBytes(v []byte) error {
	enc.writeType(ByteSlice)
	enc.writeLen(len(v))
	_, err := enc.Write(v)
	return err
}

func (enc *Encoder) Encode(v interface{}) (err error) {
	oldNoFlush := enc.NoAutoFlushOnEncode
	enc.NoAutoFlushOnEncode = true
	switch v := v.(type) {
	case Marshaler:
		err = v.MarshalBinny(enc)
	case encoding.BinaryMarshaler:
		err = enc.WriteBinary(v)
	case gob.GobEncoder:
		err = enc.WriteGob(v)
	case string:
		err = enc.WriteString(v)
	case []byte:
		err = enc.WriteBytes(v)
	case int64:
		err = enc.WriteInt(int64(v))
	case int32:
		err = enc.WriteInt(int64(v))
	case int16:
		err = enc.WriteInt(int64(v))
	case int8:
		err = enc.WriteInt8(v)
	case int:
		err = enc.WriteInt(int64(v))
	case uint64:
		err = enc.WriteUint(uint64(v))
	case uint32:
		err = enc.WriteUint(uint64(v))
	case uint16:
		err = enc.WriteUint(uint64(v))
	case uint8:
		err = enc.WriteUint8(v)
	case uint:
		err = enc.WriteUint(uint64(v))
	case float32:
		err = enc.WriteFloat32(v)
	case float64:
		err = enc.WriteFloat64(v)
	case complex64:
		err = enc.WriteComplex64(v)
	case complex128:
		err = enc.WriteComplex128(v)
	case bool:
		err = enc.WriteBool(v)
	default:
		err = enc.encodeValue(reflect.ValueOf(v))
	}
	enc.NoAutoFlushOnEncode = oldNoFlush
	if !oldNoFlush {
		enc.Flush()
	}
	return err
}

func (enc *Encoder) encodeValue(v reflect.Value) error {
	fn := typeEncoder(v.Type())
	return fn(enc, v)
}

// WriteUint writes v in the smallest possible native size
func (enc *Encoder) WriteUint(v uint64) error {
	if v <= math.MaxUint8 {
		return enc.WriteUint8(uint8(v))
	}
	if v <= math.MaxUint16 {
		return enc.WriteUint16(uint16(v))
	}
	if v <= math.MaxUint32 {
		return enc.WriteUint32(uint32(v))
	}
	return enc.WriteUint64(v)
}

// WriteInt writes u in the smallest possible native size
func (enc *Encoder) WriteInt(v int64) error {
	u := v
	if u < 0 {
		u = -u
	}
	if u <= math.MaxInt8 {
		return enc.WriteInt8(int8(v))
	}
	if u <= math.MaxInt16 {
		return enc.WriteInt16(int16(v))
	}
	if u <= math.MaxInt32 {
		return enc.WriteInt32(int32(v))
	}
	return enc.WriteInt64(v)
}

func (enc *Encoder) WriteBool(v bool) error {
	if v {
		return enc.writeType(BoolTrue)
	}
	return enc.writeType(BoolFalse)

}

func (enc *Encoder) WriteInt8(v int8) (err error) {
	enc.writeType(Int8)
	return enc.w.WriteByte(byte(v))
}

func (enc *Encoder) WriteUint8(v uint8) (err error) {
	enc.writeType(Uint8)
	return enc.w.WriteByte(v)
}

func (enc *Encoder) WriteByte(v byte) (err error) {
	return enc.WriteUint8(v)
}

func (enc *Encoder) WriteUint16(v uint16) error {
	enc.writeType(Uint16)
	_, err := enc.Write((*[2]byte)(unsafe.Pointer(&v))[:2:2])
	return err
}

func (enc *Encoder) WriteInt16(v int16) error {
	enc.writeType(Int16)
	_, err := enc.Write((*[2]byte)(unsafe.Pointer(&v))[:2:2])
	return err
}

func (enc *Encoder) WriteUint32(v uint32) error {
	enc.writeType(Uint32)
	_, err := enc.Write((*[4]byte)(unsafe.Pointer(&v))[:4:4])
	return err
}

func (enc *Encoder) WriteInt32(v int32) error {
	enc.writeType(Int32)
	_, err := enc.Write((*[4]byte)(unsafe.Pointer(&v))[:4:4])
	return err
}

func (enc *Encoder) WriteUint64(v uint64) error {
	enc.writeType(Uint64)
	_, err := enc.Write((*[8]byte)(unsafe.Pointer(&v))[:8:8])
	return err
}

func (enc *Encoder) WriteInt64(v int64) error {
	enc.writeType(Int64)
	_, err := enc.Write((*[8]byte)(unsafe.Pointer(&v))[:8:8])
	return err
}

func (enc *Encoder) WriteFloat32(v float32) error {
	enc.writeType(Float32)
	_, err := enc.Write((*[4]byte)(unsafe.Pointer(&v))[:4:4])
	return err
}

func (enc *Encoder) WriteFloat64(v float64) error {
	enc.writeType(Float64)
	_, err := enc.Write((*[8]byte)(unsafe.Pointer(&v))[:8:8])
	return err
}

func (enc *Encoder) WriteComplex64(v complex64) error {
	enc.writeType(Complex64)
	_, err := enc.Write((*[8]byte)(unsafe.Pointer(&v))[:8:8])
	return err
}

func (enc *Encoder) WriteComplex128(v complex128) error {
	enc.writeType(Complex128)
	_, err := enc.Write((*[16]byte)(unsafe.Pointer(&v))[:16:16])
	return err
}

func (enc *Encoder) WriteBinary(v encoding.BinaryMarshaler) error {
	b, err := v.MarshalBinary()
	if err != nil {
		return err
	}
	enc.writeType(Binary)
	enc.writeLen(len(b))
	_, err = enc.Write(b)
	return err
}

func (enc *Encoder) WriteGob(v gob.GobEncoder) error {
	b, err := v.GobEncode()
	if err != nil {
		return err
	}
	enc.writeType(Gob)
	enc.writeLen(len(b))
	_, err = enc.Write(b)
	return err
}

// Write writes the contents of p into the buffer.
// It allows the Encoder to be used as a regular io.Writer since it takes control of the original w.
func (enc *Encoder) Write(p []byte) (n int, err error) {
	return enc.w.Write(p)
}

// Flush writes any buffered data to the underlying io.Writer.
func (enc *Encoder) Flush() error {
	return enc.w.Flush()
}

func (enc *Encoder) writeLen(ln int) error {
	return enc.WriteUint(uint64(ln))
}

// Marshal is an alias for (sync.Pool'ed) NewEncoder(bytes.NewBuffer()).Encode(v)
func Marshal(v interface{}) ([]byte, error) {
	enc := getEncBuffer()
	err := enc.e.Encode(v)
	enc.e.Flush()
	b := []byte(enc.b.String()) // have to create a copy sadly :(
	putEncBuffer(enc)
	return b, err
}
