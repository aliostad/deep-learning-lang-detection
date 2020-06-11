package chats

import (
	"fmt"
	"sync"
)

type Dispatch interface {
	Typing(id string)
}

type Subscriber interface {
	Id() string
	Dispatch
	SendMsg(id string, msg string)

	AddDispatcher(dispatch Dispatch)
	Merge(subscriber Subscriber)
}

type Chat struct {
	conversationId string
	subscribers    map[string]Subscriber
	m              sync.Mutex
}

func NewChat(conversationId string) *Chat {
	return &Chat{conversationId: conversationId, subscribers: make(map[string]Subscriber), m: sync.Mutex{}}
}

func (c *Chat) SendMsg(id string, msg string) error {
	c.m.Lock()
	defer c.m.Unlock()

	for _, s := range c.subscribers {
		if s.Id() == id {
			goto sendMessage
		}
	}

	return fmt.Errorf("no subscriber with id: %v", id)

sendMessage:

	for _, s := range c.subscribers {
		s.SendMsg(id, msg)
	}

	return nil
}

func (c *Chat) Typing(id string) {
	c.m.Lock()
	defer c.m.Unlock()

	for k, s := range c.subscribers {
		if k != id {
			s.Typing(id)
		}
	}
}

func (c *Chat) Subscribe(subscriber Subscriber) {
	c.m.Lock()
	defer c.m.Unlock()

	if s, ok := c.subscribers[subscriber.Id()]; ok {
		s.Merge(subscriber)
		return
	}

	subscriber.AddDispatcher(c)

	c.subscribers[subscriber.Id()] = subscriber
}
