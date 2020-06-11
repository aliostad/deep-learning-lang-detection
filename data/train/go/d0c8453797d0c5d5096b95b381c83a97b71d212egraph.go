package main

import (
	"github.com/trustmaster/goflow"
)

// A graph for our app
type App struct {
	flow.Graph
}

// A constructor that creates network structure
func NewApp() *App {
	// Create a new graph
	net := new(App)
	net.InitGraphState()
	// Add graph nodes
	net.Add(new(Router), "router")
	net.Add(new(Controller), "controller")
	net.Add(new(SendController), "sender")
	net.Add(NewStorage(), "storage")
	net.Add(new(Responder), "responder")
	// Connect the processes
	net.Connect("router", "Show", "controller", "In")
	net.Connect("router", "Send", "sender", "In")
	net.Connect("controller", "Out", "storage", "Get")
	net.Connect("sender", "Out", "storage", "Post")
	net.Connect("storage", "Out", "responder", "In")
	// Network ports
	net.MapInPort("In", "router", "In")
	return net
}
