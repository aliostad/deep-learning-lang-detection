// Package netredialer provides a reconnecting net.Conn implementation.
package netredialer

import (
	"io"
	"net"

	"github.com/cenkalti/redialer"
)

type netDialer struct {
	Network string
	Address string
}

func (d netDialer) Dial() (conn io.Closer, err error) {
	return net.Dial(d.Network, d.Address)
}

func (d netDialer) Addr() string {
	return d.Network + "://" + d.Address
}

func (d netDialer) OnConnect(conn *redialer.Conn) error {
	return nil
}

type NetRedialer struct {
	redialer *redialer.Redialer
}

func New(network, address string) *NetRedialer {
	d := &netDialer{network, address}
	return &NetRedialer{redialer.New(d)}
}

func (r *NetRedialer) Run() {
	r.redialer.Run()
}

func (r *NetRedialer) Close() error {
	return r.redialer.Close()
}

func (r *NetRedialer) Conn() <-chan net.Conn {
	ch := make(chan net.Conn, 1)
	go r.notifyConn(ch)
	return ch
}

func (r *NetRedialer) notifyConn(ch chan<- net.Conn) {
	rconn, ok := <-r.redialer.Conn()
	if !ok {
		close(ch)
		return
	}
	nconn := rconn.Get().(net.Conn)
	ch <- &conn{nconn, rconn}
}

type conn struct {
	net.Conn
	rconn *redialer.Conn
}

func (c *conn) Close() error {
	err := c.Conn.Close()
	c.rconn.SetClosed()
	return err
}
