package main

import (
	log "github.com/Sirupsen/logrus"

	coprocess "github.com/TykTechnologies/tyk-protobuf/bindings/go"
	"golang.org/x/net/context"
)

// Dispatcher implementation
type Dispatcher struct{}

// Dispatch will be called on every request:
func (d *Dispatcher) Dispatch(ctx context.Context, object *coprocess.Object) (*coprocess.Object, error) {
	log.Println("Receiving object:", object)

	// We dispatch the object based on the hook name (as specified in the manifest file), these functions are in hooks.go:
	switch object.HookName {
	case "MyPostHook":
		log.Println("MyPostHook is called!")
		return MyPostHook(object)
	}

	log.Println("Unknown hook: ", object.HookName)

	return object, nil
}

// DispatchEvent will be called when a Tyk event is triggered:
func (d *Dispatcher) DispatchEvent(ctx context.Context, event *coprocess.Event) (*coprocess.EventReply, error) {
	return &coprocess.EventReply{}, nil
}
