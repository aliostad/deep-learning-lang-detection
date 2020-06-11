// Copyright © 2015-2016 Platina Systems, Inc. All rights reserved.
// Use of this source code is governed by the GPL-2 license described in the
// LICENSE file.

package proc

import (
	"io"
	"os"
)

// usage: proc.Load(INTERFACE).FromFile(NAME)
func Load(l Loader) load { return load(l.(Loader).Load) }

type Loader interface {
	Load(io.Reader) error
}

type load func(io.Reader) error

func (load load) FromFile(name string) error {
	f, err := os.Open(name)
	if err == nil {
		defer f.Close()
		err = load(f)
	}
	return err
}
