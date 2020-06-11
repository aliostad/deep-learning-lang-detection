package main

import (
	"io"
	"os"
	"strings"
)

type rot13Reader struct {
	r io.Reader
}

func (rot13 rot13Reader) Read(b []byte) (n int, err error) {
        if b == nil || cap(b) <= 0 {
                return 0, nil
        }

	bytesRead := make([]byte, cap(b))
	n, errInternal := rot13.r.Read(bytesRead)
	if errInternal == nil {
		for i := 0; i < n; i++ {
			b[i] = toRot13(bytesRead[i])
		}
	}

        return n, errInternal
}

func toRot13(b byte) byte {
	switch b {
	case 'A': return 'N'
	case 'B': return 'O'
	case 'C': return 'P'
	case 'D': return 'Q'
	case 'E': return 'R'
	case 'F': return 'S'
	case 'G': return 'T'
	case 'H': return 'U'
	case 'I': return 'V'
	case 'J': return 'W'
	case 'K': return 'X'
	case 'L': return 'Y'
	case 'M': return 'Z'
	case 'N': return 'A'
	case 'O': return 'B'
	case 'P': return 'C'
	case 'Q': return 'D'
	case 'R': return 'E'
	case 'S': return 'F'
	case 'T': return 'G'
	case 'U': return 'H'
	case 'V': return 'I'
	case 'W': return 'J'
	case 'X': return 'K'
	case 'Y': return 'L'
	case 'Z': return 'M'
	case 'a': return 'n'
	case 'b': return 'o'
	case 'c': return 'p'
	case 'd': return 'q'
	case 'e': return 'r'
	case 'f': return 's'
	case 'g': return 't'
	case 'h': return 'u'
	case 'i': return 'v'
	case 'j': return 'w'
	case 'k': return 'x'
	case 'l': return 'y'
	case 'm': return 'z'
	case 'n': return 'a'
	case 'o': return 'b'
	case 'p': return 'c'
	case 'q': return 'd'
	case 'r': return 'e'
	case 's': return 'f'
	case 't': return 'g'
	case 'u': return 'h'
	case 'v': return 'i'
	case 'w': return 'j'
	case 'x': return 'k'
	case 'y': return 'l'
	case 'z': return 'm'
	default: return b
	}
}

func main() {
	s := strings.NewReader("Lbh penpxrq gur pbqr!")
	r := rot13Reader{s}
	io.Copy(os.Stdout, &r)
}

