package logger

import (
	"io"
	"sync"
)

// NewSyncWriteCloser returns a new sync write closer.
func NewSyncWriteCloser(innerWriter io.WriteCloser) *SyncWriteCloser {
	return &SyncWriteCloser{
		innerWriter: innerWriter,
		syncRoot:    &sync.Mutex{},
	}
}

// SyncWriteCloser wraps a write closer.
type SyncWriteCloser struct {
	innerWriter io.WriteCloser
	syncRoot    *sync.Mutex
}

// Write writes the given bytes to the inner writer.
func (sw *SyncWriteCloser) Write(buffer []byte) (int, error) {
	sw.syncRoot.Lock()
	defer sw.syncRoot.Unlock()

	return sw.innerWriter.Write(buffer)
}

// Close closes the file handle.
func (sw *SyncWriteCloser) Close() error {
	return sw.innerWriter.Close()
}
