package main

import (
	"fmt"
	"sync"
	"time"
)

func main() {
	start := time.Now()
	broker := startNewHelloBroker()
	lotsOfHelloClients(broker)
	broker.Stop()
	elapsed := time.Since(start)
	fmt.Println("Elapsed:", elapsed)
}

type HelloProvider interface {
	RequestHello(name string) <-chan string
}

func lotsOfHelloClients(helloProvider HelloProvider) {
	var done sync.WaitGroup
	for i := 0; i < 10000; i++ {
		done.Add(1)
		go func(id int) {
			defer done.Done()
			helloClient(id, helloProvider)
		}(i)
	}
	done.Wait()
}

func helloClient(id int, helloProvider HelloProvider) {
	name := fmt.Sprint("Client-", id)
	fmt.Println(<-helloProvider.RequestHello(name))
}

type HelloBroker struct {
	requests chan helloRequest
}

type helloRequest struct {
	name     string
	response chan string
}

func startNewHelloBroker() *HelloBroker {
	broker := &HelloBroker{make(chan helloRequest)}
	go broker.start()
	return broker
}

func (broker *HelloBroker) start() {
	for i := 0; i < 1000; i++ {
		go helloWorker(broker.requests)
	}
}

func (broker *HelloBroker) Stop() {
	close(broker.requests)
}

func (broker *HelloBroker) RequestHello(name string) <-chan string {
	request := helloRequest{name, make(chan string)}
	broker.requests <- request
	return request.response
}

func helloWorker(requests <-chan helloRequest) {
	for request := range requests {
		request.response <- hello(request.name)
	}
}

func hello(name string) string {
	time.Sleep(50 * time.Millisecond)
	return fmt.Sprint("Hello ", name, " :)")
}
