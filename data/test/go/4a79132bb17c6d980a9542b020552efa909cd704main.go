package main

import (
	"github.com/asteris-llc/pushmipullyu/Godeps/_workspace/src/github.com/Sirupsen/logrus"
	"github.com/asteris-llc/pushmipullyu/Godeps/_workspace/src/golang.org/x/net/context"
	"github.com/asteris-llc/pushmipullyu/dispatch"
	"github.com/asteris-llc/pushmipullyu/services/asana"
	"github.com/asteris-llc/pushmipullyu/services/github"
	"math/rand"
	"os"
	"os/signal"
	"strconv"
	"time"
)

func main() {
	// logging
	logrus.SetLevel(logrus.DebugLevel)

	// seed random
	rand.Seed(time.Now().Unix())

	//
	ctx, shutdown := context.WithCancel(context.Background())

	// dispatcher
	dispatch := dispatch.New()
	go dispatch.Run(ctx)

	// Asana
	team, err := strconv.Atoi(os.Getenv("ASANA_TEAM"))
	if err != nil {
		logrus.WithField("error", err).Fatal("could not convert ASANA_TEAM to int")
	}
	asana, err := asana.New(os.Getenv("ASANA_TOKEN"), team)
	if err != nil {
		logrus.WithField("error", err).Fatal("could not initialize Asana")
	}
	go asana.Handle(ctx, dispatch.Register("github:opened"))

	// Github
	github, err := github.New(os.Getenv("PORT"))
	if err != nil {
		logrus.WithField("error", err).Fatal("could not initialize Github")
	}
	go func() {
		err := github.Produce(dispatch.Send)
		if err != nil {
			logrus.WithField("error", err).Error("error starting producer")
		}
		logrus.Info("shutting down due to HTTP stopping")
		shutdown()
	}()

	// and finally sleep and catch events
	defer shutdown()
	go catch(shutdown)

	// give services time to finish and shut down
	<-ctx.Done()
	logrus.Info("waiting for grace period for services to shut down")
	time.Sleep(time.Second * 5)
}

func catch(handler func()) {
	signals := make(chan os.Signal, 1)
	signal.Notify(signals, os.Interrupt)

	for _ = range signals {
		logrus.Warn("received shutdown signal")
		handler()
		return
	}
}
