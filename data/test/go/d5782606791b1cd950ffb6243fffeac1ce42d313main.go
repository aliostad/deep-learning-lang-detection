// Copyright (c) 2017 The ivi developers. All rights reserved.
// Project site: https://github.com/gotmc/ivi
// Use of this source code is governed by a MIT-style license that
// can be found in the LICENSE.txt file for the project.

package main

import (
	"log"

	"github.com/gotmc/ivi/fgen"
	"github.com/gotmc/ivi/fgen/agilent/ag33220"
	"github.com/gotmc/lxi"
)

func main() {

	// Create a new LXI device
	dev, err := lxi.NewDevice("TCPIP0::10.12.100.150::5025::SOCKET")
	if err != nil {
		log.Fatalf("NewDevice error: %s", err)
	}
	defer dev.Close()

	// Create a new IVI instance of the Agilent 33220 function generator and
	// reset.
	fg, err := ag33220.New(dev, true)
	if err != nil {
		log.Fatalf("IVI instrument error: %s", err)
	}

	// Channel specific methods can be accessed directly from the instrument
	// using 0-based index to select the desirec channel.
	fg.Channels[0].DisableOutput()
	fg.Channels[0].SetAmplitude(0.4)

	// Alternatively, the channel can be assigned to a variable.
	ch := fg.Channels[0]
	ch.SetStandardWaveform(fgen.Sine)
	ch.SetDCOffset(0.1)
	ch.SetFrequency(2340)

	// Instead of configuring attributes of a standard waveform individually, the
	// standard waveform can be configured using a single method.
	ch.ConfigureStandardWaveform(fgen.RampUp, 0.4, 0.1, 2340, 0)
	ch.EnableOutput()

	// Query the FGen
	freq, err := ch.Frequency()
	if err != nil {
		log.Printf("error querying frequency: %s", err)
	}
	log.Printf("Frequency = %.0f Hz", freq)
	amp, err := ch.Amplitude()
	if err != nil {
		log.Printf("error querying amplitude: %s", err)
	}
	log.Printf("Amplitude = %.3f Vpp", amp)
	wave, err := ch.StandardWaveform()
	if err != nil {
		log.Printf("error querying standard waveform: %s", err)
	}
	log.Printf("Standard waveform = %s", wave)
	mfr, err := fg.InstrumentManufacturer()
	if err != nil {
		log.Printf("error querying instrument manufacturer: %s", err)
	}
	log.Printf("Instrument manufacturer = %s", mfr)
	model, err := fg.InstrumentModel()
	if err != nil {
		log.Printf("error querying instrument model: %s", err)
	}
	log.Printf("Instrument model = %s", model)
	sn, err := fg.InstrumentSerialNumber()
	if err != nil {
		log.Printf("error querying instrument sn: %s", err)
	}
	log.Printf("Instrument S/N = %s", sn)
	fw, err := fg.FirmwareRevision()
	if err != nil {
		log.Printf("error querying firmware revision: %s", err)
	}
	log.Printf("Firmware revision = %s", fw)
}
