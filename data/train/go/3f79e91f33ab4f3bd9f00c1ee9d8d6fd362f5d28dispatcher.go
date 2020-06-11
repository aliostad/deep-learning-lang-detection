package main

import "fmt"

//初始化dispatcher
//根据传入的worker数量来初始化
func NewDispatcher(maxWorkers int) *Dispatcher {
	//初始化dispatch里的pool
	//设置worker数量
	WorkerPool = make(chan chan Job, maxWorkers)
	fmt.Printf("make worker pool of dispatcher :%v workers\n", maxWorkers)
	return &Dispatcher{WorkerPool: WorkerPool, MaxWorkers: maxWorkers}
}

func (d *Dispatcher) Run() {
	//按照dispatcher里的worker数量
	//初始化每一个worker
	//控制worker的数量也就是控制goroutine的数量，这样可以避免内存暴涨
	for i := 0; i < d.MaxWorkers; i++ {
		fmt.Printf("new worker, worker id: %v\n", i)
		worker := NewWorker(d.WorkerPool, i)
		worker.Start()
	}

	//开始事件轮询，函数返回
	go d.dispatch()
}

func (d *Dispatcher) dispatch() {
	println("dispatch start")
	for {
		println("dispatch loop")
		select {
		//如果JobQueue为空的话，这里会一直阻塞，因为没有其它的case
		case job := <-JobQueue:
			go func(job Job) {
				//从全局的workerpool中拿到一条jobChannel
				//然后把当前的job塞到这条jobChannel
				//然后这条jobChannel对应的worker就可以拿到job去处理了
				workerJobChannel := <-d.WorkerPool
				workerJobChannel <- job
			}(job)
		}
		println("dispatch loop end")
	}
}
