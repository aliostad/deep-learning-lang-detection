package pubip

import (
	"net"
	"reflect"
	"testing"
)

func TestIsValidate(t *testing.T) {
	tests := []struct {
		input    []net.IP
		expected net.IP
	}{
		{nil, nil},
		{[]net.IP{}, nil},
		{[]net.IP{net.ParseIP("192.168.1.1")}, nil},
		{[]net.IP{net.ParseIP("192.168.1.1"), net.ParseIP("192.168.1.1")}, nil},
		{[]net.IP{net.ParseIP("192.168.1.1"), net.ParseIP("192.168.1.1"), net.ParseIP("192.168.1.1")}, net.ParseIP("192.168.1.1")},
		{[]net.IP{net.ParseIP("192.168.1.1"), net.ParseIP("192.168.1.2")}, nil},
		{[]net.IP{net.ParseIP("192.168.1.1"), net.ParseIP("192.168.1.1"), net.ParseIP("192.168.1.2")}, nil},
	}
	for i, v := range tests {
		actual, _ := validate(v.input)
		expected := v.expected
		t.Logf("Check case %d: %s(actual) == %s(expected)", i, actual, expected)
		if !reflect.DeepEqual(actual, expected) {
			t.Errorf("Error on case %d: %s(actual) != %s(expected)", i, actual, expected)
		}
	}
}
