package until

import (
	"github.com/playnb/mustang/log"
	"fmt"
	"os/exec"
	"sync"
	"time"
)

type ProcessDefine struct {
	process   *exec.Cmd
	app       string
	args      []string
	retry     bool
	terminate bool
}

func (pd *ProcessDefine) String() string {
	return fmt.Sprintf("[ProcessDefine:app:%s args:%v retry:%v terminate:%v ]", pd.app, pd.args, pd.retry, pd.terminate)
}

func runProcessFunc(rp *RunProcess, define *ProcessDefine) {
	defer func() {
		if err := recover(); err != nil {
			fmt.Println(err)
		}
	}()

	try := 0
	log.Trace("启动进程@ proc:%s", define)
	for {
		define.process = exec.Command(define.app, define.args...)
		//define.process.Stderr
		err := define.process.Run()
		if err != nil {
			log.Trace(err.Error())
		}
		if define.retry {
			time.Sleep(time.Second)
			try++
			log.Trace("重新启动进程@ try:%d proc:%s", try, define)
		} else {
			break
		}
	}
	rp.wg.Done()
}

var _insRunProcess = &RunProcess{}

func GetRunProcess() *RunProcess {
	return _insRunProcess
}

type RunProcess struct {
	process []*ProcessDefine
	wg      sync.WaitGroup
}

func (rp *RunProcess) RegisterPorcess(app string, args []string, retry bool, terminate bool) *ProcessDefine {
	def := &ProcessDefine{
		app:       app,
		args:      args,
		retry:     retry,
		terminate: terminate,
	}
	rp.process = append(rp.process, def)

	rp.wg.Add(1)
	go runProcessFunc(rp, def)

	return def
}

func (rp *RunProcess) Join() {
	rp.wg.Wait()
}

func (rp *RunProcess) Terminate() {
	for _, v := range rp.process {
		if v.process != nil {
			v.process.Process.Kill()
		}
	}
}
