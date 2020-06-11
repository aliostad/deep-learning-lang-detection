package frm

import (
	"io"
	"strconv"
)

func writeString(w io.Writer, s string) {
	io.WriteString(w, s)
}

func writeQuoted(w io.Writer, s string) {
	writeString(w, "`")
	writeString(w, s)
	writeString(w, "`")
}

func writeOpenParen(w io.Writer) {
	writeString(w, "(")
}

func writeCloseParen(w io.Writer) {
	writeString(w, ")")
}

func writeSpace(w io.Writer) {
	writeString(w, " ")
}

func writeComma(w io.Writer) {
	writeString(w, ",")
}

func writeNumber(w io.Writer, i int) {
	writeString(w, strconv.Itoa(i))
}

func writeParened(w io.Writer, i int) {
	writeOpenParen(w)
	writeNumber(w, i)
	writeCloseParen(w)
}
