package broker

import (
	"testing"

	"errors"

	"github.com/stretchr/testify/assert"
	"gopkg.in/dedis/onet.v1/log"
)

func TestMain(m *testing.M) {
	log.MainTest(m, 3)
}

func TestNewBroker(t *testing.T) {
	b := NewBroker()
	assert.NotNil(t, b)
}

func TestBroker_RegisterModule(t *testing.T) {
	tb := initBroker(None)
	log.ErrFatal(tb.Broker.RegisterModule(testName, newTest))
	assert.NotNil(t, tb.Broker.RegisterModule(testName, newTest))
	assert.Equal(t, 1, len(tb.Broker.ModuleTypes))
}

func TestBroker_SpawnModule(t *testing.T) {
	tb := initBroker(RegisterTest)
	assert.NotNil(t, tb.Broker.SpawnModule("unknown", nil))
	log.ErrFatal(tb.Broker.SpawnModule(testName, nil))
}

func TestBroker_Start(t *testing.T) {
	tb := initBroker(RegisterTest)
	assert.NotNil(t, tb.Broker.Start())
	tb = initBroker(SpawnTest)
	tm := tb.Broker.Modules[0].(*testModule)
	assert.Equal(t, 0, tm.Mesages)
	log.ErrFatal(tb.Broker.Start())
	assert.Equal(t, 1, tm.Mesages)
}

func TestBroker_Stop(t *testing.T) {
	tb := initBroker(StartBroker)
	log.ErrFatal(tb.Broker.Stop())
}

func TestBroker_NewMessage(t *testing.T) {
	tb := initBroker(StartBroker)
	assert.Equal(t, 1, tb.Test.Mesages)
	tb.Broker.BroadcastMessage(&Message{})
	assert.Equal(t, 2, tb.Test.Mesages)
	log.ErrFatal(tb.Broker.BroadcastMessage(&Message{
		Objects: []Object{{}},
	}))
	assert.Equal(t, 4, tb.Test.Mesages)
	log.ErrFatal(tb.Broker.BroadcastMessage(&Message{
		Objects: []Object{{}, {}},
	}))
	assert.Equal(t, 7, tb.Test.Mesages)
	tb.Test.ReturnError = 1
	assert.NotNil(t, tb.Broker.BroadcastMessage(nil))
	tb.Test.ReturnError = 2
	assert.NotNil(t, tb.Broker.BroadcastMessage(&Message{
		Objects: []Object{{}},
	}))
}

type testBroker struct {
	Broker *Broker
	Test   *testModule
}

const (
	None = iota
	RegisterTest
	SpawnTest
	StartBroker
)

func initBroker(cmds int) *testBroker {
	tb := &testBroker{
		Broker: NewBroker(),
	}
	for cmd := 1; cmd <= cmds; cmd++ {
		switch cmd {
		case RegisterTest:
			tb.Broker.RegisterModule(testName, newTest)
		case SpawnTest:
			tb.Broker.SpawnModule(testName, nil)
			tb.Test = tb.Broker.Modules[0].(*testModule)
		case StartBroker:
			tb.Broker.Start()
		}
	}
	return tb
}

const testName = "test"

type testModule struct {
	Broker      *Broker
	ID          int
	Mesages     int
	ReturnError int
}

func newTest(b *Broker, msg *Message) Module {
	id := 0
	if msg != nil &&
		msg.Tags != nil &&
		msg.Tags.GetLastValue("config") != nil {
		id = 1
	}
	return &testModule{
		Broker: b,
		ID:     id,
	}
}

func (t *testModule) ProcessMessage(m *Message) ([]Message, error) {
	var ret []Message
	if t.ReturnError > 0 {
		t.ReturnError--
		if t.ReturnError == 0 {
			return nil, errors.New("ReturnError is 0 now")
		}
	}
	if m == nil {
		log.Lvl2("starting test-module")
	} else {
		var objs []Object
		if len(objs) > 1 {
			objs = m.Objects[1:]
		}
		for range m.Objects {
			ret = append(ret, Message{
				Objects: objs,
			})
		}
	}
	t.Mesages += 1
	return ret, nil
}
