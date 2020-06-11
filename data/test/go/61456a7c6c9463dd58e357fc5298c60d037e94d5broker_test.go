package rabbit

import (
	"errors"
	"net/url"
	"reflect"
	"testing"
	"time"

	"github.com/smartystreets/assertions/should"
	"github.com/smartystreets/gunit"
	"github.com/smartystreets/messaging"
	"github.com/streadway/amqp"
)

func TestBrokerFixture(t *testing.T) {
	gunit.Run(new(BrokerFixture), t)
}

type BrokerFixture struct {
	*gunit.Fixture

	target    url.URL
	connector *FakeConnector
	broker    *Broker
	naps      []time.Duration
}

func (this *BrokerFixture) Setup() {
	target, _ := url.Parse("amqps://username:password@localhost:5671/")
	this.target = *target
	this.connector = NewFakeConnector(0, 0)
	this.createBroker()
}

func (this *BrokerFixture) createBroker() {
	this.broker = NewBroker(this.target, this.connector)
	this.broker.sleep = func(duration time.Duration) { this.naps = append(this.naps, duration) }
}

////////////////////////////////////////////////////////

func (this *BrokerFixture) TestConnect() {
	this.assertConnectResult(messaging.Disconnected, messaging.Connecting, false)
	this.assertConnectResult(messaging.Connecting, messaging.Connecting, false)
	this.assertConnectResult(messaging.Connected, messaging.Connected, false)
	this.assertConnectResult(messaging.Disconnecting, messaging.Disconnecting, true)
}
func (this *BrokerFixture) assertConnectResult(initial, updated uint64, hasError bool) {
	this.broker.state = initial

	err := this.broker.Connect()
	if hasError {
		this.So(err, should.Equal, messaging.BrokerShuttingDownError)
	} else {
		this.So(err, should.BeNil)
	}

	this.So(this.broker.State(), should.Equal, updated)
}

////////////////////////////////////////////////////////

func (this *BrokerFixture) TestDisconnectWithoutChildren() {
	this.assertDisconnectResult(messaging.Disconnected, messaging.Disconnected)
	this.assertDisconnectResult(messaging.Disconnecting, messaging.Disconnecting) // don't interupt
	this.assertDisconnectResult(messaging.Connected, messaging.Disconnected)
	this.assertDisconnectResult(messaging.Connecting, messaging.Disconnected)
}
func (this *BrokerFixture) assertDisconnectResult(initial, updated uint64) {
	this.broker.state = initial
	this.broker.Disconnect()
	this.So(this.broker.State(), should.Equal, updated)
}

////////////////////////////////////////////////////////

func (this *BrokerFixture) TestDisconnectWithOnlyWriters() {
	this.broker.state = messaging.Connected

	writers := []*FakeWriter{&FakeWriter{}, &FakeWriter{}}
	for _, writer := range writers {
		this.broker.writers = append(this.broker.writers, writer)
	}

	this.broker.Disconnect()
	this.broker.Disconnect() // only tries to shut down once

	this.So(writers[0].closed, should.Equal, 1)
	this.So(writers[1].closed, should.Equal, 1)
	this.So(this.broker.State(), should.Equal, messaging.Disconnected)
	this.So(this.broker.writers, should.BeEmpty)
}

////////////////////////////////////////////////////////

func (this *BrokerFixture) TestDisconnectWithOnlyReaders() {
	this.broker.state = messaging.Connected

	readers := []*FakeReader{&FakeReader{}, &FakeReader{}}
	for _, reader := range readers {
		this.broker.readers = append(this.broker.readers, reader)
	}

	this.broker.Disconnect()
	this.broker.Disconnect() // only tries to shut down once

	this.So(readers[0].closed, should.Equal, 1)
	this.So(readers[1].closed, should.Equal, 1)
	this.So(this.broker.State(), should.Equal, messaging.Disconnecting)
	this.So(len(this.broker.readers), should.Equal, len(readers))
}

////////////////////////////////////////////////////////

