package broker

import (
	"fmt"
	"github.com/supersid/iris2/request"
	"github.com/supersid/iris2/constants"
	"time"
)

func (broker *Broker) SendHeartBeat(){
	now := time.Now()
	if !(now.After(broker.NextWorkHeartBeat)) {
		return
	}

	broker.UpdateHeartBeat()
	for serviceName, service := range broker.Services {
		for identity, srvWorker := range service.Workers {
			logger.Info(srvWorker)
			logger.Info(identity)
			logger.Info(fmt.Sprintf("Sending heart beat to %s providing %s service", identity, serviceName))
			msg, err := request.CreateMessage("BROKER", constants.BROKER_HEARTBEAT, "", "", "", "")
			if err != nil {
				logger.Error(fmt.Sprintf("[heartbeat_sender.go] Could not create message: %s", err.Error()))
			}

			broker.Socket.SendMessage(srvWorker.Sender, msg)
		}
	}
}


func (broker *Broker) UpdateHeartBeat(){
	logger.Info("[heartbeat_sender.go] Updating time for next heartbeat")
	broker.NextWorkHeartBeat = broker.NextWorkHeartBeat.Add(HEARTBEAT_FREQUENCY)
}