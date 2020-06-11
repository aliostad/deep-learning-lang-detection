package main

import (
	"net/http"
	"os"
	"os/signal"
	"syscall"

	"code.cloudfoundry.org/lager"
	"github.com/pivotal-cf/brokerapi"
	_ "github.com/pivotal-cf/brokerapi/auth"
)

func main() {
	brokerLogger := lager.NewLogger("randomNumberBroker")

	brokerLogger.RegisterSink(lager.NewWriterSink(os.Stdout, lager.DEBUG))
	brokerLogger.RegisterSink(lager.NewWriterSink(os.Stderr, lager.ERROR))

	brokerLogger.Info("Starting randomNumberBroker")

	registerShutdown(brokerLogger)

	c := NewCreator()
	b := NewBinder()

	serviceBroker := &RandomNumberBroker{
		InstanceCreators: map[string]InstanceCreator{
			"0768E956-6650-4010-8E5F-2BBED9D03031": c,
		},
		InstanceBinders: map[string]InstanceBinder{
			"0768E956-6650-4010-8E5F-2BBED9D03031": b,
		},
	}

	brokerCredentials := brokerapi.BrokerCredentials{
		Username: os.Getenv("SECURITY_USER_NAME"),
		Password: os.Getenv("SECURITY_USER_PASSWORD"),
	}

	brokerAPI := brokerapi.New(serviceBroker, brokerLogger, brokerCredentials)

	//authWrapper := auth.NewWrapper(brokerCredentials.Username, brokerCredentials.Password)
	//debugHandler := authWrapper.WrapFunc(debug.NewHandler(remoteRepo))
	//instanceHandler := authWrapper.WrapFunc(redisinstance.NewHandler(remoteRepo))

	//http.HandleFunc("/instance", nil)
	//http.HandleFunc("/debug", nil)
	http.Handle("/", brokerAPI)

	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	brokerLogger.Fatal("http-listen", http.ListenAndServe(":"+port, nil))
}

func registerShutdown(brokerLogger lager.Logger) {
	sigChannel := make(chan os.Signal, 1)
	signal.Notify(sigChannel, syscall.SIGTERM)
	go func() {
		<-sigChannel
		brokerLogger.Info("Starting randomNumberBroker shutdown")
		os.Exit(0)
	}()
}
