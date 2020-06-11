package kage

import "github.com/msales/kage/store"

// Reporter represents a offset reporter.
type Reporter interface {
	// ReportBrokerOffsets reports a snapshot of the broker offsets.
	ReportBrokerOffsets(o *store.BrokerOffsets)

	// ReportBrokerMetadata reports a snapshot of the broker metadata.
	ReportBrokerMetadata(o *store.BrokerMetadata)

	// ReportConsumerOffsets reports a snapshot of the consumer group offsets.
	ReportConsumerOffsets(o *store.ConsumerOffsets)
}

// Reporters represents a set of reporters.
type Reporters map[string]Reporter

// Add adds a Reporter to the set.
func (rs *Reporters) Add(key string, r Reporter) {
	(*rs)[key] = r
}

// ReportBrokerOffsets reports a snapshot of the broker offsets on all reporters.
func (rs *Reporters) ReportBrokerOffsets(v *store.BrokerOffsets) {
	for _, r := range *rs {
		r.ReportBrokerOffsets(v)
	}
}

// ReportBrokerMetadata reports a snapshot of the broker metadata.
func (rs *Reporters) ReportBrokerMetadata(v *store.BrokerMetadata) {
	for _, r := range *rs {
		r.ReportBrokerMetadata(v)
	}
}

// ReportConsumerOffsets reports a snapshot of the consumer group offsets on all reporters.
func (rs *Reporters) ReportConsumerOffsets(v *store.ConsumerOffsets) {
	for _, r := range *rs {
		r.ReportConsumerOffsets(v)
	}
}
