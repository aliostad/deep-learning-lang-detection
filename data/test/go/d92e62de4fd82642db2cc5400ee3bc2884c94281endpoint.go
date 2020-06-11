// Copyright (c) 2013 The meeko AUTHORS
//
// Use of this source code is governed by The MIT License
// that can be found in the LICENSE file.

package rpc

import "github.com/meeko/meekod/broker"

// Endpoint represents an RPC endpoint for particular transport and it works
// like a bridge between the remote application and the central RPC handler.
type Endpoint interface {
	broker.Endpoint

	DispatchRequest(receiver []byte, msg Request) error
	DispatchInterrupt(receiver []byte, msg Interrupt) error
	DispatchProgress(msg Progress) error
	DispatchStreamFrame(msg StreamFrame) error
	DispatchReply(msg Reply) error
}
