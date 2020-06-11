package endibuf

import (
	"encoding/binary"
	"math"
)

// WriteData is expand of 'binary.Write'
// input : valid type of binary.Write and others(string, float32, float64 *string, *float32, *flot64, []string, []float32, []float64)
func (w *Writer) WriteData(data interface{}) (err error) {
	switch data := data.(type) {
	case string:
		err = w.WriteCString(data)
	case *string:
		err = w.WriteCString(*data)
	case []string:
		for i := range data {
			err = w.WriteCString(data[i])
			if err != nil {
				return
			}
		}
	case float32:
		err = w.WriteFloat32(data)
	case *float32:
		err = w.WriteFloat32(*data)
	case []float32:
		for i := range data {
			err = w.WriteFloat32(data[i])
			if err != nil {
				return
			}
		}
	case float64:
		err = w.WriteFloat64(data)
	case *float64:
		err = w.WriteFloat64(*data)
	case []float64:
		for i := range data {
			err = w.WriteFloat64(data[i])
			if err != nil {
				return
			}
		}
	case int8, int16, int32, int64,
		uint8, uint16, uint32, uint64,
		*int8, *int16, *int32, *int64,
		*uint8, *uint16, *uint32, *uint64,
		[]int8, []int16, []int32, []int64,
		[]uint8, []uint16, []uint32, []uint64:
		err = binary.Write(w, w.Endian, data)
	}
	return
}

// WriteCString return string (append zero byte)
func (w *Writer) WriteCString(line string) (err error) {
	return w.WriteString(line, byte(0))
}

// WriteString return string (append zero byte)
func (w *Writer) WriteString(line string, delim byte) (err error) {
	line += string(delim)
	b := []byte(line)
	_, err = w.Write(b)
	return
}

// WriteByte return one-byte
func (w *Writer) WriteByte(data byte) error {
	buf := []byte{data}
	return w.WriteBytes(buf)
}

// WriteBytes return bytes
func (w *Writer) WriteBytes(data []byte) error {
	_, err := w.Write(data)
	return err
}

// WriteInt8 return int8
func (w *Writer) WriteInt8(data int8) error {
	return w.WriteData(data)
}

// WriteInt16 return int16
func (w *Writer) WriteInt16(data int16) error {
	return w.WriteData(data)
}

// WriteInt32 return int32
func (w *Writer) WriteInt32(data int32) error {
	return w.WriteData(data)
}

// WriteInt64 return int64
func (w *Writer) WriteInt64(data int64) error {
	return w.WriteData(data)
}

// WriteUint8 return uint8
func (w *Writer) WriteUint8(data uint8) error {
	return w.WriteData(data)
}

// WriteUint16 return uint16
func (w *Writer) WriteUint16(data uint16) error {
	return w.WriteData(data)
}

// WriteUint32 return uint32
func (w *Writer) WriteUint32(data uint32) error {
	return w.WriteData(data)
}

// WriteUint64 return uint64
func (w *Writer) WriteUint64(data uint64) error {
	return w.WriteData(data)
}

// WriteFloat32 return float32
func (w *Writer) WriteFloat32(data float32) error {
	tmp := math.Float32bits(data)
	return binary.Write(w, w.Endian, tmp)
}

// WriteFloat64 return float64
func (w *Writer) WriteFloat64(data float64) error {
	tmp := math.Float64bits(data)
	return binary.Write(w, w.Endian, tmp)
}
