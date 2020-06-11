package proxy

import (
	"net"
	"testing"
)

func TestAcceptAddresPos(t *testing.T) {
	networks := []*net.IPNet{
		&net.IPNet{net.ParseIP("127.0.0.1"), net.CIDRMask(32, 32)},
		&net.IPNet{net.ParseIP("192.168.0.1"), net.CIDRMask(24, 32)},
		&net.IPNet{net.ParseIP("10.0.0.1"), net.CIDRMask(8, 32)},
	}

	testPosAddr := []string{
		"127.0.0.1:1",
		"192.168.0.1:1",
		"192.168.0.100:1",
		"192.168.0.254:1",
		"10.0.0.1:1",
		"10.0.1.1:1",
		"10.1.1.1:1",
	}

	for _, addr := range testPosAddr {
		if !acceptAddress(networks, addr) {
			t.Errorf("acceptAddress(%v, %v) = false; should be true", networks, addr)
		}
	}
}

func TestAcceptAddresNeg(t *testing.T) {
	networks := []*net.IPNet{
		&net.IPNet{net.ParseIP("127.0.0.1"), net.CIDRMask(32, 32)},
		&net.IPNet{net.ParseIP("192.168.0.1"), net.CIDRMask(24, 32)},
		&net.IPNet{net.ParseIP("10.0.0.1"), net.CIDRMask(8, 32)},
	}

	testPosAddr := []string{
		"127.0.0.2:1",
		"192.168.1.1:1",
		"192.1.0.100:1",
		"1.1.0.254:1",
		"12.0.0.0:1",
	}

	for _, addr := range testPosAddr {
		if acceptAddress(networks, addr) {
			t.Errorf("acceptAddress(%v, %v) = true; should be false", networks, addr)
		}
	}
}

func createNet(ip string, mask int) *net.IPNet {
	return &net.IPNet{net.ParseIP(ip), net.CIDRMask(mask, 32)}
}

func TestPrepareNetworksSingle(t *testing.T) {
	test := map[string]*net.IPNet{
		"127.0.0.1":      createNet("127.0.0.1", 32),
		"192.168.1.1":    createNet("192.168.1.1", 32),
		"192.1.0.100/24": createNet("192.1.0.0", 24),
		"10.0.0.0/8":     createNet("10.0.0.0", 8),
	}

	for addr, net := range test {
		nets := prepareNetworks(addr)
		if nets == nil || len(nets) == 0 {
			t.Errorf("prepareNetworks(%v) = %v; expected %v", addr, nets, net)
		} else {
			net1 := nets[0]
			if net1.String() != net.String() {
				t.Errorf("prepareNetworks(%v) = %v; expected %v", addr, nets, net)
			}
		}
	}
}

func TestPrepareNetworksMulti(t *testing.T) {
	inp := "127.0.0.1 192.1.0.100/24\n10.0.0.0/8"
	out := []*net.IPNet{
		createNet("127.0.0.1", 32),
		createNet("192.1.0.0", 24),
		createNet("10.0.0.0", 8),
	}

	nets := prepareNetworks(inp)

	if len(nets) != len(out) {
		t.Errorf("prepareNetworks(%v) = %v; expected %v", inp, nets, out)
	}

	for idx, net := range nets {
		if net.String() != out[idx].String() {
			t.Errorf("prepareNetworks(%v) = %v; on pos %v expected %v != %v", inp, nets, idx, net, out[idx])
		}
	}
}
