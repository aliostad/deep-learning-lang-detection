package main

import (
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"

	"code.cloudfoundry.org/lager"
	"github.com/pivotal-cf/brokerapi"
	"github.com/pivotal-cf/brokerapi/auth"

	"github.com/pivotal-cf/cf-redis-broker/availability"
	"github.com/pivotal-cf/cf-redis-broker/broker"
	"github.com/pivotal-cf/cf-redis-broker/brokerconfig"
	"github.com/pivotal-cf/cf-redis-broker/consistency"
	"github.com/pivotal-cf/cf-redis-broker/debug"
	"github.com/pivotal-cf/cf-redis-broker/process"
	"github.com/pivotal-cf/cf-redis-broker/redis"
	"github.com/pivotal-cf/cf-redis-broker/redisinstance"
	"github.com/pivotal-cf/cf-redis-broker/system"
)

func main() {
	brokerConfigPath := configPath()

	brokerLogger := lager.NewLogger("redis-broker")
	brokerLogger.RegisterSink(lager.NewWriterSink(os.Stdout, lager.DEBUG))
	brokerLogger.RegisterSink(lager.NewWriterSink(os.Stderr, lager.ERROR))

	brokerLogger.Info("Starting CF Redis broker")

	brokerLogger.Info("Config File: " + brokerConfigPath)

	config, err := brokerconfig.ParseConfig(brokerConfigPath)
	if err != nil {
		brokerLogger.Fatal("Loading config file", err, lager.Data{
			"broker-config-path": brokerConfigPath,
		})
	}

	localRepo := redis.NewLocalRepository(config.RedisConfiguration, brokerLogger)
	setPidDir(localRepo)
	localRepo.AllInstancesVerbose()

	processController := redis.NewOSProcessController(
		brokerLogger,
		localRepo,
		new(process.ProcessChecker),
		new(process.ProcessKiller),
		redis.PingServer,
		availability.Check,
		"",
	)

	localCreator := &redis.LocalInstanceCreator{
		FindFreePort:            system.FindFreePort,
		RedisConfiguration:      config.RedisConfiguration,
		ProcessController:       processController,
		LocalInstanceRepository: localRepo,
	}

	agentClient := redis.NewRemoteAgentClient(
		config.AgentPort,
		config.AuthConfiguration.Username,
		config.AuthConfiguration.Password,
		true,
	)

	remoteRepo, err := redis.NewRemoteRepository(agentClient, config, brokerLogger)
	if err != nil {
		brokerLogger.Fatal("Error initializing remote repository", err)
	}

	if config.ConsistencyVerificationInterval > 0 {
		interval := time.Duration(config.ConsistencyVerificationInterval) * time.Second

		consistency.KeepVerifying(
			agentClient,
			config.RedisConfiguration.Dedicated.StatefilePath,
			interval,
			brokerLogger,
		)
	}

	sigChannel := make(chan os.Signal, 1)
	signal.Notify(sigChannel, syscall.SIGTERM)
	go func() {
		<-sigChannel
		brokerLogger.Info("Starting Redis Broker shutdown")
		consistency.StopVerifying()
		localRepo.AllInstancesVerbose()
		remoteRepo.StateFromFile()
		os.Exit(0)
	}()

	serviceBroker := &broker.RedisServiceBroker{
		InstanceCreators: map[string]broker.InstanceCreator{
			"shared":    localCreator,
			"dedicated": remoteRepo,
		},
		InstanceBinders: map[string]broker.InstanceBinder{
			"shared":    localRepo,
			"dedicated": remoteRepo,
		},
		Config: config,
	}

	brokerCredentials := brokerapi.BrokerCredentials{
		Username: config.AuthConfiguration.Username,
		Password: config.AuthConfiguration.Password,
	}

	brokerAPI := brokerapi.New(serviceBroker, brokerLogger, brokerCredentials)

	authWrapper := auth.NewWrapper(brokerCredentials.Username, brokerCredentials.Password)
	debugHandler := authWrapper.WrapFunc(debug.NewHandler(remoteRepo))
	instanceHandler := authWrapper.WrapFunc(redisinstance.NewHandler(remoteRepo))

	http.HandleFunc("/instance", instanceHandler)
	http.HandleFunc("/debug", debugHandler)
	http.Handle("/", brokerAPI)

	brokerLogger.Fatal("http-listen", http.ListenAndServe(config.Host+":"+config.Port, nil))
}

func configPath() string {
	brokerConfigYamlPath := os.Getenv("BROKER_CONFIG_PATH")
	if brokerConfigYamlPath == "" {
		panic("BROKER_CONFIG_PATH not set")
	}
	return brokerConfigYamlPath
}

func setPidDir(localRepo *redis.LocalRepository) {
	pidDir := os.Getenv("SHARED_PID_DIR")
	if pidDir != "" {
		localRepo.RedisConf.PidfileDirectory = pidDir
	}
}
