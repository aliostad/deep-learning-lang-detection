package prominstrument

import (
	"time"

	instrumentor "github.com/kazegusuri/grpc-instrument-handler"
	"github.com/prometheus/client_golang/prometheus"
	"golang.org/x/net/context"
	"google.golang.org/grpc"
)

func init() {
	instrumentor.InstallInstrumentor(instrument)

	prometheus.MustRegister(totalCalls)
	prometheus.MustRegister(errorCalls)
	prometheus.MustRegister(durations)
}

var (
	totalCalls = prometheus.NewCounterVec(prometheus.CounterOpts{
		Name: "grpc_calls_total",
		Help: "Number of gRPC calls.",
	}, []string{"method"})
	errorCalls = prometheus.NewCounterVec(prometheus.CounterOpts{
		Name: "grpc_calls_errors",
		Help: "Number of gRPC calls that returned error.",
	}, []string{"method"})
	durations = prometheus.NewSummaryVec(prometheus.SummaryOpts{
		Name: "grpc_calls_duration",
		Help: "Duration of gRPC calls.",
	}, []string{"method"})
)

func instrument(ctx context.Context, info *grpc.UnaryServerInfo, duration time.Duration, err error) {
	labels := prometheus.Labels{"method": info.FullMethod}
	totalCalls.With(labels).Inc()
	if err != nil {
		errorCalls.With(labels).Inc()
	}
	durations.With(labels).Observe(
		float64(duration.Nanoseconds() / int64(time.Millisecond)),
	)
}
