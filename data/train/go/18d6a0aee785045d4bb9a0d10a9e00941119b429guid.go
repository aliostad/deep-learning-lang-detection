package chatblast

import (
	"bytes"
	"math"
	"math/rand"
	"strconv"
)

func s4() string {
	a := math.Floor(1.0 + rand.Float64()*65536.0)
	b := strconv.FormatInt(int64(a), 16)

	return b[1:]
}

func GUID() string {
	var buffer bytes.Buffer

	buffer.WriteString(s4())
	buffer.WriteString(s4())
	buffer.WriteString("-")
	buffer.WriteString(s4())
	buffer.WriteString("-")
	buffer.WriteString(s4())
	buffer.WriteString("-")
	buffer.WriteString(s4())
	buffer.WriteString("-")
	buffer.WriteString(s4())
	buffer.WriteString(s4())
	buffer.WriteString(s4())

	return buffer.String()

}
