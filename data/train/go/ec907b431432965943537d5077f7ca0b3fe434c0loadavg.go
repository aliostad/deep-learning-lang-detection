package funcs

import (
	"log"

	"github.com/open-falcon/agent/logger"
	"github.com/open-falcon/common/model"
	"github.com/toolkits/nux"
)

//系统平均负载
func LoadAvgMetrics() []*model.MetricValue {
	//日志
	logger.Glogger.Info("LoadAvgMetrics start!")

	//系统平均负载
	load, err := nux.LoadAvg()
	if err != nil {
		log.Println(err)
		return nil
	}

	//日志
	logger.Glogger.Info("LoadAvgMetrics end!")
	return []*model.MetricValue{
		GaugeValue("load.1min", load.Avg1min),
		GaugeValue("load.5min", load.Avg5min),
		GaugeValue("load.15min", load.Avg15min),
	}

}
