package httpaccesslog


import (
	"io"
	"net/http"
	"strconv"
)


var (
	space = []byte{' '}
	endl  = []byte{'\n'}
)


func DefaultAccessLogWriter(writer io.Writer, w *ResponseWriter, r *http.Request, trace *Trace) error {

	io.WriteString(writer, "\"request\".\"client-address\"=")
	io.WriteString(writer, strconv.Quote(r.RemoteAddr)) //@TODO: This is inefficient.

	writer.Write(space)

	io.WriteString(writer, "\"request\".\"method\"=")
	io.WriteString(writer, strconv.Quote(r.Method))

	writer.Write(space)

	io.WriteString(writer, "\"request\".\"uri\"=")
	io.WriteString(writer, strconv.Quote(r.URL.String())) //@TODO: This is inefficient.

	writer.Write(space)

	io.WriteString(writer, "\"request\".\"protocol\"=")
	io.WriteString(writer, strconv.Quote(r.Proto)) //@TODO: This is inefficient.

	writer.Write(space)

	io.WriteString(writer, "\"request\".\"host\"=")
	io.WriteString(writer, strconv.Quote(r.Host)) //@TODO: This is inefficient.

	writer.Write(space)

	io.WriteString(writer, "\"request\".\"content-length\"=\"")
	io.WriteString(writer, strconv.FormatInt(int64(r.ContentLength), 10)) //@TODO: This is inefficient.
	io.WriteString(writer, "\"")

	writer.Write(space)

	io.WriteString(writer, `"request"."transfer-encoding"=[`)
	for i, transferEncoding := range r.TransferEncoding {
		if 0 < i {
			io.WriteString(writer, ", ")
		}
		io.WriteString(writer, strconv.Quote(transferEncoding)) //@TODO: This is inefficient.
	}
	io.WriteString(writer, `]`)

	writer.Write(space)

	io.WriteString(writer, "\"response\".\"status-code\"=\"")
	io.WriteString(writer, strconv.FormatInt(int64(w.StatusCode), 10)) //@TODO: This is inefficient.
	io.WriteString(writer, "\"")

	writer.Write(space)

	io.WriteString(writer, "\"response\".\"content-length\"=\"")
	io.WriteString(writer, strconv.FormatInt(int64(w.BodySize), 10)) //@TODO: This is inefficient.
	io.WriteString(writer, "\"")

	writer.Write(space)

	io.WriteString(writer, "\"trace\".\"id\"=")
	io.WriteString(writer, strconv.Quote(string(trace.ID[:]))) //@TODO: This is inefficient.

	writer.Write(space)

	io.WriteString(writer, "\"trace\".\"begin-time\"=")
	io.WriteString(writer, strconv.Quote(trace.BeginTime.String())) //@TODO: This is inefficient.

	writer.Write(space)

	io.WriteString(writer, "\"trace\".\"end-time\"=")
	io.WriteString(writer, strconv.Quote(trace.EndTime.String())) //@TODO: This is inefficient.

	for headerName, headerValues := range r.Header {

		writer.Write(space)

		io.WriteString(writer, "\"request\".\"header\".")
		io.WriteString(writer, strconv.Quote(headerName)) //@TODO: This is inefficient.
		io.WriteString(writer, "=")

		io.WriteString(writer, "[")
		for i, headerValue := range headerValues {
			if 0 < i {
				io.WriteString(writer, ", ")
			}
			io.WriteString(writer, strconv.Quote(headerValue)) //@TODO: This is inefficient.
		}
		io.WriteString(writer, "]")
	}

	for trailerName, trailerValues := range r.Trailer {

		writer.Write(space)

		io.WriteString(writer, "\"request\".\"trailer\".")
		io.WriteString(writer, strconv.Quote(trailerName)) //@TODO: This is inefficient.
		io.WriteString(writer, "=")

		io.WriteString(writer, "[")
		for i, trailerValue := range trailerValues {
			if 0 < i {
				io.WriteString(writer, ", ")
			}
			io.WriteString(writer, strconv.Quote(trailerValue)) //@TODO: This is inefficient.
		}
		io.WriteString(writer, "]")
	}

	writer.Write(endl)

	return nil
}
