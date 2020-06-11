package server

import (
	"net/http"

	"golang.org/x/net/websocket"

	"github.com/davinche/godown/dispatch"
)

// Websocket struct tracks all
type Websocket struct {
	port       int
	dispatcher *dispatch.Dispatcher
}

// WebsocketRequest encapsulates the websocket client and it's corresponding
// resource it is trying to access
type WebsocketRequest struct {
	ID string
	WS *websocket.Conn
}

// NewWebsocket is the constructor fot a new websocket server
func NewWebsocket(d *dispatch.Dispatcher) *Websocket {
	return &Websocket{
		dispatcher: d,
	}
}

// Serve handles the incoming websocket connections
func (s *Websocket) Serve(prefix string, port int) {
	s.port = port
	http.HandleFunc(prefix, s.serve)
}

func (s *Websocket) serve(w http.ResponseWriter, r *http.Request) {
	id := r.FormValue("id")
	if id == "" {
		http.Error(w, "missing id in query string", http.StatusBadRequest)
		return
	}
	handleWS := func(ws *websocket.Conn) {
		request := &WebsocketRequest{
			ID: id,
			WS: ws,
		}
		s.dispatcher.Dispatch("ADD_WSCLIENT", request)
		for {
			var msg string
			err := websocket.Message.Receive(ws, &msg)
			if err != nil {
				s.dispatcher.Dispatch("DEL_WSCLIENT", request)
				return
			}
		}
	}
	websocket.Handler(handleWS).ServeHTTP(w, r)
}
