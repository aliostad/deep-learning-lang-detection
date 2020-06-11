package funcs

import (
	"strings"

	"fmt"
	"ibamWinAgent/common/model"
	"ibamWinAgent/g"
	NET "net"

	"github.com/StackExchange/wmi"
	"github.com/shirou/gopsutil/net"
)

func netMetric(ip string) int32 {
	type Win32_IP4RouteTable struct {
		//Metric1 int32  where name='10.5.105.18'
		Metric1 int32
	}
	var ret int32
	var dst []Win32_IP4RouteTable
	query := fmt.Sprintf("SELECT Metric1 FROM Win32_IP4RouteTable where name='%s'", ip)
	err := wmi.Query(query, &dst)
	if err != nil {
		g.Logger().Println(err)
		return ret
	}
	return dst[0].Metric1
}
func netType(macStr string) string {
	type Win32_NetworkAdapter struct {
		AdapterType string
	}
	var ret string
	var dst []Win32_NetworkAdapter
	query := fmt.Sprintf("SELECT AdapterType FROM Win32_NetworkAdapter where MACAddress='%s'", macStr)
	err := wmi.Query(query, &dst)
	if err != nil {
		g.Logger().Println(err)
		return ret
	}
	return dst[0].AdapterType
}
func net_status(ifacePrefix []string) ([]net.IOCountersStat, error) {
	net_iocounter, err := net.IOCounters(true)
	netIfs := []net.IOCountersStat{}
	for _, iface := range ifacePrefix {
		for _, netIf := range net_iocounter {
			if strings.Contains(netIf.Name, iface) {
				netIfs = append(netIfs, netIf)
			}
		}
	}
	return netIfs, err
}

func NetStaticMetrics() []*model.MetricValue {
	return CoreNetStaticMetrics(g.Config().TomlConfig.IfacePrefix)
}
func CoreNetStaticMetrics(ifacePrefix []string) (L []*model.MetricValue) {
	//获取所有网卡接口信息
	interfaces, err := NET.Interfaces()
	if err != nil {
		g.Logger().Println(err)
	}
	//指定的采集网卡名
	netNames := g.Config().TomlConfig.IfacePrefix
	//所有指定网卡mac地址
	netTags := ""
	//两次循环，在所有网卡中找到指定的网卡
	for _, inter := range interfaces {
		for _, netName := range netNames {
			if strings.Contains(inter.Name, netName) {
				//netTags
				macAddr := "mac=" + inter.HardwareAddr.String()
				if netTags != "" {
					netTags = netTags + "," + macAddr
				} else {
					netTags = macAddr
				}
				//name
				L = append(L, StaticValue("system.net.name", inter.Name, macAddr))
				//mtu
				L = append(L, StaticValue("system.net.mtu", inter.MTU, macAddr))
				//type
				nettype := netType(inter.HardwareAddr.String())
				L = append(L, StaticValue("system.net.type", nettype, macAddr))
				//addr
				addrs, err := inter.Addrs()
				if err != nil {
					g.Logger().Println(err)
				}
				ip := strings.Split(addrs[1].String(), "/")[0]
				L = append(L, StaticValue("system.net.address", ip, macAddr))
				//metric
				metric := netMetric(ip)
				L = append(L, StaticValue("system.net.metric", metric, macAddr))
				//stats
				netState := 1
				if ip != "" {
					netState = 0
				}
				L = append(L, StaticValue("system.net.stats", netState, macAddr))

				break
			}

		}

	}
	L = append(L, StaticValue("system.net.tags", netTags, ""))
	return
}

func NetMetrics() []*model.MetricValue {
	return CoreNetMetrics(g.Config().TomlConfig.IfacePrefix)
}

var netReadMap map[string]uint64 = make(map[string]uint64)
var netWriteMap map[string]uint64 = make(map[string]uint64)

func CoreNetMetrics(ifacePrefix []string) (L []*model.MetricValue) {

	netIfs, err := net_status(ifacePrefix)
	if err != nil {
		g.Logger().Println(err)
		return []*model.MetricValue{}
	}
	interval := g.Config().TomlConfig.Interval

	for _, netIf := range netIfs {
		//get mac addr
		inter, err := NET.InterfaceByName(netIf.Name)
		if err != nil {
			g.Logger().Println(err)
			continue
		}
		mac := inter.HardwareAddr.String()

		// read speed
		if netReadMap[mac] == 0 || netReadMap[mac] > netIf.BytesRecv {
			netReadMap[mac] = netIf.BytesRecv
		}
		var netReadSpeed float64 = float64(netIf.BytesRecv-netReadMap[mac]) / float64(interval*1024)
		// next calculate
		netReadMap[mac] = netIf.BytesRecv
		L = append(L, DynamicValue("system.net.in", netReadSpeed, "mac="+mac))

		//write speed
		if netWriteMap[mac] == 0 || netWriteMap[mac] > netIf.BytesSent {
			netWriteMap[mac] = netIf.BytesSent
		}
		var netWriteSpeed float64 = float64(netIf.BytesSent-netWriteMap[mac]) / float64(interval*1024)
		// next calculate
		netWriteMap[mac] = netIf.BytesSent

		L = append(L, DynamicValue("system.net.out", netWriteSpeed, "mac="+mac))
		L = append(L, DynamicValue("system.net.delay", 0, "mac="+mac))
		L = append(L, DynamicValue("system.net.dropped", (netIf.Dropout+netIf.Dropin)/1024, "mac="+mac))

	}

	return
}
