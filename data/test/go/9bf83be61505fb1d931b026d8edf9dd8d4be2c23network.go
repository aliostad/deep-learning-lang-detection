// Copyright 2017 Shannon Wynter. All rights reserved.
// Use of this source code is governed by a MIT
// license that can be found in the LICENSE file.

package commontypes

import (
	"encoding/json"
	"net"
	"strings"
)

type Network struct {
	*net.IPNet
}

type Networks []Network

// PrivateNetworks is a list of commonly defined private networks
// most useful for figuring out if a private ip address has been provided
var PrivateNetworks = Networks{
	Network{&net.IPNet{IP: net.IP{0, 0, 0, 0}, Mask: net.IPMask{255, 0, 0, 0}}},
	Network{&net.IPNet{IP: net.IP{10, 0, 0, 0}, Mask: net.IPMask{255, 0, 0, 0}}},
	Network{&net.IPNet{IP: net.IP{100, 64, 0, 0}, Mask: net.IPMask{255, 192, 0, 0}}},
	Network{&net.IPNet{IP: net.IP{127, 0, 0, 0}, Mask: net.IPMask{255, 0, 0, 0}}},
	Network{&net.IPNet{IP: net.IP{172, 16, 0, 0}, Mask: net.IPMask{255, 240, 0, 0}}},
	Network{&net.IPNet{IP: net.IP{192, 0, 0, 0}, Mask: net.IPMask{255, 255, 255, 0}}},
	Network{&net.IPNet{IP: net.IP{192, 0, 2, 0}, Mask: net.IPMask{255, 255, 255, 0}}},
	Network{&net.IPNet{IP: net.IP{192, 88, 99, 0}, Mask: net.IPMask{255, 255, 255, 0}}},
	Network{&net.IPNet{IP: net.IP{192, 168, 0, 0}, Mask: net.IPMask{255, 255, 0, 0}}},
	Network{&net.IPNet{IP: net.IP{198, 18, 0, 0}, Mask: net.IPMask{255, 254, 0, 0}}},
	Network{&net.IPNet{IP: net.IP{198, 51, 100, 0}, Mask: net.IPMask{255, 255, 255, 0}}},
	Network{&net.IPNet{IP: net.IP{203, 0, 113, 0}, Mask: net.IPMask{255, 255, 255, 0}}},
}

func (n *Network) UnmarshalText(text []byte) error {
	return n.Unmarshal(string(text))
}

func (n *Network) UnmarshalTOML(text []byte) error {
	return n.Unmarshal(string(text[1 : len(text)-1]))
}

func (n *Network) UnmarshalJSON(data []byte) error {
	var s string
	err := json.Unmarshal(data, &s)
	if err != nil {
		return err
	}
	return n.Unmarshal(s)
}

func (n *Network) Unmarshal(s string) (err error) {
	if !strings.Contains(s, "/") {
		s = s + "/32"
	}

	_, n.IPNet, err = net.ParseCIDR(s)
	return
}

func (n *Network) MarshalText() ([]byte, error) {
	return []byte(n.IPNet.String()), nil
}

func (n *Network) MarshalJSON() ([]byte, error) {
	return json.Marshal(n.IPNet.String())
}

func (n *Networks) Contains(ip net.IP) bool {
	for _, r := range *n {
		if r.Contains(ip) {
			return true
		}
	}
	return false
}

func (n *Networks) Empty() bool {
	return len(*n) == 0
}
