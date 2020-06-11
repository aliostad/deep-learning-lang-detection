package main

import (
	"net/http"
	"os"

	"github.com/FoOTOo/cf-mongodb-broker/broker"
	"github.com/FoOTOo/cf-mongodb-broker/config"
	"github.com/pivotal-cf/brokerapi"

	"code.cloudfoundry.org/lager"
	"github.com/FoOTOo/cf-mongodb-broker/mongo"
)

const (
	BrokerName = "cf-mongodb-broker"
)

func main() {
	brokerLogger := lager.NewLogger(BrokerName)
	//brokerLogger.RegisterSink(lager.NewWriterSink(os.Stdout, lager.INFO))
	brokerLogger.RegisterSink(lager.NewWriterSink(os.Stdout, lager.DEBUG))
	brokerLogger.RegisterSink(lager.NewWriterSink(os.Stderr, lager.ERROR))

	brokerLogger.Info("Starting Mongodb broker")

	// Config
	brokerConfigPath := configPath()
	config, err := config.ParseConfig(brokerConfigPath)
	if err != nil {
		brokerLogger.Fatal("Loading config file", err, lager.Data{
			"broker-config-path": brokerConfigPath,
		})
	}

	//adminService, err := mongo.NewAdminService("172.16.0.156", "rootusername", "rootpassword", "admin")
	adminService, err := mongo.NewAdminService(config.MongoHosts(), config.MongoUsername(), config.MongoPassword(), config.ReplSetName(), "admin")

	if err != nil {
		brokerLogger.Fatal("mongo-admin-service", err)
		return
	}

	repository := mongo.NewRepository(adminService)

	instanceCreator := mongo.NewInstanceCreator(adminService, repository)
	instanceBinder := mongo.NewInstanceBinder(adminService, repository)

	serviceBroker := &broker.MongoServiceBroker{
		InstanceCreators: map[string]broker.InstanceCreator{
			"standard": instanceCreator,
		},
		InstanceBinders: map[string]broker.InstanceBinder{
			"standard": instanceBinder,
		},
		Config: config,
	}

	brokerCredentials := brokerapi.BrokerCredentials{
		Username: config.BrokerConfig.BrokerUsername,
		Password: config.BrokerConfig.BrokerPassword,
	}

	// broker
	brokerAPI := brokerapi.New(serviceBroker, brokerLogger, brokerCredentials)

	// authWrapper := auth.NewWrapper(brokerCredentials.Username, brokerCredentials.Password)
	// TODO: ??? /instance /debug

	http.Handle("/", brokerAPI)

	brokerLogger.Fatal("http-listen", http.ListenAndServe(":"+"80", nil)) // TODO: ???Listening on host in config
}

func configPath() string {
	brokerConfigYamlPath := os.Getenv("BROKER_CONFIG_PATH")
	if brokerConfigYamlPath == "" {
		panic("BROKER_CONFIG_PATH not set")
	}
	return brokerConfigYamlPath
}
