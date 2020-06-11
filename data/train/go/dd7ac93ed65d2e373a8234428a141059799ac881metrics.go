package mongoproxy

import (
	"github.com/ParsePlatform/go.metrics"
)

type dispatchMetrics struct {
	success metrics.Meter
	failure metrics.Meter
}

func newDispatchMetrics() *dispatchMetrics {
	return &dispatchMetrics{
		success: metrics.NewMeter(),
		failure: metrics.NewMeter(),
	}
}

type listenerMetrics struct {
	acceptCounter  metrics.Meter
	connectionDrop metrics.Meter
}

func newListenerMetric() *listenerMetrics {
	return &listenerMetrics{
		acceptCounter:  metrics.NewMeter(),
		connectionDrop: metrics.NewMeter(),
	}
}
