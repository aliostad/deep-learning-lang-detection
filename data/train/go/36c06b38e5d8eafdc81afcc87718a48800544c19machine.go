package machine

import (
	"github.com/zwopir/eventhandler/filter"
	"github.com/zwopir/eventhandler/model"
	"fmt"
	"github.com/nats-io/go-nats"
	"github.com/nats-io/go-nats/encoders/protobuf"
	"github.com/prometheus/common/log"
	"time"
)

// Coordinator dispatches messages read from nats to an actionFunc (func(interface{}) error)
type Coordinator struct {
	// the message channel
	envelopeCh chan model.Envelope
	// the encoded connection to nats (protobuf.PROTOBUF_ENCODER)
	encConn *nats.EncodedConn
	// channel to signalize a coordinator shutdown
	done chan struct{}
	// the time of the last successful message dispatch
	lastDispatched time.Time
	// after a successful message dispatch the coordinator enters a
	// blackout in which all messages are ignored
	blackout time.Duration
	// number of successful dispatches
	dispatches int64
	// the coordinator only dispatches a certain number of messages
	// If set to 0, the number of dispatches are unlimited
	maxDispatches int64
}

// NewCoordinator creates a new coordinator
func NewCoordinator(conn *nats.Conn, blackout string, maxDispatches int64) (Coordinator, error) {
	envelopeCh := make(chan model.Envelope)
	done := make(chan struct{})
	encConn, err := nats.NewEncodedConn(conn, protobuf.PROTOBUF_ENCODER)
	if err != nil {
		return Coordinator{}, err
	}
	bo, err := time.ParseDuration(blackout)
	if err != nil {
		return Coordinator{}, fmt.Errorf("failed to initialize coordinator: %s", err)
	}
	return Coordinator{
		envelopeCh:    envelopeCh,
		encConn:       encConn,
		done:          done,
		blackout:      bo,
		dispatches:    0,
		maxDispatches: maxDispatches,
	}, nil
}

// inBlackout indicates if the coordinator is in blackout
func (c Coordinator) inBlackout() bool {
	return c.lastDispatched.Add(c.blackout).After(time.Now())
}

// NatsListen connects the coordinator to the provided nats topic
func (c Coordinator) NatsListen(subject string) error {
	_, err := c.encConn.Subscribe(subject, func(m model.Envelope) {
		c.envelopeCh <- m
	})
	if err != nil {
		return err
	}
	return nil
}

// Dispatch dispatches the messages received from nats to the actionFunc.
// Messages are filtered and if the filter passes, the message is checked
// against the dispatch limit and the blackout
func (c Coordinator) Dispatch(filters filter.Filterer, actionFunc func(interface{}) error) {
	log.Infof("starting to dispatch with dispatch limit = %d and blackout = %s", c.maxDispatches, c.blackout)
	go func() {
		for message := range c.envelopeCh {
			dispatchMessage := true
			matched, err := filters.Match(message)
			if err != nil {
				log.Errorf("failed to apply matcher on %s: %s", message, err)
				continue
			}
			switch {
			case !matched:
				log.Infof("message %s doesn't match the provided filters, discarding it", message)
				dispatchMessage = false
				break
			case c.inBlackout():
				log.Info("discarding message because of blackout")
				dispatchMessage = false
				break
			case c.maxDispatches == 0:
				log.Debug("coordinator has no dispatch limit")
				dispatchMessage = dispatchMessage && true
				break
			case c.dispatches >= c.maxDispatches:
				log.Infof("dispatch limit exceeded (limit is %d)", c.maxDispatches)
				dispatchMessage = false
				break
			}

			if dispatchMessage {
				log.Debugf("dispatching message %s\n", message)
				err := actionFunc(message)
				if err != nil {
					log.Errorf("action func in dispatcher failed: %s", err)
				}
				c.lastDispatched = time.Now()
				c.dispatches += 1
			}
			select {
			case <-c.done:
				log.Info("shutting down dispatcher")
				return
			default:
			}
		}
	}()
}

// Shutdown stops the coordinator and closes all connections
func (c Coordinator) Shutdown() {
	defer close(c.done)
	defer close(c.envelopeCh)
	log.Info("shutting down coordinator...")
	c.encConn.Close()
}
