package lobby

import (
	"exportor/defines"
	"communicator"
	"sync"
	"runtime/debug"
	"mylog"
)


type brokerHandler func(data interface{})

type brokerNotifyTask struct {
	fn 			brokerHandler
	data 		interface{}
}

type brokerProcessor struct {
	notify 		chan *brokerNotifyTask
	size 		int
	con 		defines.IMsgConsumer
	pub 		defines.IMsgPublisher
	wg 			*sync.WaitGroup
}

func newBrokerProcessor() *brokerProcessor {
	processor := &brokerProcessor{}
	processor.notify = make(chan *brokerNotifyTask, 1024)
	processor.size = 16
	processor.con = communicator.NewMessageConsumer()
	processor.pub = communicator.NewMessagePulisher()
	processor.wg = new(sync.WaitGroup)
	return processor
}

func (p *brokerProcessor) call(n *brokerNotifyTask) {
	defer func() {
		if r := recover(); r != nil {
			mylog.Debug("broker process recover, exception stack")
			debug.PrintStack()
		}
	}()
	n.fn(n.data)
}

func (p *brokerProcessor) Start() {
	p.con.Start()
	p.pub.Start()
	for i := 0; i < p.size; i++ {
		p.wg.Add(1)
		go func() {
			defer func() {
				p.wg.Done()
			}()
			for {
				select {
				case t := <- p.notify:
					p.call(t)
				}
			}
		}()
	}
}

func (p *brokerProcessor) Register(c, k string, fn brokerHandler) {
	go func() {
		for {
			data := p.con.GetMessage(c, k)
			p.notify <- &brokerNotifyTask{
				fn: fn,
				data: data,
			}
		}
	}()
}
