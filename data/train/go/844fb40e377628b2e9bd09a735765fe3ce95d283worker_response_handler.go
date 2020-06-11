package broker

import (
	"github.com/supersid/iris/message"
	"fmt"
)

const WORKER_RESPONSE_RELAY = "WORKER_RESPONSE_RELAY"

func (broker *Broker) WorkerResponseHandler(m message.Message){
	new_message := make([]string, 5)
	new_message[0] = m.Sender
	new_message[1] = ""
	new_message[2] = WORKER_RESPONSE_RELAY
	new_message[3] = m.Data
	new_message[4] = m.ResponseData

	fmt.Println("----------------------------------------------------------")
	fmt.Println("Worker response relayed to client.")
	fmt.Println("----------------------------------------------------------")
	broker.socket.SendMessage(new_message)
}