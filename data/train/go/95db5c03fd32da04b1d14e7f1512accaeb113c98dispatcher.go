package job

import (
	"github.com/sacloud/sackerel/job/core"
	"github.com/sacloud/sackerel/job/worker/timer"
	"log"
	"os"
	"time"
)

// Dispatcher ジョブキューに対するディスパッチ処理を担当する
type Dispatcher struct {
	option    *core.Option
	queue     *core.Queue
	timerJobs []core.TimerJobAPI
}

// NewDispatcher Dispatcherの新規作成
func NewDispatcher(option *core.Option, queue *core.Queue) *Dispatcher {
	return &Dispatcher{
		option: option,
		queue:  queue,
		timerJobs: []core.TimerJobAPI{
			timer.DetectResourceTimerJob(option.TimerJobInterval),
			timer.ReconcileHostTimerJob(option.ReconcileJobInterval),
		},
	}
}

// Dispatch ジョブキューに対する各種ワーカーの登録やルーティング処理の登録、ディスパッチを行う
func (d *Dispatcher) Dispatch() error {

	d.queue.PushInfo(" ***** Start sackerel ***** ")

	// エラー時処理 登録
	d.dispatchMessageAction()

	// ジョブのルーティング 登録
	d.dispatchJobRequests()

	// API呼び出し 登録
	d.dispatchJobs()

	// 初期化用ジョブ起動
	d.dispatchInitJobs()

	// タイマーディスパッチ 登録
	d.dispatchTimerJobs()

	// 終了待機
	err := <-d.queue.Quit
	return err
}

func (d *Dispatcher) dispatchInitJobs() {
	if d.option.SkipInit {
		return
	}
	d.queue.PushRequest("init", nil)
}

func (d *Dispatcher) dispatchMessageAction() {

	log.SetFlags(log.Ldate | log.Ltime)
	log.SetOutput(os.Stdout)
	out := log.Printf

	go func() {
		for {
			select {
			case msg := <-d.queue.Logs.Trace:
				if d.option.TraceLog {
					go out("[TRACE] %s\n", msg)
				}
			case msg := <-d.queue.Logs.Info:
				if d.option.InfoLog {
					go out("[INFO]  %s\n", msg)
				}
			case err := <-d.queue.Logs.Warn:
				if d.option.WarnLog {
					go out("[WARN]  %s\n", err)
				}
			case err := <-d.queue.Logs.Error:
				if d.option.ErrorLog {
					go out("[ERROR] %s\n", err)
				}
			}
		}
	}()
}

func (d *Dispatcher) dispatchJobRequests() {

	router := NewRouter(d.queue, d.option)

	go func() {
		for {
			select {
			case req := <-d.queue.Request:
				go router.Routing(req)
			}
		}
	}()
}

func (d *Dispatcher) dispatchJobs() {

	jobQueues := []chan core.JobAPI{
		d.queue.SakuraRequest,
		d.queue.MackerelRequest,
		d.queue.Internal,
	}

	for _, jobQ := range jobQueues {
		q := jobQ
		go func() {
			for {
				select {
				case job := <-q:
					go job.Start(d.queue, d.option)
				}
			}
		}()
	}

	// スロットリングありキューは合間にインターバルを設けておく
	q := d.queue.ThrottledRequest
	go func() {
		for {
			select {
			case job := <-q:
				time.Sleep(d.option.APICallInterval)
				go job.Start(d.queue, d.option)
			}
		}
	}()

}

func (d *Dispatcher) dispatchTimerJobs() {
	for _, job := range d.timerJobs {
		t := time.NewTicker(job.GetTickerDuration())
		j := job

		// 起動時に即時実行しておく
		go j.Start(d.queue, d.option)

		go func() {
			for {
				select {
				case <-t.C:
					go j.Start(d.queue, d.option)
				}
			}
		}()
	}

}
