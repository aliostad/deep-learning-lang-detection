package modules

import (
	"github.com/ineiti/cybermind/broker"
	"github.com/ineiti/cybermind/modules/data"
	"github.com/ineiti/cybermind/modules/input"
	"github.com/ineiti/cybermind/modules/transfer"
	"github.com/ineiti/cybermind/modules/user"
)

func RegisterAll(broker *broker.Broker) {
	if err := data.RegisterConfig(broker); err != nil {
		return err
	}
	if err := data.RegisterNode(broker); err != nil {
		return err
	}
	if err := input.RegisterSMS(broker); err != nil {
		return err
	}
	if err := transfer.RegisterServer(broker); err != nil {
		return err
	}
	if err := user.RegisterWeb(broker); err != nil {
		return err
	}
	if err := user.RegisterCLI(broker); err != nil {
		return err
	}

}
