package byteflood

import (
	"fmt"
	"time"

	"github.com/op/go-logging"
)

type EventType string

const (
	MessageEvent   EventType = `message`
	HeartbeatEvent           = `heartbeat`
)

type Event struct {
	Type      EventType   `json:"type"`
	Payload   interface{} `json:"payload,omitempty"`
	Timestamp time.Time   `json:"timestamp"`
}

type EventDispatchBackend struct {
	logging.Backend
	level logging.Level
	app   *Application
}

func NewEventDispatchBackend(app *Application, level logging.Level) *EventDispatchBackend {
	return &EventDispatchBackend{
		level: level,
		app:   app,
	}
}

func (self *EventDispatchBackend) Log(level logging.Level, calldepth int, record *logging.Record) error {
	if level <= self.level {
		fmt.Printf("%v %v %+v\n", level, calldepth, record)
	}

	return nil
}
