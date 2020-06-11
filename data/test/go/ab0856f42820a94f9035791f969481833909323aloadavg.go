package sysstat

import (
	"os"
	"syscall"
)

// LoadAvg represents load averages for 1 minute, 5 minutes, and 15 minutes.
type LoadAvg struct {
	Load1  float64
	Load5  float64
	Load15 float64
}

// LoadAvgReader is a reader for load averages.
// LoadAvgReader is not safe for concurrent accesses from multiple goroutines.
type LoadAvgReader struct {
	buf [80]byte
}

// NewLoadAvgReader creats a LoadAvgReader.
func NewLoadAvgReader() *LoadAvgReader {
	return new(LoadAvgReader)
}

// Read reads the load average values.
func (r *LoadAvgReader) Read(a *LoadAvg) error {
	fd, err := open([]byte("/proc/loadavg"), os.O_RDONLY, 0)
	if err != nil {
		return err
	}
	defer syscall.Close(fd)

	n, err := syscall.Read(fd, r.buf[:])
	if err != nil {
		return err
	}
	return r.parse(r.buf[:n], a)
}

func (r *LoadAvgReader) parse(buf []byte, a *LoadAvg) error {
	var err error
	a.Load1, err = readFloat64Field(&buf)
	if err != nil {
		return err
	}
	a.Load5, err = readFloat64Field(&buf)
	if err != nil {
		return err
	}
	a.Load15, err = readFloat64Field(&buf)
	return err
}
