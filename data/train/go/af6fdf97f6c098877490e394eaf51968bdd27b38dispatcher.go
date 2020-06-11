// Copyright 2014 The Azul3D Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package al

import (
	"runtime"
)

// OpenAL is actually thread-safe by specification. But just to take extra
// caution to avoid any buggy OpenAL implentations, we only use a single OS
// thread.
//
// This doesn't really harm performance, because in practice OpenAL provides no
// performance benifit for multi-threaded users (e.g. OpenAL soft can only have
// one context per device, etc).

func init() {
	go dispatcher()
}

var dispatchChan = make(chan chan func())

func dispatcher() {
	runtime.LockOSThread()
	defer runtime.UnlockOSThread()
	for {
		ch := <-dispatchChan
		f := <-ch
		f()
		ch <- nil
	}
}

func dispatch(f func()) {
	ch := make(chan func())
	dispatchChan <- ch
	ch <- f
	<-ch
}
