package enc

import (
	"bufio"
	"strconv"
)

// To36Base creates a string value of service INT id.
func To36Base(exportId uint64) string {
	return strconv.FormatUint(exportId, 36)
}

// EncodeUint64ToString encodes uint64 to the sequence of bytes.
func Sn2Bin(v uint64) string {
	b := make([]byte, 8)
	b[0] = byte(v >> 56)
	b[1] = byte(v >> 48)
	b[2] = byte(v >> 40)
	b[3] = byte(v >> 32)
	b[4] = byte(v >> 24)
	b[5] = byte(v >> 16)
	b[6] = byte(v >> 8)
	b[7] = byte(v)
	return UnsafeBytesToString(b)
}

// DecodeBytesToUnit64 decodes sequence of bytes to uint64.
func DecodeBytesToUnit64(b []byte) uint64 {
	return uint64(b[7]) |
		uint64(b[6])<<8 |
		uint64(b[5])<<16 |
		uint64(b[4])<<24 |
		uint64(b[3])<<32 |
		uint64(b[2])<<40 |
		uint64(b[1])<<48 |
		uint64(b[0])<<56
}

func WriteBool(b *bufio.Writer, v bool) (err error) {
	if v {
		_, err = b.WriteString("?t")
	} else {
		_, err = b.WriteString("?f")
	}
	return err
}

func WriteInt64(b *bufio.Writer, v int64) error {
	err := b.WriteByte(':')
	_, err = b.WriteString(strconv.FormatInt(v, 10))
	return err
}

func WriteString(b *bufio.Writer, v string) error {
	err := b.WriteByte('$')
	_, err = b.WriteString(strconv.Itoa(len(v)))
	err = b.WriteByte(' ')
	_, err = b.WriteString(v)
	return err
}

func WriteBytes(b *bufio.Writer, v []byte) error {
	err := b.WriteByte('$')
	_, err = b.WriteString(strconv.Itoa(len(v)))
	err = b.WriteByte(' ')
	_, err = b.Write(v)
	return err
}

func WriteDict(b *bufio.Writer, dict map[string]interface{}) error {
	err := WriteDictSize(b, len(dict))

	if len(dict) == 0 {
		return nil
	}
	for k, v := range dict {
		err = b.WriteByte(' ')
		err = WriteString(b, k)
		err = b.WriteByte(' ')

		switch t := v.(type) {
		case string:
			err = WriteString(b, t)
		case int:
			err = WriteInt64(b, int64(t))
		case int64:
			err = WriteInt64(b, t)
		case bool:
			err = WriteBool(b, t)
		}

		if err != nil {
			break
		}
	}

	return err
}

func WriteDictSize(b *bufio.Writer, l int) error {
	err := b.WriteByte('%')
	_, err = b.WriteString(strconv.Itoa(l))
	return err
}

func WriteArraySize(b *bufio.Writer, l int) error {
	err := b.WriteByte('*')
	_, err = b.WriteString(strconv.Itoa(l))
	return err
}

func WriteError(b *bufio.Writer, code int64, text string) error {
	_, err := b.WriteString("-ERR ")
	err = WriteInt64(b, code)
	err = b.WriteByte(' ')
	err = WriteString(b, text)
	return err
}
