package funcs

import (
	"github.com/xsar/config"
	"github.com/xsar/module"
	"strconv"
	"strings"
)

var load module.LoadMetric

func LoadMetrics() interface{} {
	return loadMetrics()
}

func loadMetrics() module.LoadMetric {
	content := strings.TrimRight(Open(config.LoadFile), "\n")
	info := strings.Split(content, " ")
	load.Load1min, _ = strconv.ParseFloat(info[0], 64)
	load.Load5min, _ = strconv.ParseFloat(info[1], 64)
	load.Load15min, _ = strconv.ParseFloat(info[2], 64)
	load.Lastaskpid = info[4]
	return load
}
