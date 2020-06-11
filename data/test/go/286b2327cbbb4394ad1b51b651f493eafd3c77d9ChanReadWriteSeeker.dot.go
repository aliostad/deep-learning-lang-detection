// Copyright 2017 Andreas Pannewitz. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package io

// This file was generated with dotgo
// DO NOT EDIT - Improve the pattern!

import (
	"io"
)

// ReadWriteSeekerChan represents a
// bidirectional
// channel
type ReadWriteSeekerChan interface {
	ReadWriteSeekerROnlyChan // aka "<-chan" - receive only
	ReadWriteSeekerSOnlyChan // aka "chan<-" - send only
}

// ReadWriteSeekerROnlyChan represents a
// receive-only
// channel
type ReadWriteSeekerROnlyChan interface {
	RequestReadWriteSeeker() (dat io.ReadWriteSeeker)        // the receive function - aka "MyReadWriteSeeker := <-MyReadWriteSeekerROnlyChan"
	TryReadWriteSeeker() (dat io.ReadWriteSeeker, open bool) // the multi-valued comma-ok receive function - aka "MyReadWriteSeeker, ok := <-MyReadWriteSeekerROnlyChan"
}

// ReadWriteSeekerSOnlyChan represents a
// send-only
// channel
type ReadWriteSeekerSOnlyChan interface {
	ProvideReadWriteSeeker(dat io.ReadWriteSeeker) // the send function - aka "MyKind <- some ReadWriteSeeker"
}

// DChReadWriteSeeker is a demand channel
type DChReadWriteSeeker struct {
	dat chan io.ReadWriteSeeker
	req chan struct{}
}

// MakeDemandReadWriteSeekerChan returns
// a (pointer to a) fresh
// unbuffered
// demand channel
func MakeDemandReadWriteSeekerChan() *DChReadWriteSeeker {
	d := new(DChReadWriteSeeker)
	d.dat = make(chan io.ReadWriteSeeker)
	d.req = make(chan struct{})
	return d
}

// MakeDemandReadWriteSeekerBuff returns
// a (pointer to a) fresh
// buffered (with capacity cap)
// demand channel
func MakeDemandReadWriteSeekerBuff(cap int) *DChReadWriteSeeker {
	d := new(DChReadWriteSeeker)
	d.dat = make(chan io.ReadWriteSeeker, cap)
	d.req = make(chan struct{}, cap)
	return d
}

// ProvideReadWriteSeeker is the send function - aka "MyKind <- some ReadWriteSeeker"
func (c *DChReadWriteSeeker) ProvideReadWriteSeeker(dat io.ReadWriteSeeker) {
	<-c.req
	c.dat <- dat
}

// RequestReadWriteSeeker is the receive function - aka "some ReadWriteSeeker <- MyKind"
func (c *DChReadWriteSeeker) RequestReadWriteSeeker() (dat io.ReadWriteSeeker) {
	c.req <- struct{}{}
	return <-c.dat
}

// TryReadWriteSeeker is the comma-ok multi-valued form of RequestReadWriteSeeker and
// reports whether a received value was sent before the ReadWriteSeeker channel was closed.
func (c *DChReadWriteSeeker) TryReadWriteSeeker() (dat io.ReadWriteSeeker, open bool) {
	c.req <- struct{}{}
	dat, open = <-c.dat
	return dat, open
}

// TODO(apa): close, cap & len

// SChReadWriteSeeker is a supply channel
type SChReadWriteSeeker struct {
	dat chan io.ReadWriteSeeker
	// req chan struct{}
}

// MakeSupplyReadWriteSeekerChan returns
// a (pointer to a) fresh
// unbuffered
// supply channel
func MakeSupplyReadWriteSeekerChan() *SChReadWriteSeeker {
	d := new(SChReadWriteSeeker)
	d.dat = make(chan io.ReadWriteSeeker)
	// d.req = make(chan struct{})
	return d
}

// MakeSupplyReadWriteSeekerBuff returns
// a (pointer to a) fresh
// buffered (with capacity cap)
// supply channel
func MakeSupplyReadWriteSeekerBuff(cap int) *SChReadWriteSeeker {
	d := new(SChReadWriteSeeker)
	d.dat = make(chan io.ReadWriteSeeker, cap)
	// eq = make(chan struct{}, cap)
	return d
}

// ProvideReadWriteSeeker is the send function - aka "MyKind <- some ReadWriteSeeker"
func (c *SChReadWriteSeeker) ProvideReadWriteSeeker(dat io.ReadWriteSeeker) {
	// .req
	c.dat <- dat
}

// RequestReadWriteSeeker is the receive function - aka "some ReadWriteSeeker <- MyKind"
func (c *SChReadWriteSeeker) RequestReadWriteSeeker() (dat io.ReadWriteSeeker) {
	// eq <- struct{}{}
	return <-c.dat
}

// TryReadWriteSeeker is the comma-ok multi-valued form of RequestReadWriteSeeker and
// reports whether a received value was sent before the ReadWriteSeeker channel was closed.
func (c *SChReadWriteSeeker) TryReadWriteSeeker() (dat io.ReadWriteSeeker, open bool) {
	// eq <- struct{}{}
	dat, open = <-c.dat
	return dat, open
}

// TODO(apa): close, cap & len
