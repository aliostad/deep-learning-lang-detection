package broker

import (
	"time"
	"github.com/supersid/iris2/service"
	"fmt"
)

func (broker *Broker) PurgeWorkers(){
	for serviceID, _ := range broker.Services {
		service := broker.Services[serviceID]

		for workerID, _ := range service.Workers {
			serviceWorker := service.Workers[workerID]
			now := time.Now()

			if !serviceWorker.Expiry.After(now){
				service.DeleteWorker(serviceWorker)
				if service.HasNoWorkers(){
					service.ClearAll()
					broker.DeleteService(service)
				}
			}
		}
	}
}


func (broker *Broker) DeleteService(s *service.Service){
	delete(broker.Services, s.ServiceName)
	logger.Info(fmt.Sprintf("[purger.go] Broker does not offer %s service anymore", s.ServiceName))
}