package protocol

import (
	"bytes"
	"strconv"
)

type McResponse struct {
	Response string
	Values   []McValue
}

type McValue struct {
	Key, Flags string
	//Exptime time.Time
	Data []byte
	// others, cas?
}

// converts McResponse to string to send over wire
func (r McResponse) Protocol() string {
	var b bytes.Buffer

	for i := range r.Values {
		//b.WriteString(fmt.Sprintf("VALUE %s %s %d\r\n", r.Values[i].Key, r.Values[i].Flags, len(r.Values[i].Data)))
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
