package main

import (
	"testing"
)

func TestCheckLoad(t *testing.T) {
	load := 0.2
	checkGreen := CheckLoad(&load)[0]
	if checkGreen.Status != "green" {
		t.Fatalf("Ivory wasn't green")
	}

	load = 1.2
	checkYellow := CheckLoad(&load)[0]
	if checkYellow.Status != "yellow" {
		t.Fatalf("Ivory wasn't yellow")
	}

	load = 2.2
	checkRed := CheckLoad(&load)[0]
	if checkRed.Status != "red" {
		t.Fatalf("Red wasn't red")
	}

	checkMissing := CheckLoad(nil)[0]
	if checkMissing.Status != "skipped" {
		t.Fatalf("Missing wasn't skipped")
	}

}
