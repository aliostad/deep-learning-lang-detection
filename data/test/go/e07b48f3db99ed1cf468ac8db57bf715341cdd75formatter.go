package jsontest

import (
	"bytes"
	"encoding/json"
	"fmt"
	"github.com/jban332/kin-log"
	"strings"
)

var (
	BeginTitle = "\x1b[4m"
	EndTitle   = "\x1b[0m"
)

var DefaultFormatter log.Formatter = &Formatter{}

type Formatter struct{}

const prefix = "\n  "

func (formatter *Formatter) Format(message log.Message) ([]byte, error) {
	w := bytes.NewBuffer(make([]byte, 0, 255))
	w.WriteString(message.Message)
	for _, field := range message.Fields {
		w.WriteString("\n\n")
		w.WriteString(BeginTitle)
		w.WriteString(field.Name)
		w.WriteString(EndTitle)
		value := field.GetValue()
		switch value := value.(type) {
		case string:
			w.WriteString("\n")
			w.WriteString(prefix)
			w.WriteString(strings.Replace(value, "\n", prefix, -1))
		default:
			data, err := json.MarshalIndent(value, prefix[1:], "  ")
			if err != nil {
				w.WriteString(fmt.Sprintf(" (json serialization failed for '%T')\n", value))
				w.WriteString(prefix)
				w.WriteString(strings.Replace(err.Error(), "\n", prefix, -1))
				if data, ok := value.(json.RawMessage); ok {
					w.WriteString(prefix)
					w.WriteString("Raw JSON: \n")
					w.WriteString(prefix)
					w.WriteString(strings.Replace(string(data), "\n", prefix+"  ", -1))
				}
			} else {
				w.WriteString("\n")
				w.WriteString(prefix)
				w.Write(data)
			}
		}
	}
	return w.Bytes(), nil
}
