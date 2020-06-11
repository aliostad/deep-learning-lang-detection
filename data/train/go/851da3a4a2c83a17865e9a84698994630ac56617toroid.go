package main

import (
	"fmt"
	"github.com/mwhooker/toroid/queue"
	"time"
)

func dispatch(tasks queue.Queue, requests chan *queue.Task) {
	/* Consumes from our queue and populates a channel
	 */
	for {
		task := tasks.Get()
		if task == nil {
			time.Sleep(1)
			continue
		}

		requests <- task
	}

}

func main() {
	tasks := new(queue.Memory)
	tasks.Put("Item1")
	requests := make(chan *queue.Task)

	go dispatch(tasks, requests)

	var task *queue.Task
	for {
		select {
		case task = <-requests:
			fmt.Println("received ", task.Item, " from c1\n")
		}
	}

	select {} // block forever
}
