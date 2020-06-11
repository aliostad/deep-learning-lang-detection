package base

import (
	"testing"

	"github.com/ineiti/cybermind/broker"
	"github.com/ineiti/cybermind/modules/test"
	"github.com/stretchr/testify/require"
	"gopkg.in/dedis/onet.v1/log"
)

func TestRegisterToml(t *testing.T) {
	tt := initTest(0)
	defer tt.Broker.Stop()
	require.NotNil(t, tt.Config)
}

func TestConfig_ProcessMessage(t *testing.T) {
	log.Lvl1("Creating first testInput-module")
	tt := initTest(0)
	log.ErrFatal(tt.Broker.Start())
	log.ErrFatal(tt.Broker.BroadcastMessage(&broker.Message{
		ID: broker.NewMessageID(),
		Action: broker.Action{
			Command: broker.SubDomain("spawn", "config"),
			Arguments: map[string]string{
				"module": test.ModuleTestInput,
			},
		},
	}))
	require.Equal(t, 3, len(tt.Broker.ModuleEntries))
	log.ErrFatal(tt.Broker.Stop())

	log.Lvl1("Re-starting broker and checking for testInput-Module")
	tt = initTest(0)
	defer tt.Broker.Stop()
	log.ErrFatal(tt.Broker.Start())
	require.Equal(t, 3, len(tt.Broker.ModuleEntries))
	require.Equal(t, test.ModuleTestInput, tt.Broker.ModuleEntries[2].Name)
}

type testConfig struct {
	Broker *broker.Broker
	Config *Config
}

func initTest(cmd int) *testConfig {
	tt := &testConfig{
		Broker: broker.NewBroker(),
	}
	log.ErrFatal(RegisterConfig(tt.Broker))
	log.ErrFatal(RegisterStorage(tt.Broker))
	tt.Config = tt.Broker.ModuleEntries[0].Module.(*Config)
	log.ErrFatal(test.RegisterTestInput(tt.Broker))
	return tt
}
