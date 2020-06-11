package resp

import (
	"io"
	"strconv"
)

var (
	clrf   = []byte("\r\n")
	dash   = []byte("-")
	colon  = []byte(":")
	dollar = []byte("$")
	star   = []byte("*")

	nullString = []byte("$-1\r\n")
)

type errWriter struct {
	w   io.Writer
	n   int
	err error
}

func (e *errWriter) Write(p []byte) (n int, err error) {
	if e.err != nil {
		return 0, e.err
	}
	n, e.err = e.w.Write(p)
	e.n += n
	return n, e.err
}

func Write(w io.Writer, v interface{}) (n int, err error) {
	ew := &errWriter{
		w: w,
	}

	switch x := v.(type) {
	// simple types
	case nil:
		ew.Write(nullString)
	case error:
		ew.Write(dash)
		ew.Write([]byte(x.Error()))
		ew.Write(clrf)
	case int64:
		ew.Write(colon)
		ew.Write([]byte(strconv.FormatInt(x, 10)))
		ew.Write(clrf)
	case string:
		if len(x) == 0 {
			ew.Write(nullString)
		} else {
			ew.Write(dollar)
			ew.Write([]byte(strconv.Itoa(len(x))))
			ew.Write(clrf)
			ew.Write([]byte(x))
			ew.Write(clrf)
		}
	// arrays
	case []interface{}:
		ew.Write(star)
		ew.Write([]byte(strconv.Itoa(len(x))))
		ew.Write(clrf)
		for _, item := range x {
			Write(ew, item)
		}
	}

	return ew.n, ew.err
}
