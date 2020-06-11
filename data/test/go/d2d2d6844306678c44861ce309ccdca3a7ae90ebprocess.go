package matrix

import (
	"bytes"
	"io"
	"os"
)

// Process represents simulated process state
type Process struct {
	args           []string
	done           chan struct{}
	output         *bytes.Buffer
	stderr, stdout *os.File
}

// CaptureProcess captures the current process state and provides simulated
// state useful for testing. The original process state is returned when
// Restore() is called.
func CaptureProcess() *Process {
	process := &Process{
		args:   os.Args,
		done:   make(chan struct{}, 0),
		output: new(bytes.Buffer),
		stderr: os.Stderr,
		stdout: os.Stdout,
	}

	reader, writer, _ := os.Pipe()

	os.Args = []string{"test"}
	os.Stderr = writer
	os.Stdout = writer

	go func() {
		io.Copy(process.output, reader)
		close(process.done)
	}()

	return process
}

// Output returns the combined data written to both stdout and stderr
func (process *Process) Output() string {
	return process.output.String()
}

// Restore returns the process to it's original state before being captured
func (process *Process) Restore() {
	os.Stdout.Close()
	<-process.done

	os.Args = process.args
	os.Stderr = process.stderr
	os.Stdout = process.stdout
}

// SetArgs sets the process arguments
func (process *Process) SetArgs(values ...string) {
	os.Args = values
}
