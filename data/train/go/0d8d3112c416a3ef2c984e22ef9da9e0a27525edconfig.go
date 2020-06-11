package main

import (
	"flag"
	"fmt"
	"net/http"
	"time"

	"github.com/go-kit/kit/log"
	"github.com/go-kit/kit/log/level"
	kitprom "github.com/go-kit/kit/metrics/prometheus"
	"github.com/jmoiron/sqlx"
	"github.com/prometheus/client_golang/prometheus"

	"github.com/lifesum/configsum/pkg/client"
	"github.com/lifesum/configsum/pkg/config"
)

func runConfig(args []string, logger log.Logger) error {
	var (
		begin   = time.Now()
		flagset = flag.NewFlagSet("config", flag.ExitOnError)

		intrumentAddr = flagset.String("instrument.addir", ":8701", "Listen address for instrumentation")
		listenAddr    = flagset.String("listen.addr", ":8700", "Listen address for HTTP API")
		postgresURI   = flagset.String("postgres.uri", defaultPostgresURI, "URI for Posgres connection")
	)

	flagset.Usage = usageCmd(flagset, "config [flags]")
	if err := flagset.Parse(args); err != nil {
		return err
	}

	// Setup instrunentation.
	go func(logger log.Logger, addr string) {
		mux := http.NewServeMux()

		registerMetrics(mux)
		registerProfile(mux)

		logger.Log(
			logDuration, time.Since(begin).Nanoseconds(),
			logLifecycle, lifecycleStart,
			logListen, addr,
			logService, serviceInstrument,
		)

		abort(logger, http.ListenAndServe(addr, mux))
	}(logger, *intrumentAddr)

	repoLabels := []string{
		labelOp,
		labelRepo,
		labelStore,
	}

	repoErrCount := kitprom.NewCounterFrom(
		prometheus.CounterOpts{
			Namespace: instrumentNamespace,
			Subsystem: instrumentSubsystem,
			Name:      "err_count",
			Help:      "Amount of failed repo operations.",
		},
		repoLabels,
	)

	repoErrCountFunc := func(store, repo, op string) {
		repoErrCount.With(
			labelOp, op,
			labelRepo, repo,
			labelStore, store,
		).Add(1)
	}

	repoOpCount := kitprom.NewCounterFrom(
		prometheus.CounterOpts{
			Namespace: instrumentNamespace,
			Subsystem: instrumentSubsystem,
			Name:      "op_count",
			Help:      "Amount of successful repo operations.",
		},
		repoLabels,
	)

	repoOpCountFunc := func(store, repo, op string) {
		repoOpCount.With(
			labelOp, op,
			labelRepo, repo,
			labelStore, store,
		).Add(1)
	}

	repoOpLatency := kitprom.NewHistogramFrom(
		prometheus.HistogramOpts{
			Namespace: instrumentNamespace,
			Subsystem: instrumentSubsystem,
			Name:      "op_latency_seconds",
			Help:      "Latency of successful repo operations.",
		},
		repoLabels,
	)

	repoOpLatencyFunc := func(store, repo, op string, begin time.Time) {
		repoOpLatency.With(
			labelOp, op,
			labelRepo, repo,
			labelStore, store,
		).Observe(time.Since(begin).Seconds())
	}

	// Setup clients.
	db, err := sqlx.Connect(storeRepo, *postgresURI)
	if err != nil {
		return err
	}

	// Setup repos.
	baseRepo, err := config.NewInmemBaseRepo(nil)
	if err != nil {
		return err
	}

	userRepo, err := config.NewPostgresUserRepo(db)
	if err != nil {
		return err
	}
	userRepo = config.NewUserRepoInstrumentMiddleware(
		repoErrCountFunc,
		repoOpCountFunc,
		repoOpLatencyFunc,
		storeRepo,
	)(userRepo)
	userRepo = config.NewUserRepoLogMiddleware(logger, storeRepo)(userRepo)

	clientRepo := client.NewPostgresRepo(db)
	clientRepo = client.NewRepoInstrumentMiddleware(
		repoErrCountFunc,
		repoOpCountFunc,
		repoOpLatencyFunc,
		storeRepo,
	)(clientRepo)
	clientRepo = client.NewRepoLogMiddleware(logger, storeRepo)(clientRepo)

	tokenRepo := client.NewPostgresTokenRepo(db)
	tokenRepo = client.NewTokenRepoInstrumentMiddleware(
		repoErrCountFunc,
		repoOpCountFunc,
		repoOpLatencyFunc,
		storeRepo,
	)(tokenRepo)
	tokenRepo = client.NewTokenRepoLogMiddleware(logger, storeRepo)(tokenRepo)

	// Setup service.
	var (
		mux          = http.NewServeMux()
		prefixConfig = fmt.Sprintf(`/%s/config`, apiVersion)
		clientSvc    = client.NewService(clientRepo, tokenRepo)
		svc          = config.NewServiceUser(baseRepo, userRepo)
	)

	mux.Handle(
		fmt.Sprintf(`%s/`, prefixConfig),
		http.StripPrefix(
			prefixConfig,
			config.MakeHandler(logger, svc, clientSvc),
		),
	)

	// Setup server.
	srv := &http.Server{
		Addr:         *listenAddr,
		Handler:      mux,
		ReadTimeout:  defaultTimeoutRead,
		WriteTimeout: defaultTimeoutWrite,
	}

	_ = level.Info(logger).Log(
		logDuration, time.Since(begin).Nanoseconds(),
		logLifecycle, lifecycleStart,
		logListen, *listenAddr,
		logService, "api",
	)

	return srv.ListenAndServe()
}
