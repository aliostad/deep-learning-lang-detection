package safehttp

import (
	"errors"
	"net"
)

type Filter interface {
	Check(ip net.IP, port int) error
}

var PrivateNetworks = []*net.IPNet{
	&net.IPNet{net.IPv4(0, 0, 0, 0), net.IPv4Mask(255, 0, 0, 0)},       // 0.0.0.0/8
	&net.IPNet{net.IPv4(10, 0, 0, 0), net.IPv4Mask(255, 0, 0, 0)},      // 10.0.0.0/8
	&net.IPNet{net.IPv4(172, 16, 0, 0), net.IPv4Mask(255, 240, 0, 0)},  // 172.16.0.0/12
	&net.IPNet{net.IPv4(192, 168, 0, 0), net.IPv4Mask(255, 255, 0, 0)}, // 192.168.0.0/16
	&net.IPNet{net.IPv4(224, 0, 0, 0), net.IPv4Mask(240, 0, 0, 0)},     // 224.0.0.0/4
	&net.IPNet{net.IPv4(240, 0, 0, 0), net.IPv4Mask(240, 0, 0, 0)},     // 240.0.0.0/4
}

type PrivateNetworkFilter struct {
}

func (f *PrivateNetworkFilter) Check(ip net.IP, port int) error {
	for _, network := range PrivateNetworks {
		if network.Contains(ip) {
			return errors.New("Private network is restricted")
		}
	}

	return nil
}
