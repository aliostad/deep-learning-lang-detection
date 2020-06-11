package main

import (
	"fmt"
	"strconv"
	"strings"

	"io/ioutil"

	"github.com/AcalephStorage/go_check/Godeps/_workspace/src/github.com/newrelic/go_nagios"
	"github.com/AcalephStorage/go_check/Godeps/_workspace/src/gopkg.in/alecthomas/kingpin.v1"
)

type load struct {
	one     float32
	five    float32
	fifteen float32
}

var (
	warnLevel = kingpin.Flag("warn-level", "warn level").Default("10,20,30").String()
	critLevel = kingpin.Flag("crit-level", "crit level").Default("15,50,75").String()
)

func main() {
	kingpin.Version("1.0.0")
	kingpin.Parse()
	checkLoad(*warnLevel, *critLevel)
}

func checkLoad(warnLevel, critLevel string) {
	warnLoad := toLoad(warnLevel)
	critLoad := toLoad(critLevel)

	data, err := ioutil.ReadFile("/proc/loadavg")
	if err != nil {
		nagios.Unknown(err.Error())
	}
	loadavgData := string(data)
	rawData := strings.Join(strings.Fields(loadavgData)[0:3], ",")
	load := toLoad(rawData)

	isCrit := threshold(load, critLoad)
	isWarn := threshold(load, warnLoad)

	status := &nagios.NagiosStatus{}
	switch {
	case isCrit:
		status.Value = nagios.NAGIOS_CRITICAL
	case isWarn:
		status.Value = nagios.NAGIOS_WARNING
	default:
		status.Value = nagios.NAGIOS_OK
	}

	status.Message = fmt.Sprintf("CheckLoad: %0.2f, %0.2f, %0.2f", load.one, load.five, load.fifteen)
	nagios.ExitWithStatus(status)
}

func toLoad(data string) *load {
	arr := strings.Split(data, ",")
	return &load{
		one:     toFloat(arr[0]),
		five:    toFloat(arr[1]),
		fifteen: toFloat(arr[2]),
	}
}

func toFloat(str string) float32 {
	f, _ := strconv.ParseFloat(str, 32)
	return float32(f)
}

func threshold(actualLoad, compareLoad *load) bool {
	oneOverThreshold := actualLoad.one >= compareLoad.one
	fiveOverThreshold := actualLoad.five >= compareLoad.five
	fifteenOverThreshold := actualLoad.fifteen >= compareLoad.fifteen
	return oneOverThreshold || fiveOverThreshold || fifteenOverThreshold
}
