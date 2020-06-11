package system

import(
	"testing"

	"strings"
)

func TestLoad(t *testing.T) {
	load, e := AverageLoad(); if e != nil {
		t.Errorf("unexpected error: %v", e)
	}

	loadPay := "1.04 1.05 1.00 1/499 15652"
	loadPayOne := float32(1.04); loadPayFive := float32(1.05); loadPayFifteen := float32(1.00)
	loadPayRunable := uint64(1); loadPayAllEntities := uint64(499); loadPayMostRecentPid := uint64(15652)
	load = &Load{}
	load.scan(strings.NewReader(loadPay))

	if load.String() != loadPay[:15] {
		t.Errorf("expected '%v'\n\t, got\n\t'%v' for load.loadavg!", loadPay[:15], load.loadavg)
	}

	if load.One() != loadPayOne {
		t.Errorf("expected '%v', got '%v' for load.one!", loadPayOne, load.one)
	}

	if load.Five() != loadPayFive {
		t.Errorf("expected '%v', got '%v' for load.five!", loadPayFive, load.five)
	}

	if load.Fifteen() != loadPayFifteen {
		t.Errorf("expected '%v', got '%v' for load.fifteen!", loadPayFifteen, load.fifteen)
	}

	if load.Runable() != loadPayRunable {
		t.Errorf("expected '%v', got '%v' for load.runable!", loadPayRunable, load.runable)
	}

	if load.AllEntities() != loadPayAllEntities {
		t.Errorf("expected '%v', got '%v' for load.allEntities!", loadPayAllEntities, load.allEntities)
	}

	if load.MostRecentPid() != loadPayMostRecentPid {
		t.Errorf("expected '%v', got '%v' for load.mostRecentPid!", loadPayMostRecentPid, load.mostRecentPid)
	}

	if load.Complete() != loadPay {
		t.Errorf("load.Complete expected\n\t'%v', but got\n\t'%v'", loadPay, load.Complete())
	}

	// troll test
	loadPay = ""
	e = load.scan(strings.NewReader(loadPay)); if e == nil {
		t.Error("Load.scan() accepted empty string!")
	}

	if load.Complete() != loadPay {
		t.Errorf("load.Complete expected\n\t'%v', but got\n\t'%v'", loadPay, load.Complete())
	}

	trollTest(t, load, "1.04")
	trollTest(t, load, "1.04 1.05")
	trollTest(t, load, "1.04 1.05 1.00")
	trollTest(t, load, "1.04 1.05 1.00 1/499")
	trollTest(t, load, "1.04 1.05 1.00 1&499")
	trollTest(t, load, "1.041.051.001/49915652")
}

func trollTest(t *testing.T, load *Load, format string) {
	e := load.scan(strings.NewReader(format)); if e == nil {
		t.Errorf("Load.scan() accepted invalid format '%v'", format)
	}
}
