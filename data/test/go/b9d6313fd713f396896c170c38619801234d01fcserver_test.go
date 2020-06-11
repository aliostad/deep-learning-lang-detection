package main

import (
	"strings"
	"testing"
)

type fixtureBroker struct {
	in          string
	out         []string
	expectError bool
}

func TestKafkaBrokersFlag(t *testing.T) {
	fixtures := []fixtureBroker{
		fixtureBroker{"", nil, true},
		fixtureBroker{"   ", nil, true},
		fixtureBroker{"foo:9", nil, true},
		fixtureBroker{"kafka://", nil, true},
		fixtureBroker{"kafka://1", nil, true},
		fixtureBroker{"kafka://foo", nil, true},
		fixtureBroker{"kafka://foo;9", nil, true},
		fixtureBroker{"kafka://foo:9", []string{"foo:9"}, false},
		fixtureBroker{"kafka://,foo:9", []string{"foo:9"}, false},
		fixtureBroker{"kafka://foo:9,", []string{"foo:9"}, false},
		fixtureBroker{" kafka://foo:9", []string{"foo:9"}, false},
		fixtureBroker{" kafka://foo:9 ", []string{"foo:9"}, false},
		fixtureBroker{"kafka://foo:9,bar:9", []string{"foo:9", "bar:9"}, false},
		fixtureBroker{"kafka://foo:9,,bar:9", []string{"foo:9", "bar:9"}, false},
		fixtureBroker{"kafka://foo:9,bar:9,", []string{"foo:9", "bar:9"}, false},
	}

	for _, fix := range fixtures {
		fkb := &flagKafkaBrokers{}
		err := fkb.Set(fix.in)
		if fix.expectError && err == nil {
			t.Errorf("Failed: '%s'. Expected error, got none.", fix.in)
		}
		expect := strings.Join(fix.out, ";")
		got := strings.Join(fkb.brokers, ";")
		if expect != got {
			t.Errorf("Failed: '%s'. Expected: %s, got: %s", fix.in, expect, got)
		}
	}
}
