package http

import (
	"errors"
	"github.com/oxtoacart/bpool"
	"github.com/plimble/kuja/broker"
	"net"
	"net/http"
	"testing"
)

type httpBroker struct {
	addr     string
	listen   net.Listener
	pool     *bpool.BufferPool
	handlers map[string]map[string]broker.Handler
}

type TestFunc func(t *testing.T)

func NewBroker(addr string, bufsize int) *httpBroker {
	return &httpBroker{
		addr:     addr,
		pool:     bpool.NewBufferPool(bufsize),
		handlers: make(map[string]map[string]broker.Handler),
	}
}

func NewLocal() *httpBroker {
	return &httpBroker{
		addr:     "127.0.0.1:9999",
		pool:     bpool.NewBufferPool(50),
		handlers: make(map[string]map[string]broker.Handler),
	}
}

func (h *httpBroker) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	var err error
	topic := r.URL.Path[1:]
	if _, ok := h.handlers[topic]; !ok {
		w.WriteHeader(404)
		w.Write(nil)
		return
	}

	buf := h.pool.Get()
	buf.ReadFrom(r.Body)
	defer func() {
		r.Body.Close()
		h.pool.Put(buf)
	}()

	brokerMsg := &broker.Message{}
	brokerMsg.Unmarshal(buf.Bytes())

	for _, handler := range h.handlers[topic] {
		_, err = handler(topic, brokerMsg)
		if err != nil {
			w.WriteHeader(500)
			w.Write([]byte(err.Error()))
			return
		}
	}

	w.WriteHeader(200)
	w.Write(nil)
}

func (n *httpBroker) Connect() error {
	if n.listen != nil {
		return nil
	}

	var err error
	n.listen, err = net.Listen("tcp", n.addr)
	if err != nil {
		return err
	}

	go http.Serve(n.listen, n)

	return nil
}

func (n *httpBroker) Close() {
	n.listen.Close()
}

func (n *httpBroker) Publish(topic string, msg *broker.Message) error {
	data, err := msg.Marshal()
	if err != nil {
		return err
	}

	buf := n.pool.Get()
	buf.Write(data)
	req, _ := http.NewRequest("POST", "http://"+n.addr+"/"+topic, buf)
	resp, err := http.DefaultClient.Do(req)
	n.pool.Put(buf)
	if err != nil {
		return err
	}

	buf = n.pool.Get()
	buf.ReadFrom(resp.Body)
	defer resp.Body.Close()
	defer n.pool.Put(buf)

	switch resp.StatusCode {
	case 200:
		return nil
	case 404:
		return errors.New("topic not found")
	case 500:
		return errors.New(buf.String())
	}

	return nil
}

func (n *httpBroker) Subscribe(topic, queue, appId string, size int, h broker.Handler) {
	if _, ok := n.handlers[topic]; !ok {
		n.handlers[topic] = make(map[string]broker.Handler)
	}

	n.handlers[topic][queue] = h
}
