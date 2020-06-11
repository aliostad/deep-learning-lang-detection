// Copyright 2013 The gui Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package gui

import (
	. "github.com/mycaosf/winapi"
)

func MsgLoop() {
	var m WinMSG

	for GetMessage(&m, 0, 0, 0) {
		TranslateMessage(&m)
		DispatchMessage(&m)
	}
}

// MsgLoopFilter use f to check accel and so on.
func MsgLoopFilter(f func(m *WinMSG) bool) {
	var m WinMSG

	for GetMessage(&m, 0, 0, 0) {
		if !f(&m) {
			TranslateMessage(&m)
			DispatchMessage(&m)
		}
	}
}
