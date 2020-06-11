package exts

import (
	"encoding/json"
)

type EventHandler func(MessagePipe, string, RawMessage)
type ActionHandler func(MessagePipe, string, RawMessage) (RawMessage, error)

type Dispatcher interface {
	On(event string, handler EventHandler) Dispatcher
	Do(action string, handler ActionHandler) Dispatcher
}

type DispatcherHandlers interface {
	Dispatcher
	EventHandlers(event string) []EventHandler
	ActionHandler(action string) ActionHandler
}

type dispatcherHandlers struct {
	eventHandlers  map[string][]EventHandler
	actionHandlers map[string]ActionHandler
}

func NewDispatcherHandlers() DispatcherHandlers {
	return &dispatcherHandlers{
		eventHandlers:  make(map[string][]EventHandler),
		actionHandlers: make(map[string]ActionHandler),
	}
}

func (d *dispatcherHandlers) On(event string, handler EventHandler) Dispatcher {
	handlers, exists := d.eventHandlers[event]
	if !exists {
		handlers = []EventHandler{handler}
	} else {
		handlers = append(handlers, handler)
	}
	d.eventHandlers[event] = handlers
	return d
}

func (d *dispatcherHandlers) Do(action string, handler ActionHandler) Dispatcher {
	d.actionHandlers[action] = handler
	return d
}

func (d *dispatcherHandlers) EventHandlers(event string) []EventHandler {
	if handlers, exists := d.eventHandlers[event]; exists {
		return handlers
	}
	return nil
}

func (d *dispatcherHandlers) ActionHandler(action string) ActionHandler {
	return d.actionHandlers[action]
}

type DispatchPipe struct {
	Pipe MessagePipe

	handlers DispatcherHandlers
}

func NewDispatchPipeWithHandlers(source MessagePipe, handlers DispatcherHandlers) *DispatchPipe {
	return &DispatchPipe{Pipe: source, handlers: handlers}
}

func NewDispatchPipe(source MessagePipe) *DispatchPipe {
	return NewDispatchPipeWithHandlers(source, NewDispatcherHandlers())
}

func (d *DispatchPipe) On(event string, handler EventHandler) Dispatcher {
	d.handlers.On(event, handler)
	return d
}

func (d *DispatchPipe) Do(action string, handler ActionHandler) Dispatcher {
	d.handlers.Do(action, handler)
	return d
}

func (d *DispatchPipe) Close() error {
	return d.Pipe.Close()
}

func (d *DispatchPipe) Recv() (*Message, error) {
	for {
		msg, err := d.Pipe.Recv()
		if err != nil || msg == nil {
			return msg, err
		}
		switch msg.Event {
		case MsgNotify:
			if handlers := d.handlers.EventHandlers(msg.Name); handlers != nil {
				for _, handler := range handlers {
					go func(handler EventHandler) {
						handler(d, msg.Name, RawMessage(msg.Data))
					}(handler)
				}
			} else {
				return msg, err
			}
		case MsgInvoke:
			reply := &Message{
				Event: MsgReply,
				Id:    msg.Id,
				Name:  msg.Name,
			}
			if handler := d.handlers.ActionHandler(msg.Name); handler != nil {
				go func() {
					result, err := handler(d, msg.Name, RawMessage(msg.Data))
					reply.Data = json.RawMessage(result)
					if err != nil {
						reply.Error = err.Error()
					}
					d.Send(reply)
					// TODO send failure
				}()
			} else {
				go func() {
					reply.Error = "Action " + msg.Name + " not defined"
					d.Send(reply)
					// TODO send failure
				}()
			}
		default:
			return msg, err
		}
	}
}

func (d *DispatchPipe) Send(msg *Message, options ...interface{}) error {
	return d.Pipe.Send(msg, options...)
}
