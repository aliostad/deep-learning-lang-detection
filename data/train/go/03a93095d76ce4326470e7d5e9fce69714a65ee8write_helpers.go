package logger

import (
	"fmt"
	"net/http"
	"strconv"
	"time"
)

// WriteEventf is a helper for creating new logging messasges.
func WriteEventf(writer *Writer, ts TimeSource, event Event, color AnsiColorCode, format string, args ...interface{}) {
	buffer := writer.GetBuffer()
	defer writer.PutBuffer(buffer)

	buffer.WriteString(writer.FormatEvent(event, color))
	buffer.WriteRune(RuneSpace)
	buffer.WriteString(fmt.Sprintf(format, args...))
	buffer.WriteRune(RuneSpace)

	writer.WriteWithTimeSource(ts, buffer.Bytes())
}

// WriteRequestStart is a helper method to write request start events to a writer.
func WriteRequestStart(writer *Writer, ts TimeSource, req *http.Request) {
	buffer := writer.GetBuffer()
	defer writer.PutBuffer(buffer)

	buffer.WriteString(writer.FormatEvent(EventWebRequestStart, ColorGreen))
	buffer.WriteRune(RuneSpace)
	buffer.WriteString(GetIP(req))
	buffer.WriteRune(RuneSpace)
	buffer.WriteString(writer.Colorize(req.Method, ColorBlue))
	buffer.WriteRune(RuneSpace)
	buffer.WriteString(req.URL.Path)

	writer.WriteWithTimeSource(ts, buffer.Bytes())
}

// WriteRequest is a helper method to write request complete events to a writer.
func WriteRequest(writer *Writer, ts TimeSource, req *http.Request, statusCode, contentLengthBytes int, elapsed time.Duration) {
	buffer := writer.GetBuffer()
	defer writer.PutBuffer(buffer)

	buffer.WriteString(writer.FormatEvent(EventWebRequest, ColorGreen))
	buffer.WriteRune(RuneSpace)
	buffer.WriteString(GetIP(req))
	buffer.WriteRune(RuneSpace)
	buffer.WriteString(writer.Colorize(req.Method, ColorBlue))
	buffer.WriteRune(RuneSpace)
	buffer.WriteString(req.URL.Path)
	buffer.WriteRune(RuneSpace)
	buffer.WriteString(writer.ColorizeByStatusCode(statusCode, strconv.Itoa(statusCode)))
	buffer.WriteRune(RuneSpace)
	buffer.WriteString(elapsed.String())
	buffer.WriteRune(RuneSpace)
	buffer.WriteString(File.FormatSize(contentLengthBytes))

	writer.WriteWithTimeSource(ts, buffer.Bytes())
}

// WriteRequestBody is a helper method to write request start events to a writer.
func WriteRequestBody(writer *Writer, ts TimeSource, body []byte) {
	buffer := writer.GetBuffer()
	defer writer.PutBuffer(buffer)
	buffer.WriteString("[" + writer.Colorize(string(EventWebRequestPostBody), ColorGreen) + "]")
	buffer.WriteRune(RuneSpace)
	buffer.Write(body)
	writer.WriteWithTimeSource(ts, buffer.Bytes())
}

// WriteResponseBody is a helper method to write request start events to a writer.
func WriteResponseBody(writer *Writer, ts TimeSource, body []byte) {
	buffer := writer.GetBuffer()
	defer writer.PutBuffer(buffer)
	buffer.WriteString("[" + writer.Colorize(string(EventWebResponse), ColorGreen) + "]")
	buffer.WriteRune(RuneSpace)
	buffer.Write(body)
	writer.WriteWithTimeSource(ts, buffer.Bytes())
}
