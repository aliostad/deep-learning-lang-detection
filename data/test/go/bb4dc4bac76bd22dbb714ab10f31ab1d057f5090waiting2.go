package main

import (
	"fmt"
	"time"
)

func goroutine(done chan<- int) {
	fmt.Println("\t\tgorountine start")
	time.Sleep(1 * time.Second)
	fmt.Println("\t\tgorountine sending")
	done <- 1
	fmt.Println("\t\tgorountine end")
}

func dispatch(done chan<- int) {
	_, _, s := time.Now().Clock()
	fmt.Println("\tdispatch start; seconds = ", s)
	if s%2 == 0 {
		fmt.Println("\tdispatch goroutine")
		go goroutine(done)
	} else {
		fmt.Println("\tdispatch anon")
		go func() { done <- 1 }()
	}

}

func main() {
	fmt.Println("main start")
	done := make(chan int)
	dispatch(done)
	fmt.Println("main after `dispatch`")
	//time.Sleep(2 * time.Second)
	<-done // blocks until `done` is written to
	fmt.Println("main received")
	//time.Sleep(2 * time.Second)
	fmt.Println("main end")
}
