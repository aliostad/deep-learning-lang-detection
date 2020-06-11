package callbackwriter

import (
	"io"
)

type Writer struct {
	backend io.WriteCloser

	write func([]byte)
	close func()
}

func New(
	backend io.WriteCloser,
	write func([]byte),
	close func(),
) *Writer {
	return &Writer{
		backend: backend,
		write:   write,
		close:   close,
	}
}

func (writer *Writer) Write(data []byte) (int, error) {
	if writer.write != nil {
		writer.write(data)
	}

	return writer.backend.Write(data)
}

func (writer *Writer) Close() error {
	if writer.close != nil {
		writer.close()
	}

	return writer.backend.Close()
}
