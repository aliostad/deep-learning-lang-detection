package logged

import (
	"bufio"
	"io"
	"sync"
	"unicode/utf8"
)

var hex = "0123456789abcdef"

// NewJSONSerializer creates a new Serializer that writes to the underlying io.Writer
// in a JSON format.
func NewJSONSerializer(w io.Writer) Serializer {
	return &jsonSerializer{
		w: bufio.NewWriter(w),
	}
}

type jsonSerializer struct {
	w  *bufio.Writer
	mu sync.Mutex
}

// Write flushes e to the underlying io.Writer in a JSON format.
func (s *jsonSerializer) Write(e *Entry) error {
	s.mu.Lock()

	s.w.WriteString(`{"timestamp":"`)
	s.w.WriteString(e.Timestamp)
	s.w.WriteString(`","level":"`)
	s.w.WriteString(e.Level)
	s.w.WriteString(`","message":`)
	s.writeJSONString(e.Message)

	if len(e.Data) > 0 {
		s.w.WriteString(`,"data":{`)
		first := true
		for k, v := range e.Data {
			if !first {
				s.w.WriteRune(',')
			}
			first = false
			s.writeJSONString(k)
			s.w.WriteRune(':')
			s.writeJSONString(v)
		}
		s.w.WriteRune('}')
	}

	s.w.WriteRune('}')
	s.w.WriteRune('\n')

	err := s.w.Flush()

	s.mu.Unlock()

	return err
}

func (s *jsonSerializer) writeJSONString(str string) {
	s.w.WriteByte('"')
	start := 0
	for i := 0; i < len(str); {
		if b := str[i]; b < utf8.RuneSelf {
			if safeSet[b] {
				i++
				continue
			}
			if start < i {
				s.w.WriteString(str[start:i])
			}
			switch b {
			case '\\', '"':
				s.w.WriteByte('\\')
				s.w.WriteByte(b)
			case '\n':
				s.w.WriteByte('\\')
				s.w.WriteByte('n')
			case '\r':
				s.w.WriteByte('\\')
				s.w.WriteByte('r')
			case '\t':
				s.w.WriteByte('\\')
				s.w.WriteByte('t')
			default:
				s.w.WriteString(`\u00`)
				s.w.WriteByte(hex[b>>4])
				s.w.WriteByte(hex[b&0xf])
			}
			i++
			start = i
			continue
		}
		c, size := utf8.DecodeRuneInString(str[i:])
		if c == utf8.RuneError && size == 1 {
			if start < i {
				s.w.WriteString(str[start:i])
			}
			s.w.WriteString(`\ufffd`)
			i += size
			start = i
			continue
		}
		i += size
	}
	if start < len(str) {
		s.w.WriteString(str[start:])
	}
	s.w.WriteByte('"')
}
