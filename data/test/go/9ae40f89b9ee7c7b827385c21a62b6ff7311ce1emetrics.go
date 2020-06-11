package main

import (
	"github.com/prometheus/client_golang/prometheus"
	"time"
)

var (
	channelDropCounter = prometheus.NewCounter(prometheus.CounterOpts{
		Subsystem: "broadcaster",
		Help:      "Number of dropped channel writes",
		Name:      "channel_drop_total",
	})
	messagesCounter = prometheus.NewCounter(prometheus.CounterOpts{
		Subsystem: "broadcaster",
		Help:      "Number of messages sent",
		Name:      "messages_total",
	})
	sseGauge = prometheus.NewGauge(prometheus.GaugeOpts{
		Subsystem: "broadcaster",
		Help:      "Number of SSE connections",
		Name:      "sse_count",
	})
	webSocketsGauge = prometheus.NewGauge(prometheus.GaugeOpts{
		Subsystem: "broadcaster",
		Help:      "Number of WebSockets connections",
		Name:      "websockets_count",
	})
	dispatchLatencySummary = prometheus.NewSummary(prometheus.SummaryOpts{
		Subsystem: "broadcaster",
		Help:      "Latency of message dispatch",
		Name:      "dispatch_latency_seconds",
	})
	processLatencySummary = prometheus.NewSummary(prometheus.SummaryOpts{
		Subsystem: "broadcaster",
		Help:      "Latency of message processing",
		Name:      "process_latency_seconds",
	})
)

func init() {
	prometheus.MustRegister(channelDropCounter)
	prometheus.MustRegister(messagesCounter)
	prometheus.MustRegister(sseGauge)
	prometheus.MustRegister(webSocketsGauge)
	prometheus.MustRegister(processLatencySummary)
	prometheus.MustRegister(dispatchLatencySummary)
}

type PrometheusMetrics struct{}

func (*PrometheusMetrics) IncrementWebSocketsCount(delta int) {
	webSocketsGauge.Add(float64(delta))
}

func (*PrometheusMetrics) IncrementSSECount(delta int) {
	sseGauge.Add(float64(delta))
}

func (*PrometheusMetrics) IncrementChannelDropCount() {
	channelDropCounter.Inc()
}

func (*PrometheusMetrics) IncrementMessagesCount() {
	messagesCounter.Inc()
}

func (*PrometheusMetrics) ObserveDispatchMessageLatency(latency time.Duration) {
	dispatchLatencySummary.Observe(latency.Seconds())
}

func (*PrometheusMetrics) ObserveProcessMessageLatency(latency time.Duration) {
	processLatencySummary.Observe(latency.Seconds())
}
