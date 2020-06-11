package dispatch

import "errors"

// ErrManagerNotReady ErrManagerNotReady
var ErrManagerNotReady = errors.New("Manager is not ready")

// Manager 管理员，接受任务和派发任务
type Manager struct {
	workPool    chan *Worker  // the pool of workers
	jobQueue    chan Job      // accept incoming job
	stopChannel chan struct{} // 停止
	isReady     bool          // 是处于可用状态
}

// NewManager create a new *Manager
func NewManager(maxWorkerCount int) *Manager {
	//
	pool := make(chan *Worker, maxWorkerCount)
	return &Manager{
		workPool:    pool,
		jobQueue:    make(chan Job),
		stopChannel: make(chan struct{}),
		isReady:     false}
}

// Setup 创建workers
func (manager *Manager) Setup() {
	count := cap(manager.workPool)
	for i := 0; i < count; i++ {
		worker := NewWorker(manager)
		worker.Start()
	}
}

// Start 开始接受任务
func (manager *Manager) Start() {
	go manager.dispatch()
	manager.isReady = true
}

// Accept 接收到新的任务
func (manager *Manager) Accept(job Job) error {
	if manager.IsReady() {
		manager.jobQueue <- job
		return nil
	}
	return ErrManagerNotReady
}

// Stop 停止接受任务
func (manager *Manager) Stop() {
	manager.isReady = false
	manager.stopChannel <- struct{}{}
}

// IsReady 是否可用
func (manager *Manager) IsReady() bool {
	return manager.isReady
}

// dispatch 派发任务
func (manager *Manager) dispatch() {
	for {
		select {
		case job := <-manager.jobQueue:
			go func(job Job) {
				// try to obtain a worker job channel that is available.
				// this will block until a worker is idle
				worker := <-manager.workPool
				// dispatch the job to the worker's job channel
				worker.Receive(job)
			}(job)
		case <-manager.stopChannel:
			return
		}
	}
}

// register 注册worker，表示worker现在空闲可用
func (manager *Manager) register(worker *Worker) {
	manager.workPool <- worker
}
