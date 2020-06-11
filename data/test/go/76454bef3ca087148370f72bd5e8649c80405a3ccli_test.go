package user

import (
	"testing"

	"github.com/ineiti/cybermind/broker"
	"github.com/stretchr/testify/assert"
	"gopkg.in/dedis/onet.v1/log"
)

func TestRegisterCLI(t *testing.T) {
	b := broker.NewBroker()
	log.ErrFatal(RegisterCLI(b))
	b.Stop()
}

func TestNewCLI(t *testing.T) {
	log.Lvl2("Launching broker")
	b := broker.NewBroker()
	log.Lvl2("Creating CLI")
	mod := NewCLI(b, nil).(*CLI)
	log.Lvl2("Asking for list")
	rep, err := CLICmd(broker.ConfigPath, "list")
	log.ErrFatal(err)
	assert.True(t, len(rep) > 0)
	log.Lvl2("Got reply:", string(rep))
	log.Lvl2("Going to stop CLI")
	mod.Stop()
}
