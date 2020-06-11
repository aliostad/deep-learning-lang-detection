package main

import (
	"flag"
	"net/http"
	"time"

	"github.com/go-kit/kit/log"
	"github.com/go-kit/kit/log/level"

	"github.com/lifesum/configsum/pkg/ui"
)

func runConsole(args []string, logger log.Logger) error {
	var (
		begin   = time.Now()
		flagset = flag.NewFlagSet("console", flag.ExitOnError)

		instrumentAddr = flagset.String("instrument.addr", ":8711", "Listen address for instrumenation")
		listenAddr     = flagset.String("listen.addr", ":8710", "HTTP API bind address")
		uiBase         = flagset.String("ui.base", "/", "Base URI to use for path based mounting")
		uiLocal        = flagset.Bool("ui.local", false, "Load static assets from the filesystem")
	)

	flagset.Usage = usageCmd(flagset, "console [flags]")
	if err := flagset.Parse(args); err != nil {
		return err
	}

	go func(lgoger log.Logger, addr string) {
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
	}(logger, *instrumentAddr)

	serveMux := http.NewServeMux()

	handler, err := ui.MakeHandler(logger, *uiBase, *uiLocal)
	if err != nil {
		abort(logger, err)
	}

	serveMux.Handle("/", handler)

	srv := &http.Server{
		Addr:         *listenAddr,
		Handler:      serveMux,
		ReadTimeout:  defaultTimeoutRead,
		WriteTimeout: defaultTimeoutWrite,
	}

	_ = level.Info(logger).Log(
		logDuration, time.Since(begin).Nanoseconds(),
		logLifecycle, lifecycleStart,
		logListen, *listenAddr,
		logService, serviceAPI,
	)

	return srv.ListenAndServe()
}
