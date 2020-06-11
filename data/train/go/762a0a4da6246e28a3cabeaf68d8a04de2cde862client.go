package client

import (
	"encoding/json"

	"github.com/hyperboloide/dispatch"
)

// Mailer sends a mail to the queue
type Mailer struct {
	Queue dispatch.Queue
}

// Mail represents an email
type Mail struct {
	Dests    []string    `json:"dests"`
	Subject  string      `json:"subject"`
	Template string      `json:"template"`
	Data     interface{} `json:"data"`
	Files    []string    `json:"files"`
}

// New creates a new Mailer
func New(name, connecion string) (*Mailer, error) {
	q, err := dispatch.NewAMQPQueue(name, connecion)
	return &Mailer{q}, err
}

// Send a message
func (m Mailer) Send(msg Mail) error {
	buff, err := json.Marshal(msg)
	if err != nil {
		return err
	}
	return m.Queue.SendBytes(buff)
}
