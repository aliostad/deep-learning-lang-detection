package geny

import (
	"bytes"
	"context"
	"io"
	"strconv"
)

type file struct {
	code []Code
}

func File(code ...Code) *file {
	return &file{
		code: code,
	}
}

func (f *file) Build(ctx context.Context, w io.Writer) error {
	gc := FromContext(ctx)

	// write the package
	w.Write([]byte("package "))
	w.Write([]byte(gc.Name))
	w.Write([]byte("\n\n"))

	codeBuffer := &bytes.Buffer{}
	for _, c := range f.code {
		c.Build(ctx, codeBuffer)
	}

	// write the imports
	if len(gc.Imports) > 0 {
		w.Write([]byte("import "))
		if len(gc.Imports) > 1 {
			w.Write([]byte("(\n"))
		}
		for path, alias := range gc.Imports {
			if alias != "" {
				w.Write([]byte(alias))
				w.Write([]byte(" "))
			}
			w.Write([]byte(strconv.Quote(path)))
			w.Write([]byte("\n"))
		}
		if len(gc.Imports) > 1 {
			w.Write([]byte(")\n"))
		}
		w.Write([]byte("\n"))
	}

	w.Write(codeBuffer.Bytes())

	return nil

}
