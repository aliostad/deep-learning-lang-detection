package cmd

type CommandOpts struct {
	// -----> Global options
	Version               func() error `long:"version" short:"v" description:"Show Service Brokere version"`
	ChaosLorisHost        string       `long:"chaos-loris-host" description:"Fetch variables" env:"CHAOS_LORIS_HOST"`
	Port                  int          `long:"port" short:"p" description:"Port of Service Broker" default:"8080" env:"PORT"`
	ConfigPath            string       `long:"config" short:"c" description:"Path to config with plans"`
	ServiceID             string       `long:"service-broker-id" descrition:"service broker service id" default:"chaos-loris" env:"SERVICE_BROKER_ID"`
	Name                  string       `long:"service-broker-name" descrition:"service broker name" default:"chaos-loris" env:"SERVICE_BROKER_NAME"`
	Description           string       `long:"service-broker-description" descrition:"service broker name" default:"Service for running destructive tests on a app" env:"SERVICE_BROKER_DESCRIPTION"`
	ServiceBrokerUsername string       `long:"service-broker-username" description:"broker-username" default:"loris"`
	ServiceBrokerPassword string       `long:"service-broker-password" description:"broker-password" default:"cha0s-l0r1s"`
	Help                  bool         `long:"help" short:"h" description:"Show this help message"`
}
