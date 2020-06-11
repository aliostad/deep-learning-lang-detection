package metric

import (
	"github.com/shirou/gopsutil/load"
	"log"
)

const (
	LoadAverageMetricTypeName = "load_average"
)

type LoadAverageMetric struct {
	interval int
}

func NewLoadAverageMetric(i int) *LoadAverageMetric {
	return &LoadAverageMetric{interval: i}
}

func (loadAverageMetric *LoadAverageMetric) Type() string {
	return LoadAverageMetricTypeName
}

func (loadAverageMetric *LoadAverageMetric) Interval() int {
	return loadAverageMetric.interval
}

func (loadAverageMetric *LoadAverageMetric) Get() []MetricValue {
	log.Print("get loadAverage metric")
	info, _ := load.Avg()

	var r []MetricValue
	rv := make(map[string]interface{})
	rv["load1"] = info.Load1
	rv["load5"] = info.Load5
	rv["load15"] = info.Load15
	r = append(r, MetricValue{Value: rv})

	return r
}
