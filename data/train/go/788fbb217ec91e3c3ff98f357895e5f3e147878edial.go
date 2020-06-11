package net

import "net"
import "golang.org/x/net/context"

// Dial with deadline awareness.
type Dialer interface {
	Dial(net, addr string, ctx context.Context) (net.Conn, error)
}

// Dialer function adapter.
type DialerFunc func(net, addr string, ctx context.Context) (net.Conn, error)

func (df DialerFunc) Dial(net, addr string, ctx context.Context) (net.Conn, error) {
	return df(net, addr, ctx)
}

// netDialer
type netDialer struct{}

func (netDialer) Dial(n, addr string, ctx context.Context) (net.Conn, error) {
	deadline, _ := ctx.Deadline()

	d := net.Dialer{
		Deadline: deadline,
	}
	return d.Dial(n, addr)
}

// Standard package net dialer.
var NetDialer netDialer

// Default dialer. May be changed.
var DefaultDialer = NetDialer
