package broker

import (
	"sync"
	"container/list"
	"time"
)

type Queue struct {
	sync.RWMutex

	broker *Broker

	//store Store

	name string

	channelList *list.List // 记录bind到该队列上的channel

	//msgList *list.List

	task chan func()
}

func (queue *Queue) run() {

	for {
		select {
		case f := <-queue.task:
			f()
		case <-time.After(5 * time.Minute):
		//		// 如果channel的长度为0并且队列里面没有消息，则该队列可以被删除
		//		if queue.channelList.Len() == 0 {
		//			m, _ := queue.getMsg()
		//			if m == nil {
		//				//no conn, and no msg
		//				rq.qs.Delete(rq.name)
		//				return
		//			}
		//		}
		}
	}
}

func (queue *Queue) pushFanout() {

}

func NewQueue(broker *Broker, name string) (*Queue, error) {
	queue := new(Queue)
	queue.broker = broker
	queue.name = name

	queue.channelList = new(list.List)

	broker.queues[name] = queue

	// 运行队列
	go queue.run()


	return queue, nil
}
