package main

import (
	"log"
	"net/http"

	"github.com/gavinwade12/monkey/server"
)

type chatHandler struct{}

func (c *chatHandler) ClientRemoved(id string) {}

func (c *chatHandler) Err(err error) { log.Print(err) }

func (c *chatHandler) MessageDispatch(msg []byte, senderID string) ([]string, []byte) {
	return nil, msg
}

func (c *chatHandler) NewClient(id string, r *http.Request) bool { return true }

func main() {
	h := &chatHandler{}
	ocr := server.OnClientRemoved(h.ClientRemoved)
	od := server.OnDispatch(h.MessageDispatch)
	oe := server.OnErr(h.Err)
	onc := server.OnNewClient(h.NewClient)

	s := server.New(ocr, od, oe, onc)
	s.Start("/chat")
	log.Fatal(http.ListenAndServe(":8080", nil))
}
