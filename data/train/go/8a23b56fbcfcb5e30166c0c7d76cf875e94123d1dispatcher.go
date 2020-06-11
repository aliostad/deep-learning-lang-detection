package mongoproxy

import (
	"errors"
	"math"
	"net"
	"time"

	"github.com/golang/glog"
)

const headerLen = 16

// dispatchMessage wrapper of incomming conn and size
type dispatchMessage struct {
	conn           *MongoConn
	header         *MsgHeader
	dispatchStatus chan error
}

// Wait till the message is fully proxied and return true if it was succesfull
// will return false if it takes more than t
func (d *dispatchMessage) Wait(t time.Duration) error {
	select {
	case r := <-d.dispatchStatus:
		return r
	case <-time.After(t):
		return errors.New("timeout waiting for db response")
	}
}

// MarkSuccess marks this message to successfully proxied
func (d *dispatchMessage) MarkSuccess(t time.Duration) {
	// TODO don't use timeout.
	block := func() (interface{}, error) {
		d.dispatchStatus <- nil
		return nil, nil
	}
	TimeoutIn(block, t)
}

// MarkFailure marks a message as failed.
func (d *dispatchMessage) MarkFailure(t time.Duration, e error) {
	// TODO don't use timeout
	block := func() (interface{}, error) {
		d.dispatchStatus <- e
		return nil, nil
	}
	TimeoutIn(block, t)
}

// NewDispatchMessage creates a dispatch message
func newDispatchMessage(m *MongoConn, h *MsgHeader) *dispatchMessage {
	return &dispatchMessage{
		conn:           m,
		header:         h,
		dispatchStatus: make(chan error),
	}
}

// Dispatcher dispathces requests to mongos
type Dispatcher struct {
	// ChannelLen is the length of the queue b/w incoming and outgoing requests
	// Once this queue is full, the incoming requests start blocking
	ChannelLen uint

	// NumRoutines to run for dispatching
	// increasing this will increase the throughput for the proxy at the
	// cost of increased connection to mongo.
	NumRoutines uint

	channel chan *dispatchMessage

	Timeout time.Duration
	// TargetAddr is the mongo we talk to.
	TargetAddr string
	metrics    *dispatchMetrics
}

func (d *Dispatcher) dispatchAction() {

	outMongoConn, err := d.refreshConn(nil)
	if err != nil {
		// this should not ever happen. The refresh should retry infinitely
		panic(err)
	}

	for msg := range d.channel {

		if err := outMongoConn.WriteHeader(msg.header); err != nil {
			msg.MarkFailure(d.Timeout, err)
			d.metrics.failure.Mark(1)
			outMongoConn, err = d.refreshConn(outMongoConn)
			if err != nil {
				glog.Error("out going go routine dead due to mongo-conn failure", err)
			}
			return
		}
		if err := outMongoConn.CopyN(msg.conn, int64(msg.header.MessageLength)-headerLen); err != nil {
			msg.MarkFailure(d.Timeout, err)
			outMongoConn, err = d.refreshConn(outMongoConn)
			if err != nil {
				glog.Error("out going go routine dead due to mongo-conn failure", err)
				return
			}
			d.metrics.failure.Mark(1)
			continue
		}
		if !msg.header.WaitForResponse() {
			if err := msg.conn.CopyResponse(outMongoConn); err != nil {
				msg.MarkFailure(d.Timeout, err)
				d.metrics.failure.Mark(1)
			}
		}
		msg.MarkSuccess(d.Timeout)
		d.metrics.success.Mark(1)
	}
	outMongoConn.Close()
}

var errRefresh = errors.New("failed refreshing conn")

func (d *Dispatcher) refreshConn(m *MongoConn) (*MongoConn, error) {
	if m != nil {
		if err := m.Close(); err != nil {
			glog.Error("error closing connection", err)
		}
	}
	var err error
	backoff := NewExpBackoffPolicy(math.MaxInt32, 50*time.Millisecond)
	c, err := net.Dial("tcp", d.TargetAddr)
	if err == nil {
		return NewMongoConn(c), nil
	}
	for err != nil {
		t, ok := backoff.Next()
		if !ok {
			return nil, errRefresh
		}
		time.Sleep(t)
		c, err := net.Dial("tcp", d.TargetAddr)
		if err == nil {
			return NewMongoConn(c), nil
		}
	}
	return nil, errRefresh
}

// Start the dispatcher
func (d *Dispatcher) Start() {
	if d.NumRoutines == 0 {
		d.NumRoutines = 1000
	}
	if d.ChannelLen == 0 {
		d.ChannelLen = 10000
	}
	d.channel = make(chan *dispatchMessage, d.ChannelLen)
	for i := uint(0); i < d.NumRoutines; i++ {
		go d.dispatchAction()
	}
}

// Dispatch queues a request to the dispatcher
func (d *Dispatcher) Dispatch(msg *dispatchMessage, timeout time.Duration) error {
	select {
	case d.channel <- msg:
		return nil
	case <-time.After(timeout):
		glog.Error("dispatch buffer full timing out")
		return errors.New("proxy buffer full")
	}
}
