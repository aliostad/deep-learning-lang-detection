package h

import (
	"bytes"
	"net/url"
)

type Params []KV

func URL(path string, params Params) string {
	var buf bytes.Buffer
	buf.WriteString(path)
	if len(params) > 0 {
		buf.WriteString("?")
		buf.WriteString(url.QueryEscape(params[0].K))
		buf.WriteString("=")
		buf.WriteString(url.QueryEscape(params[0].V))
		for _, kv := range params[1:] {
			buf.WriteString("&")
			buf.WriteString(url.QueryEscape(kv.K))
			buf.WriteString("=")
			buf.WriteString(url.QueryEscape(kv.V))

		}
	}
	return string(buf.Bytes())
}
