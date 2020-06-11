package network

import (
	lib_network "../../lib/network"

	"net"
)

/*
	Get list of network interfaces
*/
func GetNetInterfaces() ([]lib_network.Interface, error) {
	var interfaces []lib_network.Interface
	var err error
	var netInterfaces []net.Interface
	var netInterface net.Interface

	netInterfaces, err = net.Interfaces()
	if err != nil {
		return interfaces, err
	}

	for _, netInterface = range netInterfaces {
		var netIf lib_network.Interface
		netIf.Name = netInterface.Name
		netIf.Mac = netInterface.HardwareAddr.String()
		tmpNetIf, err := netInterface.Addrs()
		if err != nil {
			return interfaces, err
		}
		for _, ipAddr := range tmpNetIf {
			netIf.Addrs = append(netIf.Addrs, ipAddr.String())
		}
		interfaces = append(interfaces, netIf)
	}

	return interfaces, nil
}
