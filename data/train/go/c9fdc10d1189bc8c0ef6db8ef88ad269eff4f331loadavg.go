package loadavg

import (
	"log"
	"github.com/c9s/goprocinfo/linux"
	"github.com/hungryblank/gosysstatsd/statsd"
)

type Load struct {
	OneMin float64
	FiveMin float64
	FifteenMin float64
}

type DataPoint struct {
	Last1Min int
	Last5Min int
	Last15Min int
}

func Poll() DataPoint {
	loadAvg, err := linux.ReadLoadAvg("/proc/loadavg")
	if err != nil {
		log.Fatal(err)
	}
	return DataPoint{int(loadAvg.Last1Min * 100), int(loadAvg.Last5Min * 100), int(loadAvg.Last15Min * 100)}
}

func (load DataPoint) ToMetrics() *[]statsd.Metric {
	list := []statsd.Metric{
		statsd.Gauge("system.cpu.loadavg.one", load.Last1Min),
		statsd.Gauge("system.cpu.loadavg.five", load.Last5Min),
		statsd.Gauge("system.cpu.loadavg.fifteen", load.Last15Min),
	}
	return &list
}
