package base

import (
	"io/ioutil"
	"strings"
	"unsafe"
	"strconv"
	"../model"
)

type LoadAvg struct {
	Avg1Min  float64
	Avg5Min  float64
	Avg15Min float64
}

func listLoadAvg() (*LoadAvg, error) {
	statFile := "/proc/loadavg"
	bs, err := ioutil.ReadFile(statFile)
	if nil != err {
		return nil, err
	}
	loadAvgInfo := new(LoadAvg)
	fields := strings.Fields(*(*string)(unsafe.Pointer(&bs)))
	if loadAvgInfo.Avg1Min, err = strconv.ParseFloat(fields[0], 64); nil != err {
		return nil, err
	}
	if loadAvgInfo.Avg5Min, err = strconv.ParseFloat(fields[1], 64); nil != err {
		return nil, err
	}
	if loadAvgInfo.Avg15Min, err = strconv.ParseFloat(fields[2], 64); nil != err {
		return nil, err
	}
	return loadAvgInfo, err
}

func (loadAvg *LoadAvg) Metrics() []*model.MetricValue {
	loadAvg, err := listLoadAvg()
	if nil != err {
		return nil
	}
	load1Min := model.MetricValue{Endpoint: "load", Metric: "load.1m", Value: strconv.FormatFloat(loadAvg.Avg1Min, 'f', 2, 64)}
	load5Min := model.MetricValue{Endpoint: "load", Metric: "load.5m", Value: strconv.FormatFloat(loadAvg.Avg5Min, 'f', 2, 64)}
	load15Min := model.MetricValue{Endpoint: "load", Metric: "load.15m", Value: strconv.FormatFloat(loadAvg.Avg15Min, 'f', 2, 64)}
	return []*model.MetricValue{&load1Min, &load5Min, &load15Min}
}
