package main

import (
	"fmt"
	"sync"
)

type Pusher struct {

	// Registered clients
	clients struct {
		sync.RWMutex
		data map[PusherClientId]*PusherClient
	}

	// Registered topics
	msgChannels struct {
		sync.RWMutex
		data map[MessageTopicId]*MessageChannel
	}
}

const (
	CLIENT_QUEUE_SIZE uint32 = 1000
)

func NewPusher() *Pusher {
	broker := new(Pusher)
	broker.clients.data = make(map[PusherClientId]*PusherClient)
	broker.msgChannels.data = make(map[MessageTopicId]*MessageChannel)
	return broker
}

func (broker *Pusher) registerClient(id PusherClientId) (*PusherClient, error) {
	// Check if client already exists
	if _, found := broker.getClient(id); found {
		return nil, fmt.Errorf("Client '%v' already exists", id)
	}
	client := broker.createClient(id)
	broker.addClient(id, client)
	return client, nil
}

func (broker *Pusher) unregisterClient(id PusherClientId) error {
	// Check if client already exists
	client, found := broker.getClient(id)
	if !found {
		return fmt.Errorf("Client '%v' is not registered", id)
	}
	// Remove client's subscribtion for each topic
	for _, ch := range broker.getAllMsgChannels() {
		ch.removeSubscriber(id)
	}
	// Remove and shutdown client
	broker.removeClient(id)
	client.shutdown <- struct{}{}
	return nil
}

func (broker *Pusher) registerTopic(clientId PusherClientId, topicInfo MessageTopicInfo) error {
	// Check client and his permissions
	// Check if topic already exists
	if _, found := broker.getMsgChannel(topicInfo.Id); found {
		return fmt.Errorf("Topic '%v' is already registered", topicInfo.Id)
	}
	ch := NewMessageChannel(topicInfo)
	broker.addMsgChannel(ch)
	return nil
}

func (broker *Pusher) unregisterTopic(clientId PusherClientId, topicId MessageTopicId) error {
	// Check client and his permissions
	// Check if topic exists
	if _, found := broker.getMsgChannel(topicId); !found {
		return fmt.Errorf("Topic '%v' is not registered", topicId)
	}
	broker.removeMsgChannel(topicId)
	return nil
}

func (broker *Pusher) subscribe(clientId PusherClientId, topicId MessageTopicId) error {
	// Check client and his permissions
	// Check if client is subscribed
	// Check if topic exists
	ch, found := broker.getMsgChannel(topicId)
	if !found {
		return fmt.Errorf("Topic '%v' is not registered", topicId)
	}
	client, _ := broker.getClient(clientId)
	ch.addSubscriber(clientId, client)
	return nil
}

func (broker *Pusher) unsubscribe(clientId PusherClientId, topicId MessageTopicId) error {
	// Check client and his permissions
	// Check if client is subscribed
	// Check if topic exists
	ch, found := broker.getMsgChannel(topicId)
	if !found {
		return fmt.Errorf("Topic '%v' is not registered", topicId)
	}
	ch.removeSubscriber(clientId)
	return nil
}

func (broker *Pusher) publish(clientId PusherClientId, topicId MessageTopicId, msg interface{}) error {
	// Check client and his permissions
	// Check if topic exists
	ch, found := broker.getMsgChannel(topicId)
	if !found {
		return fmt.Errorf("Topic '%v' is not registered", topicId)
	}
	ch.Publish(msg)
	return nil
}

func (broker *Pusher) getAllTopics() []MessageTopicInfo {
	broker.msgChannels.RLock()
	defer broker.msgChannels.RUnlock()
	topics := make([]MessageTopicInfo, 0, len(broker.msgChannels.data))
	for _, ch := range broker.msgChannels.data {
		topics = append(topics, ch.getInfo())
	}
	return topics
}

func (broker *Pusher) getTopics(clientId PusherClientId) ([]MessageTopicInfo, bool) {
	// Check if client exist
	client, found := broker.getClient(clientId)
	if !found {
		return nil, false
	}
	// Get all topics, to which client is subscribed
	var topics []MessageTopicInfo
	for _, ch := range broker.getAllMsgChannels() {
		if ch.hasSubscriber(client.id) {
			topics = append(topics, ch.getInfo())
		}
	}
	return topics, true
}

func (broker *Pusher) getSubscribers(topicId MessageTopicId) ([]*PusherClient, bool) {
	ch, found := broker.getMsgChannel(topicId)
	if !found {
		return nil, false
	}
	return ch.getSubscribers(), true
}

func (broker *Pusher) createClient(id PusherClientId) *PusherClient {
	client := &PusherClient{
		pusher:        broker,
		id:            id,
		inbound:       make(chan interface{}, CLIENT_QUEUE_SIZE),
		shutdown:      make(chan struct{}),
		topicHandlers: make(map[MessageTopicId]TopicMessageHandler),
	}
	go client.pollInboundMessages()
	return client
}

func (broker *Pusher) getClient(clientId PusherClientId) (*PusherClient, bool) {
	broker.clients.RLock()
	defer broker.clients.RUnlock()
	client, found := broker.clients.data[clientId]
	return client, found
}

func (broker *Pusher) getAllClients() []*PusherClient {
	broker.clients.RLock()
	defer broker.clients.RUnlock()
	clients := make([]*PusherClient, 0, len(broker.clients.data))
	for _, c := range broker.clients.data {
		clients = append(clients, c)
	}
	return clients
}

func (broker *Pusher) addClient(clientId PusherClientId, client *PusherClient) {
	broker.clients.Lock()
	defer broker.clients.Unlock()
	broker.clients.data[clientId] = client
}

func (broker *Pusher) removeClient(clientId PusherClientId) {
	broker.clients.Lock()
	defer broker.clients.Unlock()
	delete(broker.clients.data, clientId)
}

func (broker *Pusher) getMsgChannel(topicId MessageTopicId) (*MessageChannel, bool) {
	broker.msgChannels.RLock()
	defer broker.msgChannels.RUnlock()
	topic, found := broker.msgChannels.data[topicId]
	return topic, found
}

func (broker *Pusher) getAllMsgChannels() []*MessageChannel {
	broker.msgChannels.RLock()
	defer broker.msgChannels.RUnlock()
	chs := make([]*MessageChannel, 0, len(broker.msgChannels.data))
	for _, ch := range broker.msgChannels.data {
		chs = append(chs, ch)
	}
	return chs
}

func (broker *Pusher) addMsgChannel(ch *MessageChannel) {
	broker.msgChannels.Lock()
	defer broker.msgChannels.Unlock()
	broker.msgChannels.data[ch.getInfo().Id] = ch
}

func (broker *Pusher) removeMsgChannel(topicId MessageTopicId) {
	broker.msgChannels.Lock()
	defer broker.msgChannels.Unlock()
	delete(broker.msgChannels.data, topicId)
}
