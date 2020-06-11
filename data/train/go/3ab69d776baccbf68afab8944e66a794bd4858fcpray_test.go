// Copyright 2015 Francisco Souza. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package main

import (
	"reflect"
	"testing"
)

func TestExpandPackages(t *testing.T) {
	netResult := []string{
		"net",
		"net/http",
		"net/http/cgi",
		"net/http/cookiejar",
		"net/http/fcgi",
		"net/http/httptest",
		"net/http/httputil",
		"net/http/internal",
		"net/http/pprof",
		"net/mail",
		"net/rpc",
		"net/rpc/jsonrpc",
		"net/smtp",
		"net/textproto",
		"net/url",
	}
	var tests = []struct {
		input    []string
		expected []string
	}{
		{input: []string{"database..."}, expected: []string{"database/sql", "database/sql/driver"}},
		{input: []string{"net..."}, expected: netResult},
		{input: []string{"net"}, expected: []string{"net"}},
		{input: []string{"net/mail..."}, expected: []string{"net/mail"}},
		{input: []string{"net/...", "encoding"}, expected: append(netResult, "encoding")},
	}
	for _, test := range tests {
		if got := expandPackages(test.input); !reflect.DeepEqual(got, test.expected) {
			t.Errorf("expandPackages(%v): want %v, got %v.", test.input, test.expected, got)
		}
	}
}
