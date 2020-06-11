package texto

import (
	"context"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestNewServer(t *testing.T) {
	logger := newLogger()
	addr := ":8080"
	broker := newDummyBroker()
	server, err := NewServer(context.Background(), logger, addr, broker)
	assert.Nil(t, err)
	assert.Equal(t, logger, server.Log)
	assert.Equal(t, broker, server.Broker)
	assert.Equal(t, addr, server.HTTPServer.Addr)
}

func TestServer_Stop(t *testing.T) {
	logger := newLogger()
	addr := ":8080"
	broker := newDummyBroker()
	server, err := NewServer(context.Background(), logger, addr, broker)
	assert.Nil(t, err)
	go server.Run()
	err = server.Stop()
	assert.Nil(t, err)
}
