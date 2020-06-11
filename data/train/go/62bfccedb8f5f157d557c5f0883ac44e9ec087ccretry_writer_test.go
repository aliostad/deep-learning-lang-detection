package messaging

import (
	"errors"
	"testing"

	"github.com/smartystreets/assertions/should"
	"github.com/smartystreets/gunit"
)

func TestRetryWriterFixture(t *testing.T) {
	gunit.Run(new(RetryWriterFixture), t)
}

type RetryWriterFixture struct {
	*gunit.Fixture

	writer     *RetryWriter
	inner      *FakeRetryWriter
	sleeps     int
	sleepInput uint64
}

func (this *RetryWriterFixture) Setup() {
	this.inner = &FakeRetryWriter{errorUntil: 42}
	this.writer = NewRetryWriter(this.inner, 999, this.sleep)
}
func (this *RetryWriterFixture) sleep(value uint64) {
	this.sleeps++
	this.sleepInput = value
}

///////////////////////////////////////////////////////////////

func (this *RetryWriterFixture) TestDispatchWorksEventually() {
	dispatch := Dispatch{Destination: "destination"}

	this.writer.Write(dispatch)

	this.So(this.sleepInput, should.Equal, 41)
	this.So(this.sleeps, should.Equal, 42)
	this.So(this.inner.writes, should.Equal, 43)
	this.So(this.inner.written, should.Resemble, dispatch)
}

///////////////////////////////////////////////////////////////

func (this *RetryWriterFixture) TestClosedAbortsRetry() {
	dispatch := Dispatch{Destination: "destination"}

	this.writer.Close()
	err := this.writer.Write(dispatch)

	this.So(this.sleeps, should.Equal, 0)
	this.So(this.inner.writes, should.Equal, 1)
	this.So(this.inner.written, should.NotResemble, dispatch)
	this.So(this.inner.closed, should.Equal, 1)
	this.So(this.inner.closed, should.Equal, 1)
	this.So(err, should.Equal, WriterClosedError)
}

///////////////////////////////////////////////////////////////

type FakeRetryWriter struct {
	errorUntil int
	writes     int
	closed     int
	written    Dispatch
}

func (this *FakeRetryWriter) Write(message Dispatch) error {
	this.writes++

	if this.closed > 0 {
		return WriterClosedError
	}

	if this.errorUntil >= this.writes {
		return errors.New("can't write just yet")
	}

	this.written = message
	return nil
}
func (this *FakeRetryWriter) Close() {
	this.closed++
}
