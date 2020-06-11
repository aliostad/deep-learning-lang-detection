package msg

import (
	"encoding/binary"
	"io"
	"math"
	"unsafe"
)

var bigend = binary.BigEndian

/* Writer must satisfy Writer and ByteWriter
for speed, should also implement WriteString(s)(n, err).
*bytes.Buffer satisfies this interface, but you may use something
else in a pinch.

Write(), WriteByte(), and WriteString() *cannot* fail, so Writer
must be some kind of buffered writer.	*/
type Writer interface {
	io.ByteWriter
	io.Writer
	WriteString(string) (int, error)
}

func writeMapHeader(w Writer, n uint32) {
	switch {
	case n < 16:
		//fixmap is 1000XXXX: 10000000 OR 0000XXXX - retreive with &0xf
		w.WriteByte(0x80 | byte(n))

	case n < 1<<16-1:
		w.WriteByte(mmap16)
		w.WriteByte(byte(n >> 8))
		w.WriteByte(byte(n))

	default:
		w.WriteByte(mmap32)
		w.WriteByte(byte(n >> 24))
		w.WriteByte(byte(n >> 16))
		w.WriteByte(byte(n >> 8))
		w.WriteByte(byte(n))
	}
}

func writeNil(w Writer) { w.WriteByte(mnil) }

func writeFloat(w Writer, f float64) {
	var is uint32 //float32 bits
	var ls uint64 //float64 bits
	var g float32 //float32 conversion
	var b float64 //float64 abs

	b = math.Abs(f)
	if b > math.MaxFloat32 || b < math.SmallestNonzeroFloat32 {
		//write float64
		w.WriteByte(mfloat64)
		ls = *(*uint64)(unsafe.Pointer(&f))
		w.WriteByte(byte(ls >> 56))
		w.WriteByte(byte(ls >> 48))
		w.WriteByte(byte(ls >> 40))
		w.WriteByte(byte(ls >> 32))
		w.WriteByte(byte(ls >> 24))
		w.WriteByte(byte(ls >> 16))
		w.WriteByte(byte(ls >> 8))
		w.WriteByte(byte(ls))
		return
	} else {
		g = float32(f)
		//write float32
		w.WriteByte(mfloat32)
		is = *(*uint32)(unsafe.Pointer(&g))
		w.WriteByte(byte(is >> 24))
		w.WriteByte(byte(is >> 16))
		w.WriteByte(byte(is >> 8))
		w.WriteByte(byte(is))
		return
	}
}

func writeFloat64(w Writer, f float64) {
	var ls uint64
	w.WriteByte(mfloat64)
	ls = *(*uint64)(unsafe.Pointer(&f))
	w.WriteByte(byte(ls >> 56))
	w.WriteByte(byte(ls >> 48))
	w.WriteByte(byte(ls >> 40))
	w.WriteByte(byte(ls >> 32))
	w.WriteByte(byte(ls >> 24))
	w.WriteByte(byte(ls >> 16))
	w.WriteByte(byte(ls >> 8))
	w.WriteByte(byte(ls))
	return
}

func writeFloat32(w Writer, f float32) {
	var is uint32
	w.WriteByte(mfloat32)
	is = *(*uint32)(unsafe.Pointer(&f))
	w.WriteByte(byte(is >> 24))
	w.WriteByte(byte(is >> 16))
	w.WriteByte(byte(is >> 8))
	w.WriteByte(byte(is))
}

func writeBin(w Writer, b []byte) {
	n := len(b)
	switch {
	case n < 1<<8-1:
		w.WriteByte(mbin8)
		w.WriteByte(byte(n))
	case n < 1<<16-1:
		w.WriteByte(mbin16)
		w.WriteByte(byte(n >> 8))
		w.WriteByte(byte(n))
	default:
		w.WriteByte(mbin32)
		w.WriteByte(byte(n >> 24))
		w.WriteByte(byte(n >> 16))
		w.WriteByte(byte(n >> 8))
		w.WriteByte(byte(n))
	}
	w.Write(b)
}

func writeExt(w Writer, extype int8, b []byte) {
	n := len(b)
	switch {
	case n == 1:
		w.WriteByte(mfixext1)
	case n == 2:
		w.WriteByte(mfixext2)
	case n == 4:
		w.WriteByte(mfixext4)
	case n == 8:
		w.WriteByte(mfixext8)
	case n == 16:
		w.WriteByte(mfixext16)
	case n < 1<<8-1:
		w.WriteByte(mext8)
		w.WriteByte(byte(n))
	case n < 1<<16-1:
		w.WriteByte(mext16)
		w.WriteByte(byte(n >> 8))
		w.WriteByte(byte(n))
	default:
		w.WriteByte(mext32)
		w.WriteByte(byte(n >> 24))
		w.WriteByte(byte(n >> 16))
		w.WriteByte(byte(n >> 8))
		w.WriteByte(byte(n))
	}
	w.WriteByte(byte(extype))
	w.Write(b)
}

