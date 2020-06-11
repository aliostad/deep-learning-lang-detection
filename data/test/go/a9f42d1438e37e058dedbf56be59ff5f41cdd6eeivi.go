// Copyright (c) 2017 The ivi developers. All rights reserved.
// Project site: https://github.com/gotmc/ivi
// Use of this source code is governed by a MIT-style license that
// can be found in the LICENSE.txt file for the project.

package ivi

// Instrument provides the interface required for all IVI Instruments.
type Instrument interface {
	Read(p []byte) (n int, err error)
	Write(p []byte) (n int, err error)
	StringWriter
	Querier
}

// StringWriter provides the interface to write a string.
type StringWriter interface {
	WriteString(s string) (n int, err error)
}

// Querier provides the interface to query using a given string and provide the
// resultant string.
type Querier interface {
	Query(s string) (value string, err error)
}