func (this *BrokerFixture) TestLastReaderShutdownComplete() {
	this.broker.state = messaging.Disconnecting
	connection := &FakeConnection{}
	this.broker.connection = connection

	reader, writer := &FakeReader{}, &FakeWriter{}
	this.broker.readers = append(this.broker.readers, reader)
	this.broker.writers = append(this.broker.writers, writer)

	this.broker.removeReader(reader)

	this.So(this.broker.readers, should.BeEmpty)
	this.So(this.broker.writers, should.BeEmpty)
	this.So(writer.closed, should.Equal, 1)
	this.So(this.broker.State(), should.Equal, messaging.Disconnected)
	this.So(this.broker.connection, should.BeNil)
	this.So(connection.closed, should.Equal, 1)
}

////////////////////////////////////////////////////////

func (this *BrokerFixture) TestSecondToLastReaderShutdownComplete() {
	this.broker.state = messaging.Disconnecting

	reader1, reader2, writer := &FakeReader{}, &FakeReader{}, &FakeWriter{}
	this.broker.readers = append(this.broker.readers, reader1)
	this.broker.readers = append(this.broker.readers, reader2)
	this.broker.writers = append(this.broker.writers, writer)

	this.broker.removeReader(reader1)

	this.So(this.broker.readers, should.NotBeEmpty)
	this.So(this.broker.writers, should.NotBeEmpty)
	this.So(writer.closed, should.Equal, 0)
	this.So(this.broker.State(), should.Equal, messaging.Disconnecting)
}

////////////////////////////////////////////////////////

func (this *BrokerFixture) TestIsolatedReaderCloseDoesntAffectBrokerState() {
	this.broker.state = messaging.Connected
	reader := &FakeReader{}
	this.broker.readers = append(this.broker.readers, reader)

	this.broker.removeReader(reader)

	this.So(this.broker.readers, should.BeEmpty)
	this.So(this.broker.State(), should.Equal, messaging.Connected)
}

////////////////////////////////////////////////////////

func (this *BrokerFixture) TestIsolatedWriterCloseDoesntAffectBrokerState() {
	this.broker.state = messaging.Connected
	writer := &FakeWriter{}
	this.broker.writers = append(this.broker.writers, writer)

	this.broker.removeWriter(writer)

	this.So(this.broker.writers, should.BeEmpty)
	this.So(this.broker.State(), should.Equal, messaging.Connected)
}

////////////////////////////////////////////////////////

func (this *BrokerFixture) TestOpenReaderDuringConnection() {
	this.assertValidReader(messaging.Connecting)
	this.assertValidReader(messaging.Connected)
}
func (this *BrokerFixture) assertValidReader(initialState uint64) {
	this.broker.state = initialState
	reader := this.broker.OpenReader("queue", "bindings1", "bindings2")
	this.So(reader, should.NotBeNil)
	this.So(reader.(*ChannelReader).queue, should.Equal, "queue")
	this.So(reader.(*ChannelReader).bindings, should.Resemble, []string{"bindings1", "bindings2"})
	this.So(this.broker.readers, should.NotBeEmpty)
}

////////////////////////////////////////////////////////

func (this *BrokerFixture) TestOpenReaderDuringDisconnection() {
	this.assertNilReader(messaging.Disconnecting)
	this.assertNilReader(messaging.Disconnected)
}
func (this *BrokerFixture) assertNilReader(initialState uint64) {
	this.broker.state = initialState
	reader := this.broker.OpenReader("queue")
	this.So(reader, should.BeNil)
}

////////////////////////////////////////////////////////

func (this *BrokerFixture) TestOpenTransientReader() {
	this.broker.state = messaging.Connecting
	bindings := []string{"1", "2"}

	reader := this.broker.OpenTransientReader(bindings)

	this.So(reader, should.NotBeNil)
	this.So(reader.(*ChannelReader).bindings, should.Resemble, bindings)
	this.So(this.broker.readers, should.NotBeEmpty)
}

