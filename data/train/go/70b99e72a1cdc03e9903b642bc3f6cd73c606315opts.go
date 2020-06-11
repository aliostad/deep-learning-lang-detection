package cmd

type CommandOpts struct {
	// -----> Global options
	StartServer StartServerOpts `command:"start-server" short:"s" description:"start the servive broker server"`

	VersionOpt func() error `long:"version" short:"v" description:"Show Service Brokere version"`
	Help       HelpOpts     `command:"help" short:"h" description:"Show this help message"`

	JSONOpt           bool `long:"json"                      description:"Output as JSON"`
	NonInteractiveOpt bool `long:"non-interactive" short:"n" description:"Don't ask for user input"`
	TTYOpt            bool `long:"tty"                       description:"Force TTY-like output"`
	NoColorOpt        bool `long:"no-color"                  description:"Toggle colorized output"`
}

type StartServerOpts struct {
	Port                  int    `long:"port" short:"p" description:"Port of Service Broker" default:"8080" env:"PORT"`
	ConfigPath            string `long:"config" short:"c" description:"Path to config with plans"`
	ServiceID             string `long:"service-broker-id" descrition:"service broker service id" default:"service-broker" env:"SERVICE_BROKER_ID"`
	Name                  string `long:"service-broker-name" descrition:"service broker name" default:"service-broker" env:"SERVICE_BROKER_NAME"`
	Description           string `long:"service-broker-description" descrition:"service broker name" default:"Service for running destructive tests on a app" env:"SERVICE_BROKER_DESCRIPTION"`
	ServiceBrokerUsername string `long:"service-broker-username" description:"broker-username" default:"service-broker" env:"SERVICE_BROKER_USERNAME"`
	ServiceBrokerPassword string `long:"service-broker-password" description:"broker-password" default:"c1oudc0w" env:"SERVICE_BROKER_PASSWORD"`

	cmd
}

// MessageOpts is used for version and help flags
type MessageOpts struct {
	Message string
}

type HelpOpts struct {
	cmd
}

type cmd struct{}
