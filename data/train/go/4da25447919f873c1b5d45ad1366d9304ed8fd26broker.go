package broker

import (
	simplLogger "github.com/supersid/iris2/logger"
	"github.com/supersid/iris2/service"
	"github.com/Sirupsen/logrus"
	zmq "github.com/pebbe/zmq4"
	"runtime"
	"time"
	"fmt"
	"os"
	"github.com/supersid/iris2/request"
)

const (
	DEVELOPMENT_ENV = "DEVELOPMENT_ENV"
	POLL_FREQUENCY  = 30 * time.Millisecond
	HEARTBEAT_FREQUENCY = 2500 * time.Millisecond
)

var logger *logrus.Logger

type Broker struct{
	brokerUrl   		string
	Socket 		     	*zmq.Socket
	Services    		map[string]*service.Service
	Clients     		map[string]string
	DebugMode   		bool
	NextWorkHeartBeat	time.Time
}

func NewBroker(brokerUrl string, env string) (*Broker, error){
	broker := &Broker{
		brokerUrl: 		brokerUrl,
		Services: 		make(map[string]*service.Service),
		Clients:  		make(map[string]string),
		NextWorkHeartBeat: 	time.Now().Add(HEARTBEAT_FREQUENCY),
		DebugMode: 		false,
	}

	socket, err := zmq.NewSocket(zmq.ROUTER)

	if err != nil {
		logger.Error(err.Error())
		return nil, err
	}

	broker.Socket = socket

	if env == DEVELOPMENT_ENV {
		broker.DebugMode = true
	}

	return broker, nil
}

func (broker *Broker) Process(){
	poller := zmq.NewPoller()
	poller.Add(broker.Socket, zmq.POLLIN)


	for {
		incomingSocket, err := poller.Poll(POLL_FREQUENCY)
		if err != nil{
			logger.Error(err.Error())
		}


		if len(incomingSocket) > 0 {
			msg, err := broker.Socket.RecvMessage(0)

			if err != nil {
				logger.Error(fmt.Sprintf("While Receving message on the broker: %s", err.Error()))
				continue
			}

			req, err := request.UnWrapMessage(msg)

			if err != nil {
				logger.Error("Error unwrapping message: %s", err.Error())
				continue
			}

			logger.Info(fmt.Sprintf("No. of clients connected %d", len(broker.Clients)))
			broker.ProcessMessage(req)
		}else{
			broker.PurgeWorkers()
			broker.SendHeartBeat()
		}
	}
}

func (broker *Broker) Close() {
	broker.Socket.Close()
}

func Start(brokerUrl string){
	runtime.GOMAXPROCS(runtime.NumCPU())
	env := os.Getenv("IRIS_ENV")

	if env == "" {
		env = DEVELOPMENT_ENV
	}

	logger = simplLogger.Init(env, "")
	broker, err := NewBroker(brokerUrl, env)

	if err != nil {
		logger.Error("Broker creation error:  %s", err.Error())
		panic(err)
	}

	err = broker.Socket.Bind(brokerUrl)

	if err != nil{
		logger.Error("Broker bind error: %s", err.Error())
		panic(err)
	}


	defer broker.Close()

	if err != nil {
		logger.Error("Broker creation failed.")
		panic(err)
	}

	logger.Info(fmt.Sprintf("Launching Broker on %s", brokerUrl))
	broker.Process()
}