package worker

type Dispatch struct {
	pool       chan chan Job
	maxWorkers int
	workers    []*Worker
	jobQueue   chan Job
}

func NewDispatch(maxWorkers int, jobQueue chan Job) *Dispatch {
	return &Dispatch{
		pool:       make(chan chan Job, maxWorkers),
		maxWorkers: maxWorkers,
		jobQueue:   jobQueue,
	}
}

func (d *Dispatch) Stop() {
	for _, w := range d.workers {
		w.quit <- true
	}
}

func (d *Dispatch) Run() {
	//初始化工作池
	for i := 0; i < d.maxWorkers; i++ {
		w := NewWorker(d.pool)
		w.Run()

		d.workers = append(d.workers, w)
	}

	//开始分配任务
	go d.dispatch()
}

func (d *Dispatch) dispatch() {
	for {
		select {
		case job := <-d.jobQueue:
			//开一个goroutine处理
			go func(job Job) {
				//获取一个worker jobchan
				jobChan := <-d.pool

				//发送任务
				jobChan <- job
			}(job)
		}
	}
}
