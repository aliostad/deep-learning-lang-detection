package broker

import (
	"net"

	"strconv"

	"time"

	"github.com/coreos/etcd/clientv3"
	"github.com/ohmq/ohmyqueue/etcd"
	"github.com/ohmq/ohmyqueue/inrpc"
	"github.com/ohmq/ohmyqueue/msg"
	"golang.org/x/net/context"
)

type Broker struct {
	id         int
	Client     *clientv3.Client
	ip         string
	clientport string
	innerport  string
	leader     string
	members    map[string]string
	topics     msg.Topics
	tmpch      map[string]chan *inrpc.Msg
	leaders    []string
}

func NewBroker(id int, cliport string, inport string) *Broker {
	var ip string
	addrs, _ := net.InterfaceAddrs()
	for _, a := range addrs {
		if ipnet, ok := a.(*net.IPNet); ok && !ipnet.IP.IsLoopback() {
			if ipnet.IP.To4() != nil {
				ip = ipnet.IP.String()
			}
		}
	}
	var ls []string
	return &Broker{
		id:         id,
		Client:     etcd.NewEtcd().Client,
		ip:         ip,
		members:    make(map[string]string),
		clientport: cliport,
		innerport:  inport,
		topics:     msg.NewTopics(),
		leaders:    ls,
		tmpch:      make(map[string]chan *inrpc.Msg, 10),
	}
}

func (broker *Broker) Stop() {
	broker.Client.Close()
	broker.topics.Close()
}

func (broker *Broker) Put(topic, alivetime, body string, offset ...int64) {
	if len(offset) != 0 {
		broker.topics.Put(topic, alivetime, body, offset...)
	} else {
		off := broker.topics.Put(topic, alivetime, body)
		for _, msgch := range broker.tmpch {
			msgch <- &inrpc.Msg{
				Topic:     topic,
				Offset:    off,
				Alivetime: alivetime,
				Body:      body,
			}
		}
		broker.Client.Put(context.TODO(), "topicattr"+topic, strconv.FormatInt(off, 10)+":"+strconv.FormatInt(time.Now().Unix(), 10))
	}
}

func (broker *Broker) Get(topic string, offset int64) (int64, string, error) {
	return broker.topics.Get(topic, offset)
}
