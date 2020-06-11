package client

import (
	"context"
	"encoding/json"

	"github.com/gorilla/websocket"
	"github.com/komkom/chat/chats"
)

type Msg struct {
	Type string `json:"type"`
	Id   string `json:"id"`
	Msg  string `json:"msg"`
}

type Typing struct {
	Type string `json:"msg"`
	Id   string `json:"id"`
}

type Error struct {
	Error string `json:"error"`
}

func serialize(remoteObj interface{}) (s []byte) {
	s, err := json.Marshal(remoteObj)
	if err != nil {
		panic(err)
	}
	return
}

type Subscriber struct {
	clients  []Client
	id       string
	dispatch chats.Dispatch
}

func (s *Subscriber) Id() string {
	return s.id
}

func (s *Subscriber) Merge(other chats.Subscriber) {
	o := other.(*Subscriber)
	s.clients = append(s.clients, o.clients...)
}

func (s *Subscriber) SendMsg(id string, msg string) {
	b := serialize(Msg{Type: `Message`, Id: id, Msg: msg})
	s.sendRawMsg(b)
}

func (s *Subscriber) Typing(id string) {
	b := serialize(Msg{Type: `Typing`, Id: id})
	s.sendRawMsg(b)
}

func (s *Subscriber) AddDispatcher(dispatch chats.Dispatch) {
	s.dispatch = dispatch
}

func (s *Subscriber) sendRawMsg(b []byte) {
	for _, c := range s.clients {
		c.send <- b
	}
}

func AddSubcriber(id string, ctx context.Context, conn *websocket.Conn, chat *chats.Chat) {

	// fix initial load

	sub := &Subscriber{id: id}
	sub.AddDispatcher(chat)

	client := MakeClient(ctx, conn)

	go func() {

		for {
			select {
			case <-client.receive:
				sub.dispatch.Typing(id)

			case <-client.ctx.Done():
				break
			}
		}
	}()

	sub.clients = []Client{client}

	chat.Subscribe(sub)
}
