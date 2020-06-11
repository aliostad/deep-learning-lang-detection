package handlers

import (
	"sync"

	"github.com/smartystreets/messaging"
)

type DeliveryHandler struct {
	input       <-chan messaging.Delivery
	output      chan<- interface{}
	writer      messaging.CommitWriter
	application MessageHandler
	locker      sync.Locker
}

func NewDeliveryHandler(input <-chan messaging.Delivery,
	output chan<- interface{},
	writer messaging.CommitWriter,
	application MessageHandler,
	locker sync.Locker) *DeliveryHandler {

	if locker == nil {
		locker = NoopLocker{}
	} else {
		locker = NewIdempotentLocker(locker)
	}

	return &DeliveryHandler{
		input:       input,
		output:      output,
		writer:      writer,
		application: application,
		locker:      locker,
	}
}

func (this *DeliveryHandler) Listen() {
	for delivery := range this.input {
		this.locker.Lock()

		results := this.handle(delivery.Message)
		this.write(results)
		if this.tryCommit(delivery.Receipt) {
			this.locker.Unlock()
		}
	}

	close(this.output)
}

func (this *DeliveryHandler) handle(message interface{}) interface{} {
	if message == nil {
		return nil
	}

	return this.application.Handle(message)
}

func (this *DeliveryHandler) write(message interface{}) {
	if message == nil {
		return
	} else if multiple, ok := message.([]interface{}); ok {
		for _, item := range multiple {
			this.dispatch(item)
		}
	} else {
		this.dispatch(message)
	}
}
func (this *DeliveryHandler) dispatch(message interface{}) {
	dispatch := messaging.Dispatch{Message: message}
	this.writer.Write(dispatch)
}

func (this *DeliveryHandler) tryCommit(receipt interface{}) bool {
	if len(this.input) > 0 {
		return false
	}

	if this.writer != nil {
		this.writer.Commit()
	}

	this.output <- receipt
	return true
}
