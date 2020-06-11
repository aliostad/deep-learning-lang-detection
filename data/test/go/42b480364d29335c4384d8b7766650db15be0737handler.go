package service

import (
	"log"
)

type Handler func(req *Request) *Response

func RunService(input chan ChanReq, h map[string]Handler) {
	log.Println("Service is running.")
	for {
		req := <-input
		log.Printf("Got a request: %s", req.Req)
		req.Res <- dispatch(req.Req, h)
	}
}

func dispatch(req *Request, h map[string]Handler) (rv *Response) {
	log.Printf("dispatch %s", req.Opcode)
	if h, ok := h[string(req.Opcode)]; ok {
		rv = h(req)
	} else {
		return notFound(req)
	}
	return
}

func notFound(req *Request) *Response {
	var response Response
	copy(response.Data[:], "not found")
	return &response
}
