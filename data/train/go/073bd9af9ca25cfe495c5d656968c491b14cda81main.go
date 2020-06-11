package main

import (
	"os"

	"github.com/pivotal-cf/cf-redis-broker/brokerconfig"
	"github.com/pivotal-cf/cf-redis-broker/configmigrator"
	"code.cloudfoundry.org/lager"
)

func main() {
	brokerConfigPath := configPath()

	log := lager.NewLogger("redis-configmigrator")
	log.RegisterSink(lager.NewWriterSink(os.Stdout, lager.DEBUG))
	log.RegisterSink(lager.NewWriterSink(os.Stderr, lager.ERROR))

	log.Info("Config File: " + brokerConfigPath)

	config, err := brokerconfig.ParseConfig(brokerConfigPath)
	if err != nil {
		log.Fatal("Loading config file", err, lager.Data{
			"broker-config-path": brokerConfigPath,
		})
	}

	migrator := &configmigrator.ConfigMigrator{
		RedisDataDir: config.RedisConfiguration.InstanceDataDirectory,
	}

	err = migrator.Migrate()
	if err != nil {
		log.Fatal("Could not migrate data", err)
	}
}

func configPath() string {
	brokerConfigYamlPath := os.Getenv("BROKER_CONFIG_PATH")
	if brokerConfigYamlPath == "" {
		panic("BROKER_CONFIG_PATH not set")
	}
	return brokerConfigYamlPath
}
