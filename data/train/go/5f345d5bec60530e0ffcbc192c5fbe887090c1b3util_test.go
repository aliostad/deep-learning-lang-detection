package thermocline_test

import (
	"testing"

	"github.com/fortytw2/thermocline"
	"github.com/fortytw2/thermocline/brokers/mem"
)

// SetupBroker is a test utility function
func SetupBroker(t *testing.T) (thermocline.Broker, <-chan *thermocline.Task, chan<- *thermocline.Task) {
	var broker thermocline.Broker
	broker = mem.NewBroker()

	reader, err := broker.Read("test", thermocline.NoVersion)
	if err != nil {
		t.Errorf("could not open queue '%s'", err)
	}

	writer, err := broker.Write("test", thermocline.NoVersion)
	if err != nil {
		t.Errorf("could not open queue '%s'", err)
	}

	return broker, reader, writer
}
