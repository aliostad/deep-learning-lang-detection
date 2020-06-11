package sourcemap

import (
	"io"
)

type (
	RuneReader interface {
		ReadRune() (r rune, size int, err error)
	}
	RuneWriter interface {
		WriteRune(r rune) (size int, err error)
	}
	Segment struct {
		GeneratedLine   int
		GeneratedColumn int
		SourceIndex     int
		SourceLine      int
		SourceColumn    int
		NameIndex       int
	}
)

var (
	hexc = "0123456789abcdef"
)

func encodeString(rw RuneWriter, rr RuneReader) error {
	for {
		r, _, err := rr.ReadRune()
		if err == io.EOF {
			return nil
		} else if err != nil {
			return err
		}
		switch r {
		case '\\', '"':
			rw.WriteRune('\\')
			_, err = rw.WriteRune(r)
		case '\n':
			rw.WriteRune('\\')
			_, err = rw.WriteRune('n')
		case '\r':
			rw.WriteRune('\\')
			_, err = rw.WriteRune('r')
		case '\t':
			rw.WriteRune('\\')
			_, err = rw.WriteRune('t')
		case '\u2028':
			rw.WriteRune('\\')
			rw.WriteRune('u')
			rw.WriteRune('2')
			rw.WriteRune('0')
			rw.WriteRune('2')
			_, err = rw.WriteRune('8')
		case '\u2029':
			rw.WriteRune('\\')
			rw.WriteRune('u')
			rw.WriteRune('2')
			rw.WriteRune('0')
			rw.WriteRune('2')
			_, err = rw.WriteRune('9')
		default:
			if r < 0x20 {
				rw.WriteRune('\\')
				rw.WriteRune('u')
				rw.WriteRune('0')
				rw.WriteRune('0')
				rw.WriteRune(rune(hexc[byte(r)>>4]))
				_, err = rw.WriteRune(rune(hexc[byte(r)&0xF]))
			} else {
				_, err = rw.WriteRune(r)
			}
		}

		if err != nil {
			return err
		}
	}
}
