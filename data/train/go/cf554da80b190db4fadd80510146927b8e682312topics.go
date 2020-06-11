package broker

import (
	"context"
	"math/rand"
	"strconv"
	"time"

	"google.golang.org/grpc"

	"github.com/astaxie/beego/logs"
	"github.com/coreos/etcd/clientv3"
	"github.com/ohmq/ohmyqueue/config"
	"github.com/ohmq/ohmyqueue/inrpc"
)

func (broker *Broker) watchTopics() {
	resp, _ := broker.Client.Get(context.TODO(), "topicname", clientv3.WithPrefix())
	for _, v := range resp.Kvs {
		broker.topics.AddTopic(string(v.Key[9:]))
		tlresp, _ := broker.Client.Get(context.TODO(), "topicleader"+string(v.Key[9:]))
		if tlresp.Count == 0 {
			go broker.voteTopicleader(string(v.Key[9:]))
		}
	}
	wch := broker.Client.Watch(context.TODO(), "topicname", clientv3.WithPrefix())
	for wresp := range wch {
		for _, ev := range wresp.Events {
			switch ev.Type.String() {
			case "PUT":
				broker.topics.AddTopic(string(ev.Kv.Key[9:]))
				resp, _ := broker.Client.Get(context.TODO(), "brokerleader", clientv3.WithPrefix())
				var sum int
				for _, v := range resp.Kvs {
					tmp, _ := strconv.Atoi(string(v.Value))
					sum += tmp
				}
				if len(broker.leaders) <= sum/int(resp.Count) {
					go broker.voteTopicleader(string(ev.Kv.Key[9:]))
				}
			}
		}
	}
}

func (broker *Broker) watchTopicLeader() {
	wch := broker.Client.Watch(context.TODO(), "topicleader", clientv3.WithPrefix())
	for wresp := range wch {
		for _, ev := range wresp.Events {
			switch ev.Type.String() {
			case "PUT":
				if string(ev.Kv.Value) == broker.ip+":"+broker.clientport {
					broker.leaders = append(broker.leaders, string(ev.Kv.Key[11:]))
				}
			case "DELETE":
				go broker.voteTopicleader(string(ev.Kv.Key[11:]))
			}
		}
	}
}

func (broker *Broker) voteTopicleader(name string) {
	logs.Info("I am voting for topic:", name)
	<-time.After(time.Duration(rand.New(rand.NewSource(time.Now().Unix())).Intn(200)) * time.Millisecond)
	resp, err := broker.Client.Grant(context.TODO(), config.Conf.Omq.Timeout)
	if err != nil {
		logs.Error(err)
	}
	if txnresp, _ := broker.Client.Txn(context.TODO()).
		If(clientv3.Compare(clientv3.CreateRevision("topicleader"+name), "=", 0)).
		Then(clientv3.OpPut("topicleader"+name, broker.ip+":"+broker.clientport, clientv3.WithLease(resp.ID))).
		Commit(); txnresp.Succeeded {
		go broker.topicLeaderHeartbeat(resp, name)
	}
}

func (broker *Broker) topicLeaderHeartbeat(resp *clientv3.LeaseGrantResponse, name ...string) {
	for {
		<-time.After(time.Second * time.Duration((config.Conf.Omq.Timeout - 2)))
		logs.Info("topicLeaderHeartbeat for:", name)
		_, err := broker.Client.KeepAliveOnce(context.TODO(), resp.ID)
		if err != nil {
			logs.Error(err)
		}
	}
}

func (broker *Broker) watchBrokers() {
	resp, _ := broker.Client.Get(context.TODO(), "brokerid", clientv3.WithPrefix())
	for _, v := range resp.Kvs {
		if string(v.Key) != "brokerid"+strconv.Itoa(broker.id) {
			broker.members[string(v.Key)] = string(v.Value)
			mc, msgch := makeconn(string(v.Value))
			broker.tmpch[string(v.Key)] = msgch
			go putfollow(mc, msgch)
		}
	}
	wch := broker.Client.Watch(context.TODO(), "brokerid", clientv3.WithPrefix())
	for wresp := range wch {
		for _, ev := range wresp.Events {
			switch ev.Type.String() {
			case "PUT":
				if string(ev.Kv.Key) != "brokerid"+strconv.Itoa(broker.id) {
					logs.Info("creat broker:", string(ev.Kv.Value))
					broker.members[string(ev.Kv.Key)] = string(ev.Kv.Value)
					mc, msgch := makeconn(string(ev.Kv.Value))
					broker.tmpch[string(ev.Kv.Key)] = msgch
					go putfollow(mc, msgch)
					go broker.sync(msgch)
				}
			case "DELETE":
				close(broker.tmpch[string(ev.Kv.Key)])
				delete(broker.tmpch, string(ev.Kv.Key))
				delete(broker.members, string(ev.Kv.Key))
			}
		}
	}
}

func makeconn(ip string) (inrpc.In_SyncMsgClient, chan *inrpc.Msg) {
	conn, _ := grpc.Dial(ip, grpc.WithInsecure())
	c := inrpc.NewInClient(conn)
	mc, _ := c.SyncMsg(context.TODO())
	msgch := make(chan *inrpc.Msg, 1000)
	return mc, msgch
}

func putfollow(mc inrpc.In_SyncMsgClient, msgch chan *inrpc.Msg) {
	for {
		msg, ok := <-msgch
		if ok && msg != nil {
			logs.Info(ok, msg)
			err := mc.Send(msg)
			if err != nil {
				logs.Error(err)
				continue
			}
		} else {
			return
		}
	}
}

func (broker *Broker) sync(msgch chan *inrpc.Msg) {
	for _, v := range broker.leaders {
		for _, msg := range broker.topics.GetAll(v) {
			msgch <- msg
		}
	}
}
