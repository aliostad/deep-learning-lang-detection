package broker

import (
	"net"
	"sync"
)

const (
	//RUNNING status
	RUNNING = iota
	//STOP status
	STOP
)

//Broker instance
type Broker struct {
	msg  net.Listener
	http net.Listener

	stable Storage

	status  int
	stat    *Stat
	topicMu sync.RWMutex
	topics  map[string]*TopicQueue
}

//OneBroker Only one broker
var OneBroker sync.Once

//DefaultBroker used by singleton
var DefaultBroker *Broker

//GetInstance is the singleton interface
func GetInstance() *Broker {
	OneBroker.Do(NewBroker)
	return DefaultBroker
}

//NewBroker be invoked by singleton
func NewBroker() {
	broker := new(Broker)

	var err error
	broker.msg, err = net.Listen("tcp", PortToLocalAddr(Config.MsgPort))
	PanicIfErr(err)

	broker.http, err = net.Listen("tcp", PortToLocalAddr(Config.HttpPort))
	PanicIfErr(err)

	broker.status = STOP
	broker.stat = NewStat()
	broker.topics = make(map[string]*TopicQueue)

	if Config.Aof != "" {
		broker.stable = NewStorageAOF(Config.Aof, int32(Config.SyncType), Config.Threshold)
	} else {
		broker.stable = NewStable()
	}

	DefaultBroker = broker
}

//Start the broker
func (b *Broker) Start() {
	b.status = RUNNING
	ServeHTTP(b.http)
	b.Replay()
	Log.Printf("Message service listening on port :%d\n", Config.MsgPort)
	for {
		conn, err := b.msg.Accept()
		if err != nil {
			Debug.Println(err)
			break
		}
		c := newClient(b, conn)
		go c.Run()
	}
}

//Stop the broker
func (b *Broker) Stop() {
	b.status = STOP
	if b.stable != nil {
		b.stable.Close()
	}
	if b.msg != nil {
		b.msg.Close()
	}
	if b.http != nil {
		b.http.Close()
	}
}

//Get topic
func (b *Broker) Get(topic string) *TopicQueue {
	b.topicMu.RLock()

	if t, ok := b.topics[topic]; ok {
		b.topicMu.RUnlock()
		return t
	}
	b.topicMu.RUnlock()
	t := NewTopicQueue(b, topic)
	b.topicMu.Lock()
	b.topics[topic] = t
	b.topicMu.Unlock()
	return t
}

//Delete topic
func (b *Broker) Delete(topic string) {
	b.topicMu.Lock()
	tq, ok := b.topics[topic]
	if ok {
		tq.Close()
		delete(b.topics, topic)
	}
	b.topicMu.Unlock()
}

//TotalTopic returns the number of topics currently.
func (b *Broker) TotalTopic() int {
	return len(b.topics)
}

//Storage return the Storage
func (b *Broker) Storage() Storage {
	return b.stable
}

//Replay will recover the msgs in db when the broker startup
func (b *Broker) Replay() {
	for {
		//it may block here
		m, err := b.stable.Get()
		if err != nil {
			break
		}
		topic := b.Get(m.GetTopic())
		topic.Push(m)
	}
}

//Stat returns a Stat replication
func (b *Broker) Stat() *Stat {
	return b.stat.Get()
}
