package kafka

import (
	"testing"

	"github.com/Shopify/sarama"
	"github.com/msales/kage/testutil"
	"github.com/stretchr/testify/assert"
)

func TestMonitor_Brokers(t *testing.T) {
	broker0 := sarama.NewMockBroker(t, 0)
	broker1 := sarama.NewMockBroker(t, 1)
	broker0.SetHandlerByMap(map[string]sarama.MockResponse{
		"MetadataRequest": sarama.NewMockMetadataResponse(t).
			SetBroker(broker0.Addr(), broker0.BrokerID()).
			SetBroker(broker1.Addr(), broker1.BrokerID()).
			SetLeader("foo", 0, broker1.BrokerID()),
	})

	kafka, err := sarama.NewClient([]string{broker0.Addr()}, sarama.NewConfig())
	if err != nil {
		t.Fatal(err)
	}

	c := &Monitor{client: kafka}

	assert.Len(t, c.Brokers(), 2)

	broker0.Close()
	broker1.Close()
}

func TestMonitor_RefreshMetadata(t *testing.T) {
	broker := sarama.NewMockBroker(t, 0)
	broker.SetHandlerByMap(map[string]sarama.MockResponse{
		"MetadataRequest": sarama.NewMockMetadataResponse(t).
			SetBroker(broker.Addr(), broker.BrokerID()).
			SetLeader("foo", 0, broker.BrokerID()),
	})

	kafka, err := sarama.NewClient([]string{broker.Addr()}, sarama.NewConfig())
	if err != nil {
		t.Fatal(err)
	}

	c := &Monitor{client: kafka}

	c.refreshMetadata()

	broker.Close()
}

func TestMonitor_IsHealthy(t *testing.T) {
	broker := sarama.NewMockBroker(t, 0)
	broker.SetHandlerByMap(map[string]sarama.MockResponse{
		"MetadataRequest": sarama.NewMockMetadataResponse(t).
			SetBroker(broker.Addr(), broker.BrokerID()).
			SetLeader("foo", 0, broker.BrokerID()),
	})

	kafka, err := sarama.NewClient([]string{broker.Addr()}, sarama.NewConfig())
	assert.NoError(t, err)
	for _, b := range kafka.Brokers() {
		b.Open(kafka.Config())
	}

	c := &Monitor{client: kafka}

	assert.True(t, c.IsHealthy())

	// Close all broker connections
	for _, b := range kafka.Brokers() {
		b.Close()
	}

	assert.False(t, c.IsHealthy())

	broker.Close()
}

func TestMonitor_getBrokerOffsets(t *testing.T) {
	broker := sarama.NewMockBroker(t, 0)
	broker.SetHandlerByMap(map[string]sarama.MockResponse{
		"MetadataRequest": sarama.NewMockMetadataResponse(t).
			SetBroker(broker.Addr(), broker.BrokerID()).
			SetLeader("foo", 0, broker.BrokerID()).
			SetLeader("ignore", 0, broker.BrokerID()),
		"OffsetRequest": sarama.NewMockOffsetResponse(t).
			SetOffset("foo", 0, sarama.OffsetOldest, 0).
			SetOffset("foo", 0, sarama.OffsetNewest, 123),
	})

	kafka, err := sarama.NewClient([]string{broker.Addr()}, nil)
	assert.NoError(t, err)

	c := &Monitor{
		client:       kafka,
		stateCh:      make(chan interface{}, 100),
		log:          testutil.Logger,
		ignoreTopics: []string{"ignore"},
	}

	c.getBrokerOffsets()

	assert.Len(t, c.stateCh, 2)

	broker.Close()
}

func TestMonitor_getBrokerMetadata(t *testing.T) {
	broker := sarama.NewMockBroker(t, 0)
	broker.SetHandlerByMap(map[string]sarama.MockResponse{
		"MetadataRequest": sarama.NewMockMetadataResponse(t).
			SetBroker(broker.Addr(), broker.BrokerID()).
			SetLeader("foo", 0, broker.BrokerID()).
			SetLeader("ignore", 0, broker.BrokerID()),
	})

	kafka, err := sarama.NewClient([]string{broker.Addr()}, sarama.NewConfig())
	assert.NoError(t, err)
	for _, b := range kafka.Brokers() {
		b.Open(kafka.Config())
	}

	c := &Monitor{
		client:  kafka,
		stateCh: make(chan interface{}, 100),
		log:     testutil.Logger,
		ignoreTopics: []string{"ignore"},
	}

	c.getBrokerMetadata()

	assert.Len(t, c.stateCh, 1)

	broker.Close()
}

func TestMonitor_getConsumerOffsets(t *testing.T) {
	broker := sarama.NewMockBroker(t, 0)

	metadata := new(sarama.MetadataResponse)
	metadata.AddTopicPartition("foo", 0, broker.BrokerID(), nil, nil, sarama.ErrNoError)
	metadata.AddTopicPartition("unread", 0, broker.BrokerID(), nil, nil, sarama.ErrNoError)
	metadata.AddTopicPartition("ignore", 0, broker.BrokerID(), nil, nil, sarama.ErrNoError)
	metadata.AddBroker(broker.Addr(), broker.BrokerID())
	broker.Returns(metadata)

	broker.Returns(&sarama.ListGroupsResponse{
		Err:    sarama.ErrNoError,
		Groups: map[string]string{"test": "consumer", "unread": "consumer", "ignore": "consumer"},
	})

	broker.Returns(&sarama.ConsumerMetadataResponse{
		Err:             sarama.ErrNoError,
		CoordinatorID:   broker.BrokerID(),
		CoordinatorHost: "127.0.0.1",
		CoordinatorPort: broker.Port(),
	})

	broker.Returns(&sarama.ConsumerMetadataResponse{
		Err:             sarama.ErrNoError,
		CoordinatorID:   broker.BrokerID(),
		CoordinatorHost: "127.0.0.1",
		CoordinatorPort: broker.Port(),
	})

	offset := new(sarama.OffsetFetchResponse)
	offset.AddBlock("test", 0, &sarama.OffsetFetchResponseBlock{
		Err:    sarama.ErrNoError,
		Offset: 123,
	})
	broker.Returns(offset)

	offsetUnread := new(sarama.OffsetFetchResponse)
	offsetUnread.AddBlock("unread", 0, &sarama.OffsetFetchResponseBlock{
		Err:    sarama.ErrNoError,
		Offset: -1,
	})
	broker.Returns(offsetUnread)

	conf := sarama.NewConfig()
	conf.Version = sarama.V0_10_1_0
	kafka, err := sarama.NewClient([]string{broker.Addr()}, conf)
	assert.NoError(t, err)

	c := &Monitor{
		client:  kafka,
		stateCh: make(chan interface{}, 100),
		log:     testutil.Logger,
		ignoreGroups: []string{"ignore"},
	}

	c.getConsumerOffsets()

	assert.Len(t, c.stateCh, 1)

	broker.Close()
}
