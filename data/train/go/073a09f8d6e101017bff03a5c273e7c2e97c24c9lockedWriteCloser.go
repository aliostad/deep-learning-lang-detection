package gorill

import (
	"io"
	"sync"
)

// LockingWriteCloser is an io.WriteCloser that allows only exclusive access to its Write and Close
// method.
type LockingWriteCloser struct {
	lock sync.Mutex
	iowc io.WriteCloser
}

// NewLockingWriteCloser returns a LockingWriteCloser, that allows only exclusive access to its
// Write and Close method.
//
//   lwc := gorill.NewLockingWriteCloser(os.Stdout)
//   for i := 0; i < 1000; i++ {
//       go func(iow io.Writer, i int) {
//           for j := 0; j < 100; j++ {
//               _, err := iow.Write([]byte("Hello, World, from %d!\n", i))
//               if err != nil {
//                   return
//               }
//           }
//       }(lwc, i)
//   }
func NewLockingWriteCloser(iowc io.WriteCloser) *LockingWriteCloser {
	return &LockingWriteCloser{iowc: iowc}
}

// Write writes data to the underlying io.WriteCloser.
func (lwc *LockingWriteCloser) Write(data []byte) (int, error) {
	lwc.lock.Lock()
	defer lwc.lock.Unlock()
	return lwc.iowc.Write(data)
}

// Close closes the underlying io.WriteCloser.
func (lwc *LockingWriteCloser) Close() error {
	lwc.lock.Lock()
	defer lwc.lock.Unlock()
	return lwc.iowc.Close()
}
