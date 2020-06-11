package majordomo

import (
    "time"
)

type Broker interface {
    Close() error
    Errors() chan error
    Run()
}

type Worker interface {
    Close() error
    Recv([][]byte) ([][]byte, error)
}

type Client interface {
    Close() error
    Send(string, [][]byte) ([][]byte, error)
}

func NewBroker(endpoint string, heartbeatIntv, workerExpiry time.Duration) (broker Broker, err error) {
    return newBroker(endpoint, heartbeatIntv, workerExpiry)
}


func NewWorker(broker, service string, heartbeatIntv, reconnectIntv time.Duration, retries int) (Worker, error) {
    return newWorker(broker, service, heartbeatIntv, reconnectIntv, retries)
}


func NewClient(broker string, retries int, timeout time.Duration) (Client, error) {
    return newClient(broker, retries, timeout)
}
