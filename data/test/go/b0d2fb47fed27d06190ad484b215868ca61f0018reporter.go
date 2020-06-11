package mocks

import (
	"github.com/msales/kage/store"
	"github.com/stretchr/testify/mock"
)

// MockReporter represents a mock Reporter.
type MockReporter struct {
	mock.Mock
}

// ReportBrokerOffsets reports a snapshot of the broker offsets.
func (m *MockReporter) ReportBrokerOffsets(v *store.BrokerOffsets) {
	m.Called(v)
}

// ReportConsumerOffsets reports a snapshot of the consumer group offsets.
func (m *MockReporter) ReportConsumerOffsets(v *store.ConsumerOffsets) {
	m.Called(v)
}

// ReportBrokerMetadata reports a snapshot of the broker metadata.
func (m *MockReporter) ReportBrokerMetadata(v *store.BrokerMetadata) {
	m.Called(v)
}
