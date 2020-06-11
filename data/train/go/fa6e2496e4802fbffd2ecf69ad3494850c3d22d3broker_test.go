package apiserver

import (
	"context"
	"github.com/Sirupsen/logrus"
	"github.com/stretchr/testify/require"
	"sync"
	"testing"
)

func Test_BytesBroker(t *testing.T) {
	ctx, cancel := context.WithCancel(context.Background())
	var wg sync.WaitGroup
	payload := BrokerEvent{Name: "test", Data: []byte{1}}

	logrus.SetLevel(logrus.DebugLevel)

	broker := NewBroker(ctx)
	require.NoError(t, broker.Run(&wg))

	t.Run("should register/deregister clients", func(t *testing.T) {
		var evt BrokerEvent

		// add first client
		clientA := make(chan BrokerEvent, 1)
		broker.Add(clientA)
		go broker.Notify(payload)

		// receive message
		evt = <-clientA
		require.Equal(t, payload, evt)
		require.Equal(t, 1, broker.length())

		// add second client
		clientB := make(chan BrokerEvent, 1)
		broker.Add(clientB)
		go broker.Notify(payload)

		// receive
		evt = <-clientA
		require.Equal(t, payload, evt)

		// receive
		evt = <-clientB
		require.Equal(t, payload, evt)

		// remove first client
		require.Equal(t, 2, broker.length())
		broker.Remove(clientA)

		go broker.Notify(payload)

		// receive
		evt = <-clientB
		require.Equal(t, payload, evt)
		require.Equal(t, 1, broker.length())

		broker.Remove(clientB)
	})

	cancel()
	wg.Wait()
}
