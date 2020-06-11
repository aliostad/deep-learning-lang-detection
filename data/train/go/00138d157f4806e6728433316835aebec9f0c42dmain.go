package main

import (
	"fmt"
	"os"
	"sync/atomic"
	"time"

	"github.com/caelifer/gotests/signal/dispatch"
)

// Signal event counter - global shared value
var sigCounter int32 = 0

func main() {
	// Install dispatch's handler
	dispatch.HandleSignal(os.Interrupt, handleSIGINT_ONE)

	// Record start time
	t0 := time.Now()

	for range time.Tick(500 * time.Millisecond) {
		fmt.Print(".")
		// Give time to user to press CTRL-C
		if time.Since(t0) > 10*time.Second {
			// Stop handling INT signal
			dispatch.StopHandleSignal(os.Interrupt)
			// Exit
			return
		}
	}
}

// Generic signal handler
func handleSignal(signal os.Signal, sh dispatch.SignalHandler) {
	// Atomically adjust counter
	atomic.AddInt32(&sigCounter, 1)

	// Atomically compare
	if atomic.LoadInt32(&sigCounter) > 2 {
		os.Exit(1)
	}

	// Install different signal in mid-flight
	dispatch.HandleSignal(signal, sh)
}

// SIGINT custom handler one
func handleSIGINT_ONE(signal os.Signal) {
	fmt.Printf("\nHandler ONE: Got signal [%v]\n", signal)
	// Register handler #2
	handleSignal(signal, handleSIGINT_TWO)
}

// SIGINT custom handler two
func handleSIGINT_TWO(signal os.Signal) {
	fmt.Printf("\nHandler TWO: Got signal [%v]\n", signal)
	// Register handler #1
	handleSignal(signal, handleSIGINT_ONE)
}
