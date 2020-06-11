package net

import (
	"errors"
	"net"
)

// GetLocalTCPAddr returns a local non-loopback network address.
func GetLocalTCPAddr(port int) (*net.TCPAddr, error) {
	addrs, err := net.InterfaceAddrs()
	if err != nil {
		return nil, err
	}
	ipNet := findIPNetIn(addrs, func(ipNet *net.IPNet) bool {
		return ipNet.IP.To4() != nil
	})
	if ipNet == nil {
		ipNet = findIPNetIn(addrs, func(ipNet *net.IPNet) bool {
			return ipNet.IP.To16() != nil
		})
	}
	if ipNet != nil {
		return &net.TCPAddr{
			IP:   ipNet.IP,
			Port: port,
		}, nil
	}
	return nil, errors.New("No suitable IP interface available.")
}

func findIPNetIn(addrs []net.Addr, predicate func(*net.IPNet) bool) *net.IPNet {
	for _, addr := range addrs {
		if ipNet, ok := addr.(*net.IPNet); ok && !ipNet.IP.IsLoopback() {
			if predicate(ipNet) {
				return ipNet
			}
		}
	}
	return nil
}
