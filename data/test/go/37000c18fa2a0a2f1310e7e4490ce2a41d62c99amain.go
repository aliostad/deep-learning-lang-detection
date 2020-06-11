package main

import (
	"fmt"
	"go/worker"
	"os"
	"os/signal"
	"syscall"
)

type EchoJob struct {
	id int
}

func (ej EchoJob) Run() {
	fmt.Printf("hello %d", ej.id)
}

func main() {
	jobQueue := make(chan worker.Job, 1024)
	dispatch := worker.NewDispatch(100, jobQueue)
	defer func() {
		dispatch.Stop()
	}()

	dispatch.Run()

	// Mechanical domain.
	errc := make(chan error)

	// Interrupt handler.
	go func() {
		c := make(chan os.Signal, 1)
		signal.Notify(c, syscall.SIGINT, syscall.SIGTERM)
		errc <- fmt.Errorf("%s", <-c)
	}()

	//生成任务
	go func() {
		for i := 0; i < 10000; i++ {
			jobQueue <- EchoJob{id: i}
		}
	}()

	fmt.Printf("exit: %v", <-errc)
}
