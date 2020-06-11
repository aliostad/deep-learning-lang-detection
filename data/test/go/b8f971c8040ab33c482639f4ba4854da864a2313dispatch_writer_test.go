package messaging

import (
	"errors"
	"reflect"
	"testing"
	"time"

	"github.com/smartystreets/assertions/should"
	"github.com/smartystreets/gunit"
)

func TestDispatchWriterFixture(t *testing.T) {
	gunit.Run(new(DispatchWriterFixture), t)
}

type DispatchWriterFixture struct {
	*gunit.Fixture

	inner  *FakeDispatchWriter
	writer *DispatchWriter
}

func (this *DispatchWriterFixture) Setup() {
	this.inner = &FakeDispatchWriter{}
	this.writer = NewDispatchWriter(this.inner, NewReflectionDiscovery("prefix."))
}

///////////////////////////////////////////////////////////////////////////////

func (this *DispatchWriterFixture) TestCloseInvokesInnerWriterClose() {
	this.writer.Close()

	this.So(this.inner.closed, should.Equal, 1)
}

///////////////////////////////////////////////////////////////////////////////

func (this *DispatchWriterFixture) TestWriteUsingDefaults() {
	this.writer.Write(Dispatch{Message: "Hello, World!"})

	this.So(this.inner.written, should.Resemble, []Dispatch{{
		Destination: "prefix-string",
		MessageType: "prefix.string",
		Durable:     true,
		Message:     "Hello, World!",
	}})
}

///////////////////////////////////////////////////////////////////////////////

func (this *DispatchWriterFixture) TestWriteUsingCustomTemplate() {
	this.writer.RegisterTemplate(Dispatch{
		MessageID:       1,
		SourceID:        2,
		Destination:     "3",
		MessageType:     "4", // overwritten
		ContentType:     "5",
		ContentEncoding: "6",
		Durable:         true,
		Expiration:      time.Second * 7,
	})

	this.writer.Write(Dispatch{Message: "Hello, World!"})

	this.So(this.inner.written, should.Resemble, []Dispatch{{
		MessageID:       1,
		SourceID:        2,
		Destination:     "prefix-string",
		MessageType:     "prefix.string",
		ContentType:     "5",
		ContentEncoding: "6",
		Durable:         true,
		Expiration:      time.Second * 7,
		Message:         "Hello, World!",
	}})
	this.So(this.writer.template.Message, should.BeNil)
}

///////////////////////////////////////////////////////////////////////////////

func (this *DispatchWriterFixture) TestTypeDiscoverErrorsAreReturned() {
	err := this.writer.Write(Dispatch{Message: nil})
	this.So(err, should.Equal, MessageTypeDiscoveryError)
}

///////////////////////////////////////////////////////////////////////////////

func (this *DispatchWriterFixture) TestWriteReturnsInnerError() {
	this.inner.writeError = errors.New("returned to caller")

	err := this.writer.Write(Dispatch{Message: 0})

	this.So(err, should.Equal, this.inner.writeError)
}

///////////////////////////////////////////////////////////////////////////////

func (this *DispatchWriterFixture) TestWriteUsesOverrideTableWhenAvailable() {
	applicationMessage := "Hello, World!"

	this.writer.RegisterOverride(reflect.TypeOf(applicationMessage), Dispatch{
		MessageID:       1,
		SourceID:        2,
		Destination:     "3",
		MessageType:     "4",
		ContentType:     "5",
		ContentEncoding: "6",
		Durable:         true,
		Expiration:      time.Second * 7,
	})

	this.writer.Write(Dispatch{Message: applicationMessage})
	this.So(this.inner.written, should.Resemble, []Dispatch{{
		MessageID:       1,
		SourceID:        2,
		Destination:     "3",
		MessageType:     "4",
		ContentType:     "5",
		ContentEncoding: "6",
		Durable:         true,
		Expiration:      time.Second * 7,
		Message:         applicationMessage,
	}})
	this.So(this.writer.overrides[reflect.TypeOf(0)].Message, should.BeNil)
}

///////////////////////////////////////////////////////////////////////////////

func (this *DispatchWriterFixture) TestWriterWithoutCommitShouldReturnNoErrors() {
	this.writer = NewDispatchWriter(nil, nil)

	err := this.writer.Commit()

	this.So(err, should.BeNil)
}

///////////////////////////////////////////////////////////////////////////////

func (this *DispatchWriterFixture) TestCommitCallsInnerCommit() {
	this.inner.commitError = errors.New("returned to caller")

	err := this.writer.Commit()

	this.So(err, should.Equal, this.inner.commitError)
	this.So(this.inner.committed, should.Equal, 1)
}

///////////////////////////////////////////////////////////////////////////////

type FakeDispatchWriter struct {
	writeError  error
	commitError error

	written   []Dispatch
	committed int
	closed    int
}

func (this *FakeDispatchWriter) Write(dispatch Dispatch) error {
	this.written = append(this.written, dispatch)
	return this.writeError
}

func (this *FakeDispatchWriter) Commit() error {
	this.committed++
	return this.commitError
}

func (this *FakeDispatchWriter) Close() {
	this.closed++
}
