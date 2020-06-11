package handlers

import "github.com/smartystreets/messaging"

type DispatchHandler struct {
	input  <-chan EventMessage
	output chan<- RequestContext
	writer messaging.CommitWriter
	buffer []RequestContext
}

func NewDispatchHandler(input <-chan EventMessage, output chan<- RequestContext, writer messaging.CommitWriter) *DispatchHandler {
	return &DispatchHandler{
		input:  input,
		output: output,
		writer: writer,
	}
}

func (this *DispatchHandler) Listen() {
	for item := range this.input {
		this.process(item)
	}

	close(this.output)
}

func (this *DispatchHandler) process(item EventMessage) {
	if !this.write(item.Message) {
		this.output <- item.Context
	} else if item.EndOfBatch {
		this.tryCommit(item.Context)
	}
}

func (this *DispatchHandler) write(message interface{}) bool {
	if message == nil {
		return false
	}

	this.writer.Write(messaging.Dispatch{Message: message})
	return true
}

func (this *DispatchHandler) tryCommit(context RequestContext) {
	this.buffer = append(this.buffer, context)

	if len(this.input) == 0 {
		this.commit()
	}
}

func (this *DispatchHandler) commit() {
	if this.writer.Commit() != nil {
		return
	}

	for _, context := range this.buffer {
		this.output <- context
	}

	this.buffer = this.buffer[0:0]
}