func writeBool(w Writer, b bool) {
	if b {
		w.WriteByte(mtrue)
	} else {
		w.WriteByte(mfalse)
	}
}

//requires as much as 5+len(s) bytes
func writeString(w Writer, s string) {
	n := len(s)
	switch {
	//write fixstr
	case n < 32:
		//mask (n & 00011111) OR 1010000 -> 101XXXXX
		w.WriteByte(byte(n&0x1f) | mfixstr)
		io.WriteString(w, s)

	case n < 256:
		w.WriteByte(mstr8)
		w.WriteByte(byte(uint8(n)))
		io.WriteString(w, s)

	case n < 1<<16-1:
		w.WriteByte(mstr16)
		w.WriteByte(byte(n >> 8))
		w.WriteByte(byte(n))
		io.WriteString(w, s)

	default:
		w.WriteByte(mstr32)
		w.WriteByte(byte(n >> 24))
		w.WriteByte(byte(n >> 16))
		w.WriteByte(byte(n >> 8))
		w.WriteByte(byte(n))
		io.WriteString(w, s)

	}
}

//writes the smallest possible encoding of an int64
func writeInt(w Writer, v int64) {
	if v > 0 {
		switch {
		case v < 128:
			//mask 01111111; require leading zero
			w.WriteByte(byte(v & 0x7f))

		//write int8
		case v < 256:
			w.WriteByte(mint8)
			w.WriteByte(byte(v))

		//write int16
		case v < 1<<15-1:
			w.WriteByte(mint16)
			w.WriteByte(byte(v >> 8))
			w.WriteByte(byte(v))

		//write int32
		case v < 1<<31-1:
			w.WriteByte(mint32)
			w.WriteByte(byte(v >> 24))
			w.WriteByte(byte(v >> 16))
			w.WriteByte(byte(v >> 8))
			w.WriteByte(byte(v))

		//write int64
		default:
			w.WriteByte(mint64)
			w.WriteByte(byte(v >> 56))
			w.WriteByte(byte(v >> 48))
			w.WriteByte(byte(v >> 40))
			w.WriteByte(byte(v >> 32))
			w.WriteByte(byte(v >> 24))
			w.WriteByte(byte(v >> 16))
			w.WriteByte(byte(v >> 8))
			w.WriteByte(byte(v))
		}
	} else {
		//v is negative
		switch {
		//try to write nfixint
		case v >= -32:
			w.WriteByte(byte(v))

		//write int16
		case v >= -1<<15:
			w.WriteByte(mint16)
			w.WriteByte(byte(v >> 8))
			w.WriteByte(byte(v))

		//write int32
		case v >= -1<<31:
			w.WriteByte(mint32)
			w.WriteByte(byte(v >> 24))
			w.WriteByte(byte(v >> 16))
			w.WriteByte(byte(v >> 8))
			w.WriteByte(byte(v))

		//write int64
		default:
			w.WriteByte(mint64)
			w.WriteByte(byte(v >> 56))
			w.WriteByte(byte(v >> 48))
			w.WriteByte(byte(v >> 40))
			w.WriteByte(byte(v >> 32))
			w.WriteByte(byte(v >> 24))
			w.WriteByte(byte(v >> 16))
			w.WriteByte(byte(v >> 8))
			w.WriteByte(byte(v))
		}
	}
}

//writes the smallest possible encoding of a uint64
func writeUint(w Writer, v uint64) {
	switch {
	//write positive fixint
	case v < 128:
		w.WriteByte(byte(v & 0x7f))

	//write uint8
	case v < 256:
		w.WriteByte(muint8)
		w.WriteByte(byte(v))

	//write uint16
	case v < 1<<16-1:
		w.WriteByte(muint16)
		w.WriteByte(byte(v >> 8))
		w.WriteByte(byte(v))

	//write uint32
	case v < 1<<32-1:
		w.WriteByte(muint32)
		w.WriteByte(byte(v >> 24))
		w.WriteByte(byte(v >> 16))
		w.WriteByte(byte(v >> 8))
		w.WriteByte(byte(v))

	//write uint64
	default:
		w.WriteByte(muint64)
		w.WriteByte(byte(v >> 56))
		w.WriteByte(byte(v >> 48))
		w.WriteByte(byte(v >> 40))
		w.WriteByte(byte(v >> 32))
		w.WriteByte(byte(v >> 24))
		w.WriteByte(byte(v >> 16))
		w.WriteByte(byte(v >> 8))
		w.WriteByte(byte(v))
	}
}
