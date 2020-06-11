package fakes

// FakeQueueDispatcher provides a string mapping so we can assert on which Messages
// have been dispatched by calling clients.
type FakeQueueDispatcher struct {
	Messages []interface{}
}

// NewFakeQueueDispatcher creates a fake dispatcher
func NewFakeQueueDispatcher() (dispatcher *FakeQueueDispatcher) {
	dispatcher = &FakeQueueDispatcher{}
	dispatcher.Messages = make([]interface{}, 0)
	return
}

// DispatchMessage implementation of dispatch message interface method
func (q *FakeQueueDispatcher) DispatchMessage(message interface{}) (err error) {
	q.Messages = append(q.Messages, message)
	return
}
