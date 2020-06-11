/*
melanzani - converts USB input of guitar devices to MIDI signals
Copyright (C) 2015  Christoph Kober

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

package main

import (
	"github.com/gvalkov/golang-evdev"
	"strings"
	"fmt"
	"os"
)

type GuitarDevice struct {
	inputDevice *evdev.InputDevice
	instrument Instrument
}

func CreateGuitarDevice(deviceName string, instrument Instrument) *GuitarDevice {
	guitar := new(GuitarDevice)
	guitar.instrument = instrument
	guitar.inputDevice = findGuitarDevice(deviceName)
	return guitar
}

func findGuitarDevice(deviceName string) *evdev.InputDevice {
	device := searchGuitarDevice(deviceName)
	if device == nil {
		fmt.Println("Could not find guitar: ", deviceName)
		os.Exit(1)
	}
	return device
}

func searchGuitarDevice(deviceName string) *evdev.InputDevice {
	var guitar *evdev.InputDevice
	devices, _ := evdev.ListInputDevices()
	for _, device := range devices {
		if (strings.Contains(device.Name, deviceName)) {
			guitar = device
			break
		}
	}
	return guitar
}

func (self *GuitarDevice) StartListening() {
	self.listen()
}

func (self *GuitarDevice) listen() {
	for {
		var event *evdev.InputEvent
		var err error

		event, err = self.inputDevice.ReadOne()

		if err != nil {
			fmt.Println("Error: ", err)
			break
		}

		button := BUTTON_NONE
		switch event.Code {
		case evdev.BTN_B:
			button = BUTTON_GREEN
		case evdev.BTN_C:
			button = BUTTON_RED
		case evdev.BTN_A:
			button = BUTTON_YELLOW
		case evdev.BTN_X:
			button = BUTTON_BLUE
		case evdev.BTN_Y:
			button = BUTTON_ORANGE
		case evdev.KEY_W:
			if event.Value == 1 {
				self.instrument.StrumDown()
			} else if event.Value == -1 {
				self.instrument.StrumUp()
			} else {
				self.instrument.ReleaseStrum()
			}
		case evdev.KEY_Q:
			if event.Value == -1 {
				self.instrument.Up()
			} else if event.Value == 1 {
				self.instrument.Down()
			}
		case evdev.BTN_TL2:
			button = BUTTON_SELECT
		case evdev.BTN_TR2:
			button = BUTTON_START
		case evdev.BTN_MODE:
			button = BUTTON_MAIN
		case evdev.MSC_SCAN:
		case evdev.EV_SYN:
		case evdev.EV_REL:
		// ignore
		default:
			fmt.Println("Error: Unknown input", event)
		}

		if button != BUTTON_NONE {
			if event.Value == 1 {
				self.instrument.PressButton(button)
			} else {
				self.instrument.ReleaseButton(button)
			}
		}
	}
}

func (self *GuitarDevice) StopListening() {

}
