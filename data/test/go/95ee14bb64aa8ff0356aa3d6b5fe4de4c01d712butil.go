package util

import (
	"bytes"
	"fmt"
)

func SprintfHex(slice []byte) string {
	const N_COLS = 16

	var buff bytes.Buffer
	buff.WriteRune('\n')
	s := fmt.Sprintf("%x", slice)
	i := 0
	cols := 0
	for _, ch := range s {
		if cols == 8 && i == 0 {
			buff.WriteRune(' ')
		}
		if cols >= N_COLS {
			buff.WriteRune('\n')
			cols = 0
		}
		if cols == 0 && i == 0 {
			buff.WriteRune('\t')
			buff.WriteRune('\t')
		}
		buff.WriteRune(ch)
		i++
		if i >= 2 {
			buff.WriteRune(' ')
			i = 0
			cols++
		}
	}
	return buff.String()
}
