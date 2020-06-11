package mocks

import (
	"github.com/msales/kage/store"
	"github.com/stretchr/testify/mock"
)

// MockStore represents a mock offset store.
type MockStore struct {
	mock.Mock
}

// SetState adds a state into the store.
func (m *MockStore) SetState(v interface{}) error {
	args := m.Called(v)
	return args.Error(0)
}

// BrokerOffsets returns a snapshot of the current broker offsets.
func (m *MockStore) BrokerOffsets() store.BrokerOffsets {
	args := m.Called()
	return args.Get(0).(store.BrokerOffsets)
}

// ConsumerOffsets returns a snapshot of the current consumer group offsets.
func (m *MockStore) ConsumerOffsets() store.ConsumerOffsets {
	args := m.Called()
	return args.Get(0).(store.ConsumerOffsets)
}

// BrokerMetadata returns a snapshot of the current broker metadata.
func (m *MockStore) BrokerMetadata() store.BrokerMetadata {
	args := m.Called()
	return args.Get(0).(store.BrokerMetadata)
}

// Channel get the offset channel.
func (m *MockStore) Channel() chan interface{} {
	args := m.Called()
	return args.Get(0).(chan interface{})
}

// Close gracefully stops the Store.
func (m *MockStore) Close() {
	m.Called()
}
