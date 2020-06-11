package udp_test

import (
	"context"
	"sync/atomic"
	"testing"
	"time"

	"v2ray.com/core/common/buf"
	"v2ray.com/core/common/net"
	"v2ray.com/core/testing/assert"
	. "v2ray.com/core/transport/internet/udp"
	"v2ray.com/core/transport/ray"
)

type TestDispatcher struct {
	OnDispatch func(ctx context.Context, dest net.Destination) (ray.InboundRay, error)
}

func (d *TestDispatcher) Dispatch(ctx context.Context, dest net.Destination) (ray.InboundRay, error) {
	return d.OnDispatch(ctx, dest)
}

func TestSameDestinationDispatching(t *testing.T) {
	assert := assert.On(t)

	ctx, cancel := context.WithCancel(context.Background())
	link := ray.NewRay(ctx)
	go func() {
		for {
			data, err := link.OutboundInput().Read()
			if err != nil {
				break
			}
			err = link.OutboundOutput().Write(data)
			assert.Error(err).IsNil()
		}
	}()

	var count uint32
	td := &TestDispatcher{
		OnDispatch: func(ctx context.Context, dest net.Destination) (ray.InboundRay, error) {
			atomic.AddUint32(&count, 1)
			return link, nil
		},
	}
	dest := net.UDPDestination(net.LocalHostIP, 53)

	b := buf.New()
	b.AppendBytes('a', 'b', 'c', 'd')
	dispatcher := NewDispatcher(td)
	var msgCount uint32
	dispatcher.Dispatch(ctx, dest, b, func(payload *buf.Buffer) {
		atomic.AddUint32(&msgCount, 1)
	})
	for i := 0; i < 5; i++ {
		dispatcher.Dispatch(ctx, dest, b, func(payload *buf.Buffer) {})
	}

	time.Sleep(time.Second)
	cancel()

	assert.Uint32(count).Equals(1)
	assert.Uint32(msgCount).Equals(6)
}
