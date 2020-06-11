// Copyright 2017 Andreas Pannewitz. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package io

// This file was generated with dotgo
// DO NOT EDIT - Improve the pattern!

import (
	"io"
)

// WriteSeekerChan represents a
// bidirectional
// channel
type WriteSeekerChan interface {
	WriteSeekerROnlyChan // aka "<-chan" - receive only
	WriteSeekerSOnlyChan // aka "chan<-" - send only
}

// WriteSeekerROnlyChan represents a
// receive-only
// channel
type WriteSeekerROnlyChan interface {
	RequestWriteSeeker() (dat io.WriteSeeker)        // the receive function - aka "MyWriteSeeker := <-MyWriteSeekerROnlyChan"
	TryWriteSeeker() (dat io.WriteSeeker, open bool) // the multi-valued comma-ok receive function - aka "MyWriteSeeker, ok := <-MyWriteSeekerROnlyChan"
}

// WriteSeekerSOnlyChan represents a
// send-only
// channel
type WriteSeekerSOnlyChan interface {
	ProvideWriteSeeker(dat io.WriteSeeker) // the send function - aka "MyKind <- some WriteSeeker"
}

// DChWriteSeeker is a demand channel
type DChWriteSeeker struct {
	dat chan io.WriteSeeker
	req chan struct{}
}

// MakeDemandWriteSeekerChan returns
// a (pointer to a) fresh
// unbuffered
// demand channel
func MakeDemandWriteSeekerChan() *DChWriteSeeker {
	d := new(DChWriteSeeker)
	d.dat = make(chan io.WriteSeeker)
	d.req = make(chan struct{})
	return d
}

// MakeDemandWriteSeekerBuff returns
// a (pointer to a) fresh
// buffered (with capacity cap)
// demand channel
func MakeDemandWriteSeekerBuff(cap int) *DChWriteSeeker {
	d := new(DChWriteSeeker)
	d.dat = make(chan io.WriteSeeker, cap)
	d.req = make(chan struct{}, cap)
	return d
}

// ProvideWriteSeeker is the send function - aka "MyKind <- some WriteSeeker"
func (c *DChWriteSeeker) ProvideWriteSeeker(dat io.WriteSeeker) {
	<-c.req
	c.dat <- dat
}

// RequestWriteSeeker is the receive function - aka "some WriteSeeker <- MyKind"
func (c *DChWriteSeeker) RequestWriteSeeker() (dat io.WriteSeeker) {
	c.req <- struct{}{}
	return <-c.dat
}

// TryWriteSeeker is the comma-ok multi-valued form of RequestWriteSeeker and
// reports whether a received value was sent before the WriteSeeker channel was closed.
func (c *DChWriteSeeker) TryWriteSeeker() (dat io.WriteSeeker, open bool) {
	c.req <- struct{}{}
	dat, open = <-c.dat
	return dat, open
}

// TODO(apa): close, cap & len

// SChWriteSeeker is a supply channel
type SChWriteSeeker struct {
	dat chan io.WriteSeeker
	// req chan struct{}
}

// MakeSupplyWriteSeekerChan returns
// a (pointer to a) fresh
// unbuffered
// supply channel
func MakeSupplyWriteSeekerChan() *SChWriteSeeker {
	d := new(SChWriteSeeker)
	d.dat = make(chan io.WriteSeeker)
	// d.req = make(chan struct{})
	return d
}

// MakeSupplyWriteSeekerBuff returns
// a (pointer to a) fresh
// buffered (with capacity cap)
// supply channel
func MakeSupplyWriteSeekerBuff(cap int) *SChWriteSeeker {
	d := new(SChWriteSeeker)
	d.dat = make(chan io.WriteSeeker, cap)
	// eq = make(chan struct{}, cap)
	return d
}

// ProvideWriteSeeker is the send function - aka "MyKind <- some WriteSeeker"
func (c *SChWriteSeeker) ProvideWriteSeeker(dat io.WriteSeeker) {
	// .req
	c.dat <- dat
}

// RequestWriteSeeker is the receive function - aka "some WriteSeeker <- MyKind"
func (c *SChWriteSeeker) RequestWriteSeeker() (dat io.WriteSeeker) {
	// eq <- struct{}{}
	return <-c.dat
}

// TryWriteSeeker is the comma-ok multi-valued form of RequestWriteSeeker and
// reports whether a received value was sent before the WriteSeeker channel was closed.
func (c *SChWriteSeeker) TryWriteSeeker() (dat io.WriteSeeker, open bool) {
	// eq <- struct{}{}
	dat, open = <-c.dat
	return dat, open
}

// TODO(apa): close, cap & len
