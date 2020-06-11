package eval

import (
	"bytes"
	"strconv"
)

func (v Var) String() string {
	return string(v)
}

func (l literal) String() string {
	return strconv.FormatFloat(float64(l), 'f', 6, 64)
}

func (u unary) String() string {
	var buf bytes.Buffer
	buf.WriteRune(u.op)
	buf.WriteString(u.x.String())
	return buf.String()
}

func (b binary) String() string {
	var buf bytes.Buffer
	buf.WriteString("(")
	buf.WriteString(b.x.String())
	buf.WriteString(" ")
	buf.WriteRune(b.op)
	buf.WriteString(" ")
	buf.WriteString(b.y.String())
	buf.WriteString(")")
	return buf.String()
}

func (c call) String() string {
	buf := new(bytes.Buffer)
	buf.WriteString(c.fn)
	buf.WriteString("(")
	for i, e := range c.args {
		buf.WriteString(e.String())
		if i != len(c.args)-1 {
			buf.WriteString(", ")
		} else {
			buf.WriteString(")")
		}
	}
	return buf.String()
}
