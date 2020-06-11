// Copyright 2017 someonegg. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// Package manager manage runtime logic objects.
package manager

import (
	"github.com/someonegg/golog"

	. "server/connector/internal/config"
)

var log = golog.SubLoggerWithFields(golog.RootLogger, "module", "manager")

type ManagerSet struct {
}

func NewManagerSet(conf *ManagerConfT) *ManagerSet {
	t := &ManagerSet{}
	return t
}

func (s *ManagerSet) Close() error {
	return nil
}