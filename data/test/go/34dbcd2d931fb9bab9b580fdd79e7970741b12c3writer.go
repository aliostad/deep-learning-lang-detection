package io

import "io"

// NewWriter will return a new asynchronous writer
func NewWriter(r io.Writer) *Writer {
	return &Writer{r}
}

// Writer is an asynchronous wrapper for an io.Writer
type Writer struct {
	// Internal writer
	w io.Writer
}

// Write will write
func (w *Writer) Write(b []byte) (n int, err error) {
	return write(w.w, b)
}

// WriteAsync will write asynchronously
func (w *Writer) WriteAsync(b []byte) <-chan *RWResp {
	return writeAsync(w.w, b)
}

// NewWriteCloser will return a new asynchronous write closer
func NewWriteCloser(wc io.WriteCloser) *WriteCloser {
	return &WriteCloser{wc}
}

// WriteCloser is an asynchronous wrapper for an io.WriteCloser
type WriteCloser struct {
	// Internal write closer
	wc io.WriteCloser
}

// Write will write
func (wc *WriteCloser) Write(b []byte) (n int, err error) {
	return write(wc.wc, b)
}

// WriteAsync will write asynchronously
func (wc *WriteCloser) WriteAsync(b []byte) <-chan *RWResp {
	return writeAsync(wc.wc, b)
}

// Close will close
func (wc *WriteCloser) Close() (err error) {
	return close(wc.wc)
}

// CloseAsync will close asynchronously
func (wc *WriteCloser) CloseAsync() <-chan error {
	return closeAsync(wc.wc)
}
