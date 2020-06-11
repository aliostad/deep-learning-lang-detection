//
// cidr: display network, netmask and broadcast of specified CIDR block
//

package main

import (
	"fmt"
	"net"
	"os"
)

func netCast(n *net.IPNet) net.IP {
	b := make(net.IP, net.IPv4len)

	for i := 0; i < 4; i++ {
		b[i] = n.IP[i] + ^n.Mask[i]
	}
	return b
}

func netMask(m net.IPMask) net.IP {
	if len(m) == 0 {
		return nil
	}

	return net.IPv4(m[0], m[1], m[2], m[3])
}

func main() {
	p := fmt.Println

	if len(os.Args) < 2 {
		p("Usage: cidr <NETWORK>")
		return
	}

	_, n, e := net.ParseCIDR(os.Args[1])
	if e != nil {
		p(e)
		return
	}

	fmt.Printf(" network: %-15s / %s\n          %-15s / %s\n", n.IP, n.Mask, netCast(n), netMask(n.Mask))
}
