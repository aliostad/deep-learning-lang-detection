package handlers

import (
	"errors"
	"testing"

	"github.com/smartystreets/assertions/should"
	"github.com/smartystreets/gunit"
	"github.com/smartystreets/messaging"
)

func TestDispatchHandlerFixture(t *testing.T) {
	gunit.Run(new(DispatchHandlerFixture), t)
}

type DispatchHandlerFixture struct {
	*gunit.Fixture

	input   chan EventMessage
	output  chan RequestContext
	writer  *FakeWriter
	handler *DispatchHandler
}

func (this *DispatchHandlerFixture) Setup() {
	this.input = make(chan EventMessage, 24)
	this.output = make(chan RequestContext, 24)
	this.writer = &FakeWriter{}
	this.handler = NewDispatchHandler(this.input, this.output, this.writer)
}

/////////////////////////////////////////////////////////////////////////

func (this *DispatchHandlerFixture) TestOutputIsClosed() {
	this.listen()
	this.So(<-this.output, should.Equal, nil)
}

/////////////////////////////////////////////////////////////////////////

func (this *DispatchHandlerFixture) TestMessagesAreWritten() {
	this.input <- EventMessage{Message: 1}
	this.input <- EventMessage{Message: 2}
	this.input <- EventMessage{Message: 3, EndOfBatch: true}

	this.listen()

	this.So(this.writer.commits, should.Equal, 1)
	this.So(this.writer.messages, should.Resemble, []messaging.Dispatch{
		messaging.Dispatch{Message: 1},
		messaging.Dispatch{Message: 2},
		messaging.Dispatch{Message: 3},
	})
}

/////////////////////////////////////////////////////////////////////////

func (this *DispatchHandlerFixture) TestCommitOnlyWhenLastMessageIsTheEndOfABatch() {
	this.input <- EventMessage{Message: 1, EndOfBatch: true}
	this.input <- EventMessage{Message: 2, EndOfBatch: false}

	this.listen()

	this.So(this.writer.commits, should.Equal, 0)
	this.So(this.writer.messages, should.Resemble, []messaging.Dispatch{
		messaging.Dispatch{Message: 1},
		messaging.Dispatch{Message: 2},
	})
}

/////////////////////////////////////////////////////////////////////////

func (this *DispatchHandlerFixture) TestEndOfBatchRequestContextsAreSendToNextPhaseAfterCommit() {
	context1 := &FakeRequestContext{}
	context2 := &FakeRequestContext{}
	this.input <- EventMessage{Message: 1, Context: context1}
	this.input <- EventMessage{Message: 2, Context: context1}
	this.input <- EventMessage{Message: 3, Context: context1, EndOfBatch: true}
	this.input <- EventMessage{Message: 4, Context: context2}
	this.input <- EventMessage{Message: 5, Context: context2}
	this.input <- EventMessage{Message: 6, Context: context2, EndOfBatch: true}

	this.listen()

	this.So(len(this.output), should.Equal, 2)
	this.So(<-this.output, should.Equal, context1)
	this.So(<-this.output, should.Equal, context2)
	this.So(this.handler.buffer, should.BeEmpty)
}

/////////////////////////////////////////////////////////////////////////

func (this *DispatchHandlerFixture) TestNilMessageSendsContextDirectlyToOutput() {
	context1 := &FakeRequestContext{}
	this.input <- EventMessage{Message: nil, Context: context1}

	this.listen()

	this.So(this.writer.messages, should.BeEmpty)
	this.So(this.writer.commits, should.Equal, 0)
	this.So(len(this.output), should.Equal, 1)
	this.So(<-this.output, should.Equal, context1)
}

/////////////////////////////////////////////////////////////////////////

func (this *DispatchHandlerFixture) TestFailedCommitDoesNotSendToNextPhase() {
	this.writer.err = errors.New("Do not continue dispatching...")
	this.input <- EventMessage{Message: 1, Context: &FakeRequestContext{}, EndOfBatch: true}

	this.listen()

	this.So(len(this.output), should.Equal, 0)
	this.So(this.handler.buffer, should.NotBeEmpty)
}

/////////////////////////////////////////////////////////////////////////

func (this *DispatchHandlerFixture) listen() {
	close(this.input)
	this.handler.Listen()
}

/////////////////////////////////////////////////////////////////////////

type FakeWriter struct {
	messages []messaging.Dispatch
	commits  int
	err      error
}

func (this *FakeWriter) Write(dispatch messaging.Dispatch) error {
	this.messages = append(this.messages, dispatch)
	return nil
}

func (this *FakeWriter) Commit() error {
	this.commits++
	return this.err
}

func (this *FakeWriter) Close() {}

/////////////////////////////////////////////////////////////////////////
