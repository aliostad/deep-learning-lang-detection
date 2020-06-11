package metrics

import (
	"os"
	"time"

	"github.com/cloudfoundry-incubator/receptor"
	"github.com/cloudfoundry-incubator/runtime-metrics-server/instruments"
	"github.com/cloudfoundry-incubator/runtime-schema/metric"
	"github.com/cloudfoundry/storeadapter/etcdstoreadapter"
	"github.com/pivotal-golang/clock"
	"github.com/pivotal-golang/lager"
)

const metricsReportingDuration = metric.Duration("MetricsReportingDuration")

type PeriodicMetronNotifier struct {
	Interval       time.Duration
	ETCDOptions    *etcdstoreadapter.ETCDOptions
	Logger         lager.Logger
	Clock          clock.Clock
	ReceptorClient receptor.Client
}

func NewPeriodicMetronNotifier(logger lager.Logger,
	interval time.Duration,
	etcdOptions *etcdstoreadapter.ETCDOptions,
	clock clock.Clock,
	receptorClient receptor.Client) *PeriodicMetronNotifier {
	return &PeriodicMetronNotifier{
		Interval:       interval,
		ETCDOptions:    etcdOptions,
		Logger:         logger,
		Clock:          clock,
		ReceptorClient: receptorClient,
	}
}

func (notifier PeriodicMetronNotifier) Run(signals <-chan os.Signal, ready chan<- struct{}) error {

	etcdInstrument, err := instruments.NewETCDInstrument(notifier.Logger, notifier.ETCDOptions)
	if err != nil {
		return err
	}

	ticker := notifier.Clock.NewTicker(notifier.Interval)
	defer ticker.Stop()

	close(ready)

	tasksInstrument := instruments.NewTaskInstrument(notifier.Logger, notifier.ReceptorClient)
	lrpsInstrument := instruments.NewLRPInstrument(notifier.ReceptorClient)
	domainInstrument := instruments.NewDomainInstrument(notifier.ReceptorClient)

	for {
		select {
		case <-ticker.C():
			startedAt := notifier.Clock.Now()

			tasksInstrument.Send()
			lrpsInstrument.Send()
			domainInstrument.Send()
			etcdInstrument.Send()

			finishedAt := notifier.Clock.Now()

			metricsReportingDuration.Send(finishedAt.Sub(startedAt))

		case <-signals:
			return nil
		}
	}

	return nil
}
