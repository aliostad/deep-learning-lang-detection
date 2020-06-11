package handlers

import (
	"github.com/stampzilla/gocast/api"
	"github.com/stampzilla/gocast/events"
	"github.com/stampzilla/gocast/responses"
)

type baseHandler struct {
	send     func(responses.Payload) error
	request  func(responses.Payload) (*api.CastMessage, error)
	dispatch func(events.Event)
}

func (r *baseHandler) RegisterDispatch(dispatch func(events.Event)) {
	r.dispatch = dispatch
}

func (r *baseHandler) Dispatch(e events.Event) {
	r.dispatch(e)
}

func (r *baseHandler) RegisterSend(send func(responses.Payload) error) {
	r.send = send
}
func (r *baseHandler) Send(p responses.Payload) error {
	return r.send(p)
}

func (r *baseHandler) RegisterRequest(send func(responses.Payload) (*api.CastMessage, error)) {
	r.request = send
}
func (r *baseHandler) Request(p responses.Payload) (*api.CastMessage, error) {
	return r.request(p)
}
