package mcg

import "fmt"

// -----------------------------------------------------------------------------
// -- Broker
// -----------------------------------------------------------------------------

// Broker DOC: ..
type Broker struct {
	Topic string
	agent Agent
}

// NewBroker DOC: ..
func NewBroker(topic string, agent Agent) *Broker {
	return &Broker{
		Topic: topic,
		agent: agent,
	}
}

// ---

// Start DOC: ..
func (b *Broker) Start() error {
	return b.agent.Done()
}

// Close DOC: ..
func (b *Broker) Close() error {
	if b.agent != nil {
		return b.agent.Close()
	}

	return fmt.Errorf("no agent found; cannot close any further")
}

// ---

// Send DOC: ..
func (b *Broker) Send(key string, context Context, parts ...Part) error {
	if b.agent == nil {
		return fmt.Errorf("agent not defined")
	}

	return b.agent.Send(b.Topic, key, &Message{
		Context: context,
		Body:    parts,
	})
}

// Handle DOC: ..
func (b *Broker) Handle(key string, limit int, handler HandlerFunc) chan error {
	var err_chan chan error

	if b.agent != nil {
		go func() {
			if err := b.agent.Receive(b.Topic, key, limit, handler); err != nil {
				err_chan <- err
			}
		}()
	}

	return err_chan
}
