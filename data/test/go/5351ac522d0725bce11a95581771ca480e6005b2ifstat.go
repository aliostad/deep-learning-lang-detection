package funcs

import (
	"../g"
	"github.com/open-falcon/common/model"
	"../tools/net"
	"log"
)

func NetMetrics() []*model.MetricValue {
	return CoreNetMetrics(g.Config().Collector.IfacePrefix)
}

func CoreNetMetrics(ifacePrefix []string) []*model.MetricValue {

	netIfs, err := net.IOCounters(true)
	if err != nil {
		log.Println(err)
		return []*model.MetricValue{}
	}

	cnt := len(netIfs)
	ret := make([]*model.MetricValue, cnt*23)

	for idx, netIf := range netIfs {
		iface := "iface=" + netIf.Name
		ret[idx*23+0] = CounterValue("net.if.in.bytes", netIf.BytesRecv, iface)
		ret[idx*23+1] = CounterValue("net.if.in.packets", netIf.PacketsRecv, iface)
		ret[idx*23+2] = CounterValue("net.if.in.errors", netIf.Errin, iface)
		ret[idx*23+3] = CounterValue("net.if.in.dropped", netIf.Dropin, iface)
		ret[idx*23+4] = CounterValue("net.if.in.fifo.errs", netIf.Fifoin, iface)
		ret[idx*23+8] = CounterValue("net.if.out.bytes", netIf.BytesSent, iface)
		ret[idx*23+9] = CounterValue("net.if.out.packets", netIf.PacketsSent, iface)
		ret[idx*23+10] = CounterValue("net.if.out.errors", netIf.Errout, iface)
		ret[idx*23+11] = CounterValue("net.if.out.dropped", netIf.Dropout, iface)
		ret[idx*23+12] = CounterValue("net.if.out.fifo.errs", netIf.Fifoout, iface)
		ret[idx*23+16] = CounterValue("net.if.total.bytes", netIf.BytesRecv+netIf.BytesSent, iface)
		ret[idx*23+17] = CounterValue("net.if.total.packets", netIf.PacketsRecv+netIf.PacketsSent, iface)
		ret[idx*23+18] = CounterValue("net.if.total.errors", netIf.Errin+netIf.Errout, iface)
		ret[idx*23+19] = CounterValue("net.if.total.dropped", netIf.Dropin+netIf.Dropout, iface)

	}
	return ret
}
