package paasio

import (
	"io"
	"sync"
)

type DefaultWriteCounter struct {
	writer io.Writer
	n      int64
	nops   int
	mutex  sync.Mutex
}

func NewWriteCounter(writer io.Writer) WriteCounter {
	return &DefaultWriteCounter{
		writer: writer,
	}
}

func (w *DefaultWriteCounter) WriteCount() (n int64, nops int) {
	w.mutex.Lock()
	defer w.mutex.Unlock()
	return w.n, w.nops
}

func (w *DefaultWriteCounter) Write(p []byte) (n int, err error) {
	w.mutex.Lock()
	defer w.mutex.Unlock()
	w.nops++
	n, err = w.writer.Write(p)
	w.n += int64(n)
	return n, err
}
