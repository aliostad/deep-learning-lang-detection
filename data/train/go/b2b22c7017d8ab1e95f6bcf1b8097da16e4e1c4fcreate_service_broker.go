package servicebroker

import (
	"errors"
	"github.com/starkandwayne/cf-cli/cf/api"
	"github.com/starkandwayne/cf-cli/cf/command_metadata"
	"github.com/starkandwayne/cf-cli/cf/configuration"
	"github.com/starkandwayne/cf-cli/cf/requirements"
	"github.com/starkandwayne/cf-cli/cf/terminal"
	"github.com/codegangsta/cli"
)

type CreateServiceBroker struct {
	ui                terminal.UI
	config            configuration.Reader
	serviceBrokerRepo api.ServiceBrokerRepository
}

func NewCreateServiceBroker(ui terminal.UI, config configuration.Reader, serviceBrokerRepo api.ServiceBrokerRepository) (cmd CreateServiceBroker) {
	cmd.ui = ui
	cmd.config = config
	cmd.serviceBrokerRepo = serviceBrokerRepo
	return
}

func (command CreateServiceBroker) Metadata() command_metadata.CommandMetadata {
	return command_metadata.CommandMetadata{
		Name:        "create-service-broker",
		Description: "Create a service broker",
		Usage:       "CF_NAME create-service-broker SERVICE_BROKER USERNAME PASSWORD URL",
	}
}

func (cmd CreateServiceBroker) GetRequirements(requirementsFactory requirements.Factory, c *cli.Context) (reqs []requirements.Requirement, err error) {

	if len(c.Args()) != 4 {
		err = errors.New("Incorrect usage")
		cmd.ui.FailWithUsage(c)
		return
	}

	reqs = append(reqs, requirementsFactory.NewLoginRequirement())

	return
}

func (cmd CreateServiceBroker) Run(c *cli.Context) {
	name := c.Args()[0]
	username := c.Args()[1]
	password := c.Args()[2]
	url := c.Args()[3]

	cmd.ui.Say("Creating service broker %s as %s...",
		terminal.EntityNameColor(name),
		terminal.EntityNameColor(cmd.config.Username()),
	)

	apiErr := cmd.serviceBrokerRepo.Create(name, url, username, password)
	if apiErr != nil {
		cmd.ui.Failed(apiErr.Error())
		return
	}

	cmd.ui.Ok()
}
