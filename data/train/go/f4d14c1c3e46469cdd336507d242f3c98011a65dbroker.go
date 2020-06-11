package broker

import (
	proto "github.com/ironzhang/gomqtt/pkg/proto/private"
)

type Transport interface {
	Transport(p *proto.Transport) error
}

type Kickouter interface {
	Kickout(clientIdentifier string) error
}

type Broker struct {
	tr Transport
	kr Kickouter
}

func New(tr Transport, kr Kickouter) *Broker {
	return &Broker{tr: tr, kr: kr}
}

func (s *Broker) Transport(req *proto.Transport, res *int) error {
	return s.tr.Transport(req)
}

func (s *Broker) Kickout(clientIdentifier string, res *int) error {
	return s.kr.Kickout(clientIdentifier)
}
