package nux

import (
	"github.com/mozillazg/go-pinyin"
	"github.com/shirou/gopsutil/net"
)

func NetIfs(onlyPrefix []string) ([]*NetIf, error) {
	// windows don't filter infterfaces
	ret := []*NetIf{}
	ifs, err := net.IOCounters(true)
	if err != nil {
		return nil, err
	}
	for _, inf := range ifs {
		netIf := NetIf{}

		netIf.Iface = convert2pinyin(inf.Name)

		netIf.InBytes = inf.BytesRecv
		netIf.InPackages = inf.PacketsRecv
		netIf.InErrors = inf.Errin
		netIf.InDropped = inf.Dropin
		netIf.InFifoErrs = inf.Fifoin

		netIf.OutBytes = inf.BytesSent
		netIf.OutPackages = inf.PacketsSent
		netIf.OutErrors = inf.Errout
		netIf.OutDropped = inf.Dropout
		netIf.OutFifoErrs = inf.Fifoout

		netIf.TotalBytes = netIf.InBytes + netIf.OutBytes
		netIf.TotalPackages = netIf.InPackages + netIf.OutPackages
		netIf.TotalErrors = netIf.InErrors + netIf.OutErrors
		netIf.TotalDropped = netIf.InDropped + netIf.OutDropped

		ret = append(ret, &netIf)
	}

	return ret, nil
}

func convert2pinyin(name string) string {
	a := pinyin.NewArgs()
	a.Separator = ""
	a.Fallback = fall
	return pinyin.Slug(name, a)
}

func fall(r rune, a pinyin.Args) []string {
	if string(r) == " " {
		return nil
	}
	return []string{string(r)}
}
