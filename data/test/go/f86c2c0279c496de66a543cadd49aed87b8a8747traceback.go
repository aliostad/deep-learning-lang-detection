package debug

import (
	"bytes"
	"strconv"

	"github.com/hirochachacha/plua/object"
)

func writeStackTrace(buf *bytes.Buffer, st *object.StackTrace) {
	buf.WriteString("\n\t")

	var write bool

	if st.Source != "" {
		buf.WriteString(st.Source)
		buf.WriteByte(':')
		write = true
	}

	if st.Line > 0 {
		buf.WriteString(strconv.Itoa(st.Line))
		buf.WriteByte(':')
		write = true
	}

	if write {
		buf.WriteString(" in ")
	}

	buf.WriteString(st.Signature)

	if st.IsTailCall {
		buf.WriteString("\n\t")
		buf.WriteString("(...tail calls...)")
	}
}

func getTraceback(th object.Thread, msg string, level int, hasmsg bool) string {
	buf := new(bytes.Buffer)

	if hasmsg {
		buf.WriteString(msg)
		buf.WriteByte('\n')
	}

	buf.WriteString("stack traceback:")

	tb := th.Traceback(level)

	if len(tb) <= 22 {
		for _, st := range tb {
			writeStackTrace(buf, st)
		}
	} else {
		for _, st := range tb[:10] {
			writeStackTrace(buf, st)
		}
		buf.WriteString("\n\t")
		buf.WriteString("...")
		for _, st := range tb[len(tb)-11:] {
			writeStackTrace(buf, st)
		}
	}

	return buf.String()
}
