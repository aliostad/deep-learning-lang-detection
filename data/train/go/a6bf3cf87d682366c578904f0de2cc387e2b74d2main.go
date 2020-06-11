package main

import (
	"fmt"
	"log"
	"net/http"
	"os"

	"cf-pagerduty-service/servicebroker/broker"
	"cf-pagerduty-service/servicebroker/integrations"

	"code.cloudfoundry.org/lager"
	"github.com/pivotal-cf/brokerapi"
)

func main() {
	logger := lager.NewLogger("p-pagerduty-broker")
	logger.RegisterSink(lager.NewWriterSink(os.Stdout, lager.DEBUG))
	logger.RegisterSink(lager.NewWriterSink(os.Stdout, lager.ERROR))

	// brokerConfigPath := configPath()

	brokerCredentials := brokerapi.BrokerCredentials{
		Username: getEnv("SECURITY_USER_NAME", "admin"),
		Password: getEnv("SECURITY_USER_PASSWORD", "pagerduty"),
	}

	// parsedConfig, err := config.ParseConfig(brokerConfigPath)
	// if err != nil {
	// 	logger.Fatal("Loading config file", err, lager.Data{
	// 		"broker-config-path": brokerConfigPath,
	// 	})
	// }
	parsedIntegrations, err := integrations.ParseIntegrations("integrations/integrations.yml")
	if err != nil {
		logger.Fatal("Loading integrations file", err)
	}

	service := &broker.PagerDutyBroker{
		// Config:       parsedConfig,
		Integrations: parsedIntegrations,
	}

	newBroker := brokerapi.New(service, logger, brokerCredentials)

	http.Handle("/", newBroker)

	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	logger.Fatal("http-listen", http.ListenAndServe(":"+port, nil))
}

func configPath() string {
	defaultConfigYamlPath := "config.yml"

	brokerConfigYamlPath := os.Getenv("BROKER_CONFIG_PATH")
	if brokerConfigYamlPath == "" {
		fmt.Printf("BROKER_CONFIG_PATH not set, using '%v'", defaultConfigYamlPath)
		return defaultConfigYamlPath
	}
	return brokerConfigYamlPath
}

func getEnv(env string, defaultValue string) string {
	var v string
	if v = os.Getenv(env); len(v) == 0 {
		log.Printf("Using default value for %v", env)
		return defaultValue
	}

	return v
}
