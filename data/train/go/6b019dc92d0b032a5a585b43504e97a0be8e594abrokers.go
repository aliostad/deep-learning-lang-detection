package client

import (
	"fmt"
	"github.com/yanzay/log"
	"net"
	"sync"
	"sync/atomic"
	"time"
)

// BrokerConnection manages TCP connections to a single broker.
type BrokerConnection struct {
	broker *Broker
	pool   sync.Pool
}

// NewBrokerConnection creates a new BrokerConnection to a given broker with a given TCP keep alive timeout.
func NewBrokerConnection(broker *Broker, keepAliveTimeout time.Duration) *BrokerConnection {
	return &BrokerConnection{
		broker: broker,
		pool: sync.Pool{
			New: func() interface{} {
				addr, err := net.ResolveTCPAddr("tcp", fmt.Sprintf("%s:%d", broker.Host, broker.Port))
				if err != nil {
					return err
				}
				conn, err := net.DialTCP("tcp", nil, addr)
				if err != nil {
					return err
				}

				err = conn.SetKeepAlive(true)
				if err != nil {
					return err
				}
				err = conn.SetKeepAlivePeriod(keepAliveTimeout)
				if err != nil {
					return err
				}

				return conn
			},
		},
	}
}

// GetConnection either gets an existing connection from pool or creates a new one. May return an error if
// fails to open a new connection.
func (bc *BrokerConnection) GetConnection() (*net.TCPConn, error) {
	maybeConn := bc.pool.Get()
	err, ok := maybeConn.(error)
	if ok {
		return nil, err
	}

	return maybeConn.(*net.TCPConn), nil
}

// ReleaseConnection puts an existing connection back to pool to be reused later.
func (bc *BrokerConnection) ReleaseConnection(conn *net.TCPConn) {
	bc.pool.Put(conn)
}

// Brokers provide information about Kafka cluster and expose convenience functions to simplify interaction with it.
type Brokers struct {
	brokers          map[int32]*BrokerConnection
	correlationIDs   *CorrelationIDGenerator
	keepAliveTimeout time.Duration
	lock             sync.RWMutex
}

// NewBrokers creates new Brokers with provided TCP keep alive timeout for all connection pools that will be created
// by this structure.
func NewBrokers(keepAliveTimeout time.Duration) *Brokers {
	return &Brokers{
		brokers:          make(map[int32]*BrokerConnection),
		correlationIDs:   new(CorrelationIDGenerator),
		keepAliveTimeout: keepAliveTimeout,
	}
}

// Get gets a BrokerConnection for a given broker ID.
func (b *Brokers) Get(id int32) *BrokerConnection {
	b.lock.RLock()
	defer b.lock.RUnlock()

	return b.brokers[id]
}

// GetAll gets all BrokerConnections for this Brokers structure.
func (b *Brokers) GetAll() []*BrokerConnection {
	b.lock.RLock()
	defer b.lock.RUnlock()

	brokers := make([]*BrokerConnection, 0, len(b.brokers))
	for _, broker := range b.brokers {
		brokers = append(brokers, broker)
	}

	return brokers
}

// Add adds a new Kafka broker infromation to this Brokers structure.
func (b *Brokers) Add(broker *Broker) {
	if broker == nil {
		log.Warning("Brokers.Add received a nil broker, ignoring")
		return
	}

	b.lock.Lock()
	b.brokers[broker.ID] = NewBrokerConnection(broker, b.keepAliveTimeout)
	b.lock.Unlock()
}

// Update updates Kafka broker information in this Brokers structure.
func (b *Brokers) Update(broker *Broker) {
	if broker == nil {
		log.Warning("Brokers.Update received a nil broker, ignoring")
		return
	}

	b.lock.Lock()
	defer b.lock.Unlock()

	oldBroker := b.brokers[broker.ID]
	// if the broker with given id does not yet exist or changed location - update it, otherwise do nothing
	if oldBroker == nil || oldBroker.broker.Host != broker.Host || oldBroker.broker.Port != broker.Port {
		b.brokers[broker.ID] = NewBrokerConnection(broker, b.keepAliveTimeout)
		return
	}
}

// Remove removes Kafka broker information from this Brokers structure.
func (b *Brokers) Remove(id int32) {
	b.lock.Lock()
	defer b.lock.Unlock()

	if b.brokers[id] == nil {
		log.Debug("Tried to remove inexisting broker, ignoring")
		return
	}

	delete(b.brokers, id)
}

// NextCorrelationID returns a next sequential request correlation ID.
func (b *Brokers) NextCorrelationID() int32 {
	return b.correlationIDs.NextCorrelationID()
}

// CorrelationIDGenerator is a simple structure that provides thread-safe correlation ID generation.
type CorrelationIDGenerator struct {
	id int32
}

// NextCorrelationID returns a next sequential request correlation ID.
func (c *CorrelationIDGenerator) NextCorrelationID() int32 {
	return atomic.AddInt32(&c.id, 1)
}
