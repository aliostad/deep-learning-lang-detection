package main

import (
	"bytes"
	"fmt"
	"strings"
)

const (
	IndentStr = "----"
	LineEnd   = "\n"
)

type Formatter struct {
	indent int
	buffer bytes.Buffer
}

func (f *Formatter) writeBlock(b *Block) *Formatter {
	for _, s := range b.S {
		f.writeStatement(s)
	}
	return f
}

func (f *Formatter) writeStatement(s *Statement) *Formatter {
	f.writeIndent()

	if s.C != nil {
		f.writeString(strings.TrimSpace(s.C.Text))
	} else {
		f.writeInstruction(s.I)

		if s.B == nil {
			if s.V != nil {
				f.writeString(" = ").writeValue(s.V)
			}
			f.writeString(";")
		} else {
			f.writeString(" {").newLine()
			f.indent++
			f.writeBlock(s.B)
			f.indent--
			f.writeIndent().writeString("}")
		}
	}

	return f.newLine()
}

func (f *Formatter) writeInstruction(ins *Instruction) *Formatter {
	for i, I := range ins.I {
		f.writeString(I.T.Text)
		if i != len(ins.I)-1 {
			f.writeString(" ")
		}
	}
	return f
}

func (f *Formatter) writeValue(v *Value) *Formatter {
	f.writeString(v.I.T.Text)
	if v.K != nil && v.V != nil {
		f.writeString("[" + v.K.T.Text + " = " + v.V.T.Text + "]")
	}
	return f
}

func (f *Formatter) newLine() *Formatter {
	return f.writeString(LineEnd)
}

func (f *Formatter) writeString(s string) *Formatter {
	f.buffer.WriteString(s)
	return f
}

func (f *Formatter) writeIndent() *Formatter {
	for i := 0; i < f.indent; i++ {
		f.buffer.WriteString(IndentStr)
	}
	return f
}

func (f *Formatter) print() {
	fmt.Println(f.buffer.String())
}