////////////////////////////////////////////////////////

func (this *BrokerFixture) TestOpenWriterDuringConnection() {
	this.assertValidWriter(messaging.Connecting)
	this.assertValidWriter(messaging.Connected)
}
func (this *BrokerFixture) assertValidWriter(initialState uint64) {
	this.broker.state = initialState
	writer := this.broker.OpenWriter()
	this.So(writer, should.NotBeNil)
	this.So(reflect.TypeOf(writer).String(), should.Equal, "*rabbit.ChannelWriter")
	this.So(this.broker.writers, should.NotBeEmpty)
}

////////////////////////////////////////////////////////

func (this *BrokerFixture) TestOpenWriterDuringDisconnection() {
	this.assertNilWriter(messaging.Disconnecting)
	this.assertNilWriter(messaging.Disconnected)
}
func (this *BrokerFixture) assertNilWriter(initialState uint64) {
	this.broker.state = initialState
	writer := this.broker.OpenWriter()
	this.So(writer, should.BeNil)
}

////////////////////////////////////////////////////////

func (this *BrokerFixture) TestOpenTransactionalWriter() {
	this.broker.state = messaging.Connecting

	writer := this.broker.OpenTransactionalWriter()

	this.So(writer, should.NotBeNil)
	this.So(reflect.TypeOf(writer).String(), should.Equal, "*rabbit.TransactionWriter")
	this.So(this.broker.writers, should.NotBeEmpty)
}

////////////////////////////////////////////////////////

func (this *BrokerFixture) TestOpenChannel() {
	this.broker.state = messaging.Connecting

	channel := this.broker.openChannel(func() bool { return true })

	this.So(channel, should.NotBeNil)
	this.So(this.broker.state, should.Equal, messaging.Connected)
}
func (this *BrokerFixture) TestOpenChannelWithFalseCallback() {
	this.broker.state = messaging.Connecting

	channel := this.broker.openChannel(func() bool { return false })

	this.So(channel, should.BeNil)
	this.So(this.connector.connection.attempts, should.Equal, 0)
	this.So(this.broker.state, should.Equal, messaging.Connecting) // don't change state
}

func (this *BrokerFixture) TestNoChannelWhileDisconnected() {
	this.broker.state = messaging.Disconnected
	this.So(this.broker.openChannel(func() bool { return true }), should.BeNil)

	this.broker.state = messaging.Disconnecting
	this.So(this.broker.openChannel(func() bool { return true }), should.BeNil)
}
func (this *BrokerFixture) TestOpenChannelAfterUnderlyingConnectorFailureRetries() {
	this.connector = NewFakeConnector(1, 0)
	this.createBroker()
	this.broker.state = messaging.Connecting

	channel := this.broker.openChannel(func() bool { return true })

	this.So(channel, should.NotBeNil)
	this.So(this.connector.attempts, should.BeGreaterThan, 1)
	this.So(this.broker.state, should.Equal, messaging.Connected)
	this.So(this.naps[0], should.Equal, time.Second*4)
}
func (this *BrokerFixture) TestOpenChannelAfterUnderlyingConnectionFailureRetries() {
	this.connector = NewFakeConnector(0, 1)
	this.createBroker()
	this.broker.state = messaging.Connecting

	channel := this.broker.openChannel(func() bool { return true })

	this.So(channel, should.NotBeNil)
	this.So(this.connector.attempts, should.Equal, 2)
	this.So(this.connector.connection.attempts, should.Equal, 2)
	this.So(this.broker.state, should.Equal, messaging.Connected)
	this.So(this.broker.connection, should.NotBeNil)
	this.So(this.naps[0], should.Equal, time.Second*4)
}
func (this *BrokerFixture) TestOpenChannelClosesConnectionOnFailure() {
	this.connector = NewFakeConnector(0, 2)
	this.createBroker()
	this.broker.state = messaging.Connecting

	channel := this.broker.openChannel(func() bool { return true })

	this.So(channel, should.NotBeNil)
	this.So(this.connector.attempts, should.Equal, 3)
	this.So(this.connector.connection.attempts, should.Equal, 3)
	this.So(this.connector.connection.closed, should.Equal, 2)
	this.So(this.broker.state, should.Equal, messaging.Connected)
	this.So(this.broker.connection, should.NotBeNil)
	this.So(this.naps[0], should.Equal, time.Second*4)
	this.So(this.naps[1], should.Equal, time.Second*4)
}

