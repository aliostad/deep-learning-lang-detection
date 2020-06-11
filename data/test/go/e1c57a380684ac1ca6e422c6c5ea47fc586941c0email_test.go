package input

import (
	"testing"

	"os"
	"path/filepath"

	"github.com/emersion/go-imap/server"
	"github.com/ineiti/cybermind/broker"
	"github.com/ineiti/cybermind/modules/base"
	"github.com/ineiti/cybermind/modules/test"
	"github.com/stretchr/testify/require"
	"gopkg.in/dedis/onet.v1/log"
)

func TestEmail_Start(t *testing.T) {
	te := newTestEmail(true, 0)
	te.Broker.Start()
	defer te.Close()
	log.ErrFatal(base.SpawnModule(te.Broker, ModuleEmail,
		"Plain://username:password@localhost:1143"))

	require.Equal(t, 4, len(te.Broker.ModuleEntries))
	log.Lvl2(te.Logger.Messages)
}

func TestEmail_Restart(t *testing.T) {
	var id broker.ModuleID
	func() {
		te := newTestEmail(true, 1)
		defer te.Close()
		log.ErrFatal(base.SpawnModule(te.Broker, ModuleEmail,
			"Plain://username:password@localhost:1143"))
		log.Lvl2(te.Broker.ModuleEntries)
		id = te.Broker.ModuleEntries[len(te.Broker.ModuleEntries)-1].Module.(*Email).moduleid
		log.Lvl2(te.Logger.Messages)
	}()

	te := newTestEmail(false, 1)
	defer te.Close()

	log.Lvlf2("%+v", te.Broker.ModuleEntries)
	log.Lvl2(te.Logger.Messages)
	require.Equal(t, 4, len(te.Broker.ModuleEntries))
	require.Equal(t, id, te.Broker.ModuleEntries[len(te.Broker.ModuleEntries)-1].Module.(*Email).moduleid)
}

func TestEmail_GetNew(t *testing.T) {
	te := newTestEmail(true, 2)
	defer te.Close()
	log.Lvl1(te.Logger)
}

type testEmail struct {
	Broker *broker.Broker
	Logger *test.Logger
	IMAP   *server.Server
}

func newTestEmail(reset bool, cmd int) *testEmail {
	if reset {
		path := filepath.Join(broker.ConfigPath, base.StorageDB)
		os.Remove(path)
	}
	te := &testEmail{
		Broker: broker.NewBroker(),
	}
	te.Logger = test.SpawnLogger(te.Broker)
	log.ErrFatal(base.RegisterStorage(te.Broker))
	log.ErrFatal(base.RegisterConfig(te.Broker))
	log.ErrFatal(test.RegisterTestInput(te.Broker))
	log.ErrFatal(RegisterEmail(te.Broker))
	te.IMAP = startIMAPServer()

	for i := 1; i <= cmd; i++ {
		switch i {
		case 1:
			te.Broker.Start()
		case 2:
			log.ErrFatal(base.SpawnModule(te.Broker, ModuleEmail,
				"Plain://username:password@localhost:1143"))
		}
	}
	return te
}

func (te *testEmail) Close() {
	te.IMAP.Close()
	te.Broker.Stop()
}
