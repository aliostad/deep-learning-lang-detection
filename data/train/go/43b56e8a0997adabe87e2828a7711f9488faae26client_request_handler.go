package broker

import (
	"github.com/supersid/iris/message"
	"github.com/supersid/iris/service"
)

const WORKER_REQUEST = "WORKER_REQUEST"

func(broker *Broker) ClientRequestHandler(msg message.Message){
	/*
	Find if a service exists
	1. Find or create service
	2. Add service to broker
	3. Assign requests to waiting requests queue
	4.
	*/
	newService, alreadyPresent := broker.FindOrCreateService(msg.ServiceName)

	if !alreadyPresent {
		broker.AddService(newService)
	}

	newService.AddRequest(msg)
	err, msg, serviceWorker := newService.ProcessRequests()

	if err != nil {
		return
	}

	broker.ProcessClientRequest(serviceWorker, msg)
}


func (broker *Broker) ProcessClientRequest(serviceWorker *service.ServiceWorker,
				           msg message.Message){
	clientSender := msg.Sender
	newMessage := make([]string, 5)
	newMessage[0] = serviceWorker.GetSender()
	newMessage[1] = clientSender
	newMessage[2] = WORKER_REQUEST
	newMessage[3] = msg.Data

	broker.socket.SendMessage(newMessage)
}