////////////////////////////////////////////////////////

func (this *BrokerFixture) TestStateChangesSentToCaller() {
	var state uint64 = 0
	this.broker.Notify(func(updated uint64) { state = updated })
	this.broker.Connect()
	this.So(state, should.Equal, messaging.Connecting)
}

////////////////////////////////////////////////////////

type FakeConnector struct {
	attempts   int
	target     url.URL
	failures   int
	connection *FakeConnection
}

func NewFakeConnector(connectorFailures, connectionFailures int) *FakeConnector {
	return &FakeConnector{
		failures:   connectorFailures,
		connection: &FakeConnection{failures: connectionFailures},
	}
}

func (this *FakeConnector) Connect(target url.URL) (Connection, error) {
	this.attempts++
	if this.failures >= this.attempts {
		return nil, errors.New("Fail!")
	}

	return this.connection, nil
}

////////////////////////////////////////////////////////

type FakeConnection struct {
	attempts int
	failures int
	closed   int
}

func (this *FakeConnection) Channel() (Channel, error) {
	this.attempts++
	if this.failures >= this.attempts {
		return nil, errors.New("Fail")
	}

	return &FakeChannel{}, nil
}

func (this *FakeConnection) Close() error {
	this.closed++
	return nil
}

////////////////////////////////////////////////////////

type FakeChannel struct{}

func (this *FakeChannel) ConfigureChannelBuffer(int) error                     { return nil }
func (this *FakeChannel) DeclareExchange(string, string) error                 { return nil }
func (this *FakeChannel) DeclareQueue(string) error                            { return nil }
func (this *FakeChannel) DeclareTransientQueue() (string, error)               { return "", nil }
func (this *FakeChannel) BindExchangeToQueue(string, string) error             { return nil }
func (this *FakeChannel) Consume(string, string) (<-chan amqp.Delivery, error) { return nil, nil }
func (this *FakeChannel) ExclusiveConsume(string, string) (<-chan amqp.Delivery, error) {
	return nil, nil
}
func (this *FakeChannel) ConsumeWithoutAcknowledgement(string, string) (<-chan amqp.Delivery, error) {
	return nil, nil
}
func (this *FakeChannel) ExclusiveConsumeWithoutAcknowledgement(string, string) (<-chan amqp.Delivery, error) {
	return nil, nil
}

func (this *FakeChannel) CancelConsumer(string) error                  { return nil }
func (this *FakeChannel) Close() error                                 { return nil }
func (this *FakeChannel) AcknowledgeSingleMessage(uint64) error        { return nil }
func (this *FakeChannel) AcknowledgeMultipleMessages(uint64) error     { return nil }
func (this *FakeChannel) ConfigureChannelAsTransactional() error       { return nil }
func (this *FakeChannel) PublishMessage(string, amqp.Publishing) error { return nil }
func (this *FakeChannel) CommitTransaction() error                     { return nil }
func (this *FakeChannel) RollbackTransaction() error                   { return nil }

////////////////////////////////////////////////////////

type FakeWriter struct{ closed int }

func (this *FakeWriter) Close()                         { this.closed++ }
func (this *FakeWriter) Write(messaging.Dispatch) error { return nil }

////////////////////////////////////////////////////////

type FakeReader struct{ closed int }

func (this *FakeReader) Close()                                { this.closed++ }
func (this *FakeReader) Listen()                               {}
func (this *FakeReader) Deliveries() <-chan messaging.Delivery { return nil }
func (this *FakeReader) Acknowledgements() chan<- interface{}  { return nil }
