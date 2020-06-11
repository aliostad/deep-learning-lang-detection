package event

// import (
// 	"github.com/jmorgan1321/golang-games/core/utils"
// 	"github.com/jmorgan1321/golang-games/lib/gamecore/events"
// )

// type DelayedData interface {
// 	Data
// 	// TODO(jemorgan): use time.Duration or time.Time
// 	GetDelay() float32
// }

// type DelayedEvent struct {
// 	Event    string
// 	Msg      Data
// 	FireTime float32
// }
// type DelayDispatcher struct {
// 	*InstantDispatcher
// 	EventQueue []*DelayedEvent
// }

// func (d *DelayDispatcher) DispatchDelayed(fue *core_events.FrameUpdateEvent) {
// 	// copy current queue, so that any messages that cause a delayed message to
// 	// be fired don't mess us up.
// 	tmpQueue := d.EventQueue[:len(d.EventQueue)]
// 	d.EventQueue = nil
// 	for _, e := range tmpQueue {
// 		e.FireTime -= fue.Dt
// 		d.dispatchDelayed(e.Event, e.Msg, e.FireTime)
// 	}
// }

// func (d *DelayDispatcher) Init() {
// 	// // TODO: register with messaging system instead of with Owner.
// 	// d.Register("FrameUpdateEvent", d.Owner(), func(e Data) {
// 	// 	d.DispatchDelayed(e.(*core_events.FrameUpdateEvent))
// 	// })
// }

// func (d *DelayDispatcher) Dispatch(event string, data Data) {
// 	if de, ok := data.(DelayedData); !ok {
// 		d.InstantDispatcher.Dispatch(event, data)
// 	} else {
// 		d.dispatchDelayed(event, data, de.GetDelay())
// 	}
// }

// func (d *DelayDispatcher) dispatchDelayed(event string, data Data, delay float32) {
// 	if delay < utils.Epsilon {
// 		d.InstantDispatcher.Dispatch(event, data)
// 		return
// 	}

// 	delayedMsg := DelayedEvent{Event: event, Msg: data, FireTime: delay}
// 	d.EventQueue = append(d.EventQueue, &delayedMsg)
// }
