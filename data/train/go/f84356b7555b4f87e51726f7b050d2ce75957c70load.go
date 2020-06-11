package metrics

import (
	psutil "github.com/shirou/gopsutil/load"
)

type MetricLoadAVG interface {
	Collect(*psutil.AvgStat, error) Result
}

type loadAVG struct {
	metrics []MetricLoadAVG
}

func (it *loadAVG) Register(metrics ...MetricLoadAVG) *loadAVG {
	for _, metric := range metrics {
		it.Append(metric)
	}
	return it
}

func (it *loadAVG) Append(metric MetricLoadAVG) *loadAVG {
	it.metrics = append(it.metrics, metric)
	return it
}

func (it *loadAVG) Len() int { return len(it.metrics) }

func (it *loadAVG) Collect() (out chan Result) {
	out = make(chan Result, it.Len())
	defer close(out)

	stat, e := psutil.Avg()
	for _, metric := range it.metrics {
		out <- metric.Collect(stat, e)
	}

	return
}

func LoadAVG() *loadAVG { return new(loadAVG) }
