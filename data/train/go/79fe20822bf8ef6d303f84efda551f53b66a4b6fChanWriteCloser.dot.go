// Copyright 2017 Andreas Pannewitz. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package io

// This file was generated with dotgo
// DO NOT EDIT - Improve the pattern!

import (
	"io"
)

// WriteCloserChan represents a
// bidirectional
// channel
type WriteCloserChan interface {
	WriteCloserROnlyChan // aka "<-chan" - receive only
	WriteCloserSOnlyChan // aka "chan<-" - send only
}

// WriteCloserROnlyChan represents a
// receive-only
// channel
type WriteCloserROnlyChan interface {
	RequestWriteCloser() (dat io.WriteCloser)        // the receive function - aka "MyWriteCloser := <-MyWriteCloserROnlyChan"
	TryWriteCloser() (dat io.WriteCloser, open bool) // the multi-valued comma-ok receive function - aka "MyWriteCloser, ok := <-MyWriteCloserROnlyChan"
}

// WriteCloserSOnlyChan represents a
// send-only
// channel
type WriteCloserSOnlyChan interface {
	ProvideWriteCloser(dat io.WriteCloser) // the send function - aka "MyKind <- some WriteCloser"
}

// DChWriteCloser is a demand channel
type DChWriteCloser struct {
	dat chan io.WriteCloser
	req chan struct{}
}

// MakeDemandWriteCloserChan returns
// a (pointer to a) fresh
// unbuffered
// demand channel
func MakeDemandWriteCloserChan() *DChWriteCloser {
	d := new(DChWriteCloser)
	d.dat = make(chan io.WriteCloser)
	d.req = make(chan struct{})
	return d
}

// MakeDemandWriteCloserBuff returns
// a (pointer to a) fresh
// buffered (with capacity cap)
// demand channel
func MakeDemandWriteCloserBuff(cap int) *DChWriteCloser {
	d := new(DChWriteCloser)
	d.dat = make(chan io.WriteCloser, cap)
	d.req = make(chan struct{}, cap)
	return d
}

// ProvideWriteCloser is the send function - aka "MyKind <- some WriteCloser"
func (c *DChWriteCloser) ProvideWriteCloser(dat io.WriteCloser) {
	<-c.req
	c.dat <- dat
}

// RequestWriteCloser is the receive function - aka "some WriteCloser <- MyKind"
func (c *DChWriteCloser) RequestWriteCloser() (dat io.WriteCloser) {
	c.req <- struct{}{}
	return <-c.dat
}

// TryWriteCloser is the comma-ok multi-valued form of RequestWriteCloser and
// reports whether a received value was sent before the WriteCloser channel was closed.
func (c *DChWriteCloser) TryWriteCloser() (dat io.WriteCloser, open bool) {
	c.req <- struct{}{}
	dat, open = <-c.dat
	return dat, open
}

// TODO(apa): close, cap & len

// SChWriteCloser is a supply channel
type SChWriteCloser struct {
	dat chan io.WriteCloser
	// req chan struct{}
}

// MakeSupplyWriteCloserChan returns
// a (pointer to a) fresh
// unbuffered
// supply channel
func MakeSupplyWriteCloserChan() *SChWriteCloser {
	d := new(SChWriteCloser)
	d.dat = make(chan io.WriteCloser)
	// d.req = make(chan struct{})
	return d
}

// MakeSupplyWriteCloserBuff returns
// a (pointer to a) fresh
// buffered (with capacity cap)
// supply channel
func MakeSupplyWriteCloserBuff(cap int) *SChWriteCloser {
	d := new(SChWriteCloser)
	d.dat = make(chan io.WriteCloser, cap)
	// eq = make(chan struct{}, cap)
	return d
}

// ProvideWriteCloser is the send function - aka "MyKind <- some WriteCloser"
func (c *SChWriteCloser) ProvideWriteCloser(dat io.WriteCloser) {
	// .req
	c.dat <- dat
}

// RequestWriteCloser is the receive function - aka "some WriteCloser <- MyKind"
func (c *SChWriteCloser) RequestWriteCloser() (dat io.WriteCloser) {
	// eq <- struct{}{}
	return <-c.dat
}

// TryWriteCloser is the comma-ok multi-valued form of RequestWriteCloser and
// reports whether a received value was sent before the WriteCloser channel was closed.
func (c *SChWriteCloser) TryWriteCloser() (dat io.WriteCloser, open bool) {
	// eq <- struct{}{}
	dat, open = <-c.dat
	return dat, open
}

// TODO(apa): close, cap & len
