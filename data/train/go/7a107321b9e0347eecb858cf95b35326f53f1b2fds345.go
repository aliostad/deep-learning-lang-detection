// Copyright (c) 2017 The ivi developers. All rights reserved.
// Project site: https://github.com/gotmc/ivi
// Use of this source code is governed by a MIT-style license that
// can be found in the LICENSE.txt file for the project.

/*
Package ds345 implements the IVI driver for the Stanford Research System
DS345 function generator.

State Caching: Not implemented
*/
package ds345

import (
	"github.com/gotmc/ivi"
	"github.com/gotmc/ivi/fgen"
)

// Required to implement the Inherent Capabilities & Attributes
const (
	classSpecMajorVersion = 4
	classSpecMinorVersion = 3
	classSpecRevision     = "5.2"
	groupCapabilities     = "IviFgenBase,IviFgenStdfunc,IviFgenTrigger,IviFgenInternalTrigger,IviFgenBurst"
)

// TODO(mdr): Seems like groupCapabilities should be a []string instead of
// string

var supportedInstrumentModels = []string{
	"DS345",
}

var channelNames = []string{
	"Output",
}

// DS345 provides the IVI driver for a SRS DS345 function generator.
type DS345 struct {
	inst     ivi.Instrument
	Channels []Channel
	ivi.Inherent
}

// New creates a new DS345 IVI Instrument.
func New(inst ivi.Instrument, reset bool) (*DS345, error) {
	outputCount := len(channelNames)
	channels := make([]Channel, outputCount)
	for i, ch := range channelNames {
		baseChannel := fgen.NewChannel(i, ch, inst)
		channels[i] = Channel{baseChannel}
	}
	inherentBase := ivi.InherentBase{
		ClassSpecMajorVersion:     classSpecMajorVersion,
		ClassSpecMinorVersion:     classSpecMinorVersion,
		ClassSpecRevision:         classSpecRevision,
		GroupCapabilities:         groupCapabilities,
		SupportedInstrumentModels: supportedInstrumentModels,
	}
	inherent := ivi.NewInherent(inst, inherentBase)
	fgen := DS345{
		inst:     inst,
		Channels: channels,
		Inherent: inherent,
	}
	if reset {
		err := fgen.Reset()
		return &fgen, err
	}
	return &fgen, nil
}

// Channel represents a repeated capability of an output channel for the
// function generator.
type Channel struct {
	fgen.Channel
}
