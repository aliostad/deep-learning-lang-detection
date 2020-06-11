package thor

import "github.com/prometheus/client_golang/prometheus"

// objectInstrument is a Timber which records timings for every HTTP request
type objectInstrument struct {
	Duration, HandlerDuration *prometheus.HistogramVec
	Memory, CPU               *prometheus.GaugeVec
	Total                     *prometheus.CounterVec
	Server, Namespace         string
}

//setupPrometheus is to setup prometheus
func setupPrometheus(server, namespace string) *objectInstrument {
	var (
		requestDuration = prometheus.NewHistogramVec(prometheus.HistogramOpts{
			Namespace: namespace,
			Name:      "request_duration_seconds",
			Help:      "Time in seconds spent serving HTTP requests.",
			Buckets:   prometheus.DefBuckets,
		}, []string{"server", "method", "route", "status_code"})

		handlerDuration = prometheus.NewHistogramVec(prometheus.HistogramOpts{
			Namespace: namespace,
			Name:      "request_ce_duration_seconds",
			Help:      "Time in seconds spent making request to CE.",
			Buckets:   prometheus.DefBuckets,
		}, []string{"server", "funcname", "status_code"})

		requestTotal = prometheus.NewCounterVec(prometheus.CounterOpts{
			Namespace: namespace,
			Name:      "request_total",
			Help:      "Total HTTP requests.",
		}, []string{"server", "method", "route", "status_code"})

		memoryAllocated = prometheus.NewGaugeVec(prometheus.GaugeOpts{
			Namespace: namespace,
			Name:      "memory_alloc_bytes",
			Help:      "Memory allocated when serving HTTP requests.",
		}, []string{"server", "method", "route", "status_code"})

		cpuAllocated = prometheus.NewGaugeVec(prometheus.GaugeOpts{
			Namespace: namespace,
			Name:      "cpu_percent",
			Help:      "CPU percentage when serving HTTP requests.",
		}, []string{"server", "method", "route", "status_code"})
	)

	prometheus.MustRegister(requestDuration, handlerDuration, requestTotal, memoryAllocated, cpuAllocated)

	instrument := &objectInstrument{
		Duration:        requestDuration,
		HandlerDuration: handlerDuration,
		Total:           requestTotal,
		Memory:          memoryAllocated,
		CPU:             cpuAllocated,
		Server:          server,
		Namespace:       namespace,
	}

	return instrument
}
