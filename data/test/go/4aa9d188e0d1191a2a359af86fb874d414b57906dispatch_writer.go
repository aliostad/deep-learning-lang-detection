package messaging

import (
	"reflect"
	"strings"
)

type DispatchWriter struct {
	writer    Writer
	committer CommitWriter
	discovery TypeDiscovery
	overrides map[reflect.Type]Dispatch
	template  Dispatch
}

func NewDispatchWriter(writer Writer, discovery TypeDiscovery) *DispatchWriter {
	committer, _ := writer.(CommitWriter)

	return &DispatchWriter{
		writer:    writer,
		committer: committer,
		discovery: discovery,
		overrides: make(map[reflect.Type]Dispatch),
		template:  Dispatch{Durable: true},
	}
}

func (this *DispatchWriter) RegisterTemplate(template Dispatch) {
	this.template = template
}
func (this *DispatchWriter) RegisterOverride(instanceType reflect.Type, message Dispatch) {
	this.overrides[instanceType] = message
}

func (this *DispatchWriter) Write(item Dispatch) error {
	if target, found := this.overrides[reflect.TypeOf(item.Message)]; found {
		target.Message = item.Message
		return this.writer.Write(target)
	}

	return this.writeUsingTemplate(item.Message)
}
func (this *DispatchWriter) writeUsingTemplate(message interface{}) error {
	if discovered, err := this.discovery.Discover(message); err != nil {
		return err
	} else {
		return this.writeUsingMessageType(message, discovered)
	}
}
func (this *DispatchWriter) writeUsingMessageType(message interface{}, messageType string) error {
	target := this.template
	target.Message = message
	target.MessageType = messageType
	target.Destination = strings.Replace(target.MessageType, ".", "-", -1)
	return this.writer.Write(target)
}

func (this *DispatchWriter) Commit() error {
	if this.committer == nil {
		return nil
	}

	return this.committer.Commit()
}

func (this *DispatchWriter) Close() {
	this.writer.Close()
}
