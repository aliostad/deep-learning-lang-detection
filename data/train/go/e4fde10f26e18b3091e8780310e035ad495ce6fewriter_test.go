package jsonwriter

import (
	"bytes"
	"encoding/json"
	"testing"
)

func TestWriter(t *testing.T) {
	var buf bytes.Buffer
	w := New(&buf)

	w.WriteObjectStart()
	w.WriteKey("foobar")
	w.WriteObjectStart()
	w.WriteKey("bar")
	w.WriteString("baz")

	w.WriteComma()

	w.WriteKey("lalala")
	w.WriteArrayStart()
	for i := int64(0); i < 6; i++ {
		w.WriteInt64(i)
		if i+1 < 6 {
			w.WriteComma()
		}
	}
	w.WriteArrayEnd()

	w.WriteComma()

	w.WriteKey("xyz")
	w.WriteRawMessage(json.RawMessage(`{"a":true,"b":100.0}`))

	w.WriteComma()

	w.WriteKey("number")
	w.WriteFloat64(23.3)

	w.WriteComma()

	w.WriteKey("boolean")
	w.WriteBool(false)

	w.WriteObjectEnd()
	w.WriteObjectEnd()
	w.Flush()

	const expected = `{"foobar":{"bar":"baz","lalala":[0,1,2,3,4,5],"xyz":{"a":true,"b":100.0},"number":23.3,"boolean":false}}`

	if buf.String() != expected {
		t.Fatalf("result %s != expected %s", buf.String(), expected)
	}
}
