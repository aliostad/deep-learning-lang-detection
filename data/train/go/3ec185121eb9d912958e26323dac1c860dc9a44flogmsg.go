package test

import (
	"strings"

	"fmt"

	"github.com/ineiti/cybermind/broker"
	"gopkg.in/dedis/onet.v1/log"
)

const ModuleLogger = "testLogger"

type Logger struct {
	Broker   *broker.Broker
	Messages []*broker.Message
	DebugLvl int
}

func SpawnLogger(b *broker.Broker) *Logger {
	b.RegisterModule(ModuleLogger, NewLogger)
	b.SpawnModule(ModuleLogger, nil, nil)
	return b.ModuleEntries[len(b.ModuleEntries)-1].Module.(*Logger)
}

func NewLogger(b *broker.Broker, id broker.ModuleID, msg *broker.Message) broker.Module {
	return &Logger{
		Broker:   b,
		DebugLvl: 2,
	}
}

func (l *Logger) ProcessMessage(m *broker.Message) ([]broker.Message, error) {
	l.Messages = append(l.Messages, m)
	if l.DebugLvl <= log.DebugVisible() {
		fmt.Printf("%d: %s\n", len(l.Messages), m)
	}
	return nil, nil
}

func (l *Logger) String() string {
	ret := []string{"Logger messages:"}
	for i, m := range l.Messages {
		ret = append(ret, fmt.Sprintf("%d: %s", i, m))
	}
	return strings.Join(ret, "\n")
}
