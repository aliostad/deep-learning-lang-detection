package cbd

import (
	"net"
	"reflect"
	"sort"
	"strings"
	"testing"
)

func TestSortByIPAddrs(t *testing.T) {

	ips := []net.IPNet{
		net.IPNet{IP: net.IPv4(1, 2, 1, 1)},
		net.IPNet{IP: net.IPv4(1, 1, 1, 1)},
		net.IPNet{IP: net.IPv4(10, 2, 3, 4)},
		net.IPNet{IP: net.IPv4(172, 1, 3, 4)},
		net.IPNet{IP: net.IPv4(172, 2, 3, 4)},
		net.IPNet{IP: net.IPv4(192, 1, 3, 4)},
		net.IPNet{IP: net.IPv4(192, 2, 3, 4)},
	}

	desired := []net.IPNet{
		net.IPNet{IP: net.IPv4(192, 1, 3, 4)},
		net.IPNet{IP: net.IPv4(192, 2, 3, 4)},
		net.IPNet{IP: net.IPv4(172, 1, 3, 4)},
		net.IPNet{IP: net.IPv4(172, 2, 3, 4)},
		net.IPNet{IP: net.IPv4(10, 2, 3, 4)},
		net.IPNet{IP: net.IPv4(1, 1, 1, 1)},
		net.IPNet{IP: net.IPv4(1, 2, 1, 1)},
	}

	sort.Sort(ByPrivateIPAddr(ips))

	if !reflect.DeepEqual(desired, ips) {
		t.Error("Didn't sort to ", desired, "got: ", ips)
	}
}

func TestGetLocalIPAddrs(t *testing.T) {
	addrs, err := getLocalIPAddrs()
	if err != nil {
		t.Error("Problem getting ips", err)
	}

	if len(addrs) == 0 {
		t.Error("Could not find any addresses (do you have a network " +
			"connection?)")
	}

	// Make sure the last part of our address isn't masked
	last_octet := strings.Split(addrs[0].String(), ".")

	if len(last_octet) != 4 {
		t.Error("Malformed address", addrs[0])
	}

	parts := strings.Split(last_octet[3], "/")

	if len(parts) != 2 {
		t.Error("Malformed address", addrs[0])
	}

	if parts[0] == "0" {
		t.Error("Invalid iface address", addrs[0])
	}
}

type MatchExample struct {
	exp net.IPNet
	err error
	as  []net.IPNet
	bs  []net.IPNet
}

func TestGetMatchingIP(t *testing.T) {
	examples := []MatchExample{
		{
			// Basic hello world example
			exp: net.IPNet{net.IPv4(192, 1, 1, 25), net.IPv4Mask(255, 255, 255, 0)},
			err: nil,
			as: []net.IPNet{
				{net.IPv4(192, 1, 1, 4), net.IPv4Mask(255, 255, 255, 0)},
			},
			bs: []net.IPNet{
				{net.IPv4(192, 1, 1, 25), net.IPv4Mask(255, 255, 255, 0)},
			}},
		{
			// They are different 192 networks, but matching 172
			exp: net.IPNet{net.IPv4(172, 16, 2, 26), net.IPv4Mask(255, 255, 0, 0)},
			err: nil,
			as: []net.IPNet{
				{net.IPv4(192, 1, 1, 4), net.IPv4Mask(255, 255, 255, 0)},
				{net.IPv4(172, 16, 2, 6), net.IPv4Mask(255, 255, 0, 0)},
			},
			bs: []net.IPNet{
				{net.IPv4(192, 2, 2, 24), net.IPv4Mask(255, 255, 255, 0)},
				{net.IPv4(172, 16, 2, 26), net.IPv4Mask(255, 255, 0, 0)},
			}},
	}

	for _, example := range examples {
		res, err := getMatchingIP(example.as, example.bs)

		if example.err != nil {
			if err == nil {
				t.Errorf("Got no error when we should of gotten one")
			}
		} else {
			if err != nil {
				t.Errorf("Did not match ", err)
			}

			if !reflect.DeepEqual(res, example.exp) {
				t.Errorf("Bad IP match %s != %s", res.String(), example.exp.String())
			}
		}
	}
}
