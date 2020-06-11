// Copyright 2017 Andreas Pannewitz. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package io

// This file was generated with dotgo
// DO NOT EDIT - Improve the pattern!

import (
	"io"
)

// ReadWriteCloserChan represents a
// bidirectional
// channel
type ReadWriteCloserChan interface {
	ReadWriteCloserROnlyChan // aka "<-chan" - receive only
	ReadWriteCloserSOnlyChan // aka "chan<-" - send only
}

// ReadWriteCloserROnlyChan represents a
// receive-only
// channel
type ReadWriteCloserROnlyChan interface {
	RequestReadWriteCloser() (dat io.ReadWriteCloser)        // the receive function - aka "MyReadWriteCloser := <-MyReadWriteCloserROnlyChan"
	TryReadWriteCloser() (dat io.ReadWriteCloser, open bool) // the multi-valued comma-ok receive function - aka "MyReadWriteCloser, ok := <-MyReadWriteCloserROnlyChan"
}

// ReadWriteCloserSOnlyChan represents a
// send-only
// channel
type ReadWriteCloserSOnlyChan interface {
	ProvideReadWriteCloser(dat io.ReadWriteCloser) // the send function - aka "MyKind <- some ReadWriteCloser"
}

// DChReadWriteCloser is a demand channel
type DChReadWriteCloser struct {
	dat chan io.ReadWriteCloser
	req chan struct{}
}

// MakeDemandReadWriteCloserChan returns
// a (pointer to a) fresh
// unbuffered
// demand channel
func MakeDemandReadWriteCloserChan() *DChReadWriteCloser {
	d := new(DChReadWriteCloser)
	d.dat = make(chan io.ReadWriteCloser)
	d.req = make(chan struct{})
	return d
}

// MakeDemandReadWriteCloserBuff returns
// a (pointer to a) fresh
// buffered (with capacity cap)
// demand channel
func MakeDemandReadWriteCloserBuff(cap int) *DChReadWriteCloser {
	d := new(DChReadWriteCloser)
	d.dat = make(chan io.ReadWriteCloser, cap)
	d.req = make(chan struct{}, cap)
	return d
}

// ProvideReadWriteCloser is the send function - aka "MyKind <- some ReadWriteCloser"
func (c *DChReadWriteCloser) ProvideReadWriteCloser(dat io.ReadWriteCloser) {
	<-c.req
	c.dat <- dat
}

// RequestReadWriteCloser is the receive function - aka "some ReadWriteCloser <- MyKind"
func (c *DChReadWriteCloser) RequestReadWriteCloser() (dat io.ReadWriteCloser) {
	c.req <- struct{}{}
	return <-c.dat
}

// TryReadWriteCloser is the comma-ok multi-valued form of RequestReadWriteCloser and
// reports whether a received value was sent before the ReadWriteCloser channel was closed.
func (c *DChReadWriteCloser) TryReadWriteCloser() (dat io.ReadWriteCloser, open bool) {
	c.req <- struct{}{}
	dat, open = <-c.dat
	return dat, open
}

// TODO(apa): close, cap & len

// SChReadWriteCloser is a supply channel
type SChReadWriteCloser struct {
	dat chan io.ReadWriteCloser
	// req chan struct{}
}

// MakeSupplyReadWriteCloserChan returns
// a (pointer to a) fresh
// unbuffered
// supply channel
func MakeSupplyReadWriteCloserChan() *SChReadWriteCloser {
	d := new(SChReadWriteCloser)
	d.dat = make(chan io.ReadWriteCloser)
	// d.req = make(chan struct{})
	return d
}

// MakeSupplyReadWriteCloserBuff returns
// a (pointer to a) fresh
// buffered (with capacity cap)
// supply channel
func MakeSupplyReadWriteCloserBuff(cap int) *SChReadWriteCloser {
	d := new(SChReadWriteCloser)
	d.dat = make(chan io.ReadWriteCloser, cap)
	// eq = make(chan struct{}, cap)
	return d
}

// ProvideReadWriteCloser is the send function - aka "MyKind <- some ReadWriteCloser"
func (c *SChReadWriteCloser) ProvideReadWriteCloser(dat io.ReadWriteCloser) {
	// .req
	c.dat <- dat
}

// RequestReadWriteCloser is the receive function - aka "some ReadWriteCloser <- MyKind"
func (c *SChReadWriteCloser) RequestReadWriteCloser() (dat io.ReadWriteCloser) {
	// eq <- struct{}{}
	return <-c.dat
}

// TryReadWriteCloser is the comma-ok multi-valued form of RequestReadWriteCloser and
// reports whether a received value was sent before the ReadWriteCloser channel was closed.
func (c *SChReadWriteCloser) TryReadWriteCloser() (dat io.ReadWriteCloser, open bool) {
	// eq <- struct{}{}
	dat, open = <-c.dat
	return dat, open
}

// TODO(apa): close, cap & len
