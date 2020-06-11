package memcache

import (
	"bytes"
	"strconv"
)

type MCRes struct {
	Response string
	Values   []MCValue
}

type MCValue struct {
	Key, Flags string
	Data       []byte
}

func (r MCRes) Protocol() string {
	var b bytes.Buffer
	for i := range r.Values {
		b.WriteString("VALUE ")
		b.WriteString(r.Values[i].Key)
		b.WriteString(" ")
		b.WriteString(r.Values[i].Flags)
		b.WriteString(" ")
		b.WriteString(strconv.Itoa(len(r.Values[i].Data)))
		b.WriteString("\r\n")

		b.Write(r.Values[i].Data)
		b.WriteString("\r\n")
	}
	b.WriteString(r.Response)
	b.WriteString("\r\n")
	return b.String()
}
