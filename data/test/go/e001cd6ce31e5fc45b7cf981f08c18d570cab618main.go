// Copyright (c) 2017 The ivi developers. All rights reserved.
// Project site: https://github.com/gotmc/ivi
// Use of this source code is governed by a MIT-style license that
// can be found in the LICENSE.txt file for the project.

package main

import (
	"log"
	"time"

	"github.com/gotmc/ivi/dcpwr"
	"github.com/gotmc/ivi/dcpwr/kikusui/pmx"
	"github.com/gotmc/lxi"
)

func main() {

	// Create a new LXI device
	dev, err := lxi.NewDevice("TCPIP0::10.12.100.154::5025::SOCKET")
	if err != nil {
		log.Fatalf("NewDevice error: %s", err)
	}
	defer dev.Close()

	// Create a new IVI instance of the KIKUSUI PMW power supply and reset.
	dcp, err := pmx.New(dev, true)
	if err != nil {
		log.Fatalf("IVI instrument error: %s", err)
	}
	dcp.Reset()

	// Alternatively, the channel can be assigned to a variable.
	ch := dcp.Channels[0]
	ch.DisableOutput()
	ch.SetVoltageLevel(50)
	ch.ConfigureCurrentLimit(dcpwr.Trip, 0.25)
	// The above command is the same as the following two:
	// ch.SetCurrentLimitBehavior(dcpwr.Trip)
	// ch.SetCurrentLimit(0.25)
	ch.ConfigureOVP(true, 60)
	// The aove command is the same as the following two:
	// ch.SetOVPEnabled(true)
	// ch.SetOVPLimit(60)
	ch.EnableOutput()

	// Let the power supply settle before we query it.
	time.Sleep(500 * time.Millisecond)
	v, err := ch.VoltageLevel()
	if err != nil {
		log.Printf("error querying voltage level: %s", err)
	}
	log.Printf("Voltage limit = %.0f V", v)
	measured, err := ch.MeasureVoltage()
	if err != nil {
		log.Printf("error measuriing the voltage: %s", err)
	}
	log.Printf("Measured voltage = %.3f V", measured)

	// Get information about the power supply
	mfr, err := dcp.InstrumentManufacturer()
	if err != nil {
		log.Printf("error querying instrument manufacturer: %s", err)
	}
	log.Printf("Instrument manufacturer = %s", mfr)
	model, err := dcp.InstrumentModel()
	if err != nil {
		log.Printf("error querying instrument model: %s", err)
	}
	log.Printf("Instrument model = %s", model)
	sn, err := dcp.InstrumentSerialNumber()
	if err != nil {
		log.Printf("error querying instrument sn: %s", err)
	}
	log.Printf("Instrument S/N = %s", sn)
	fw, err := dcp.FirmwareRevision()
	if err != nil {
		log.Printf("error querying firmware revision: %s", err)
	}
	log.Printf("Firmware revision = %s", fw)
}
