package process_state

import (
	"github.com/gorilla/websocket"
	"github.com/tuomasvapaavuori/site_installer/app/models/web"
	"testing"
)

func (p *ProcessState) TestProcessStartsAndEnds(t *testing.T) {
	msgChan := make(chan *web_models.ConnStatusMessage)
	conn := websocket.Conn{}

	process := web_models.NewWebProcess("Test Process", msgChan, &conn)

	go func() {
		finished := p.ListenOutChannel(msgChan, t)
		if !finished {
			t.Error("Error finishing process.")
		}
	}()

	process.Start()
	process.Finish()
}

func (p *ProcessState) ListenOutChannel(channel chan *web_models.ConnStatusMessage, t *testing.T) bool {
	for {
		msg := <-channel
		switch msg.Message {
		case "Process: Test Process started.":
			t.Log(msg)
			break
		case "Process: Test Process aborted.":
			t.Log(msg)
			break
		case "Process: Test Process finished.":
			t.Log(msg)
			return true
		}
	}
}
