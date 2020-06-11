package middleware

import (
	"net/http"

	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promhttp"
)

func Prometheus(registry *prometheus.Registry) func(next http.Handler) http.Handler {
	counter := prometheus.NewCounterVec(
		prometheus.CounterOpts{
			Name: "api_requests_total",
			Help: "A counter for requests to the wrapped handler.",
		},
		[]string{"code", "method"},
	)

	inFlightGauge := prometheus.NewGauge(prometheus.GaugeOpts{
		Name: "in_flight_requests",
		Help: "A gauge of requests currently being served by the wrapped handler.",
	})

	registry.MustRegister(counter)
	registry.MustRegister(inFlightGauge)

	return func(next http.Handler) http.Handler {
		return promhttp.InstrumentHandlerInFlight(inFlightGauge,
			promhttp.InstrumentHandlerCounter(counter, next))
	}
}
