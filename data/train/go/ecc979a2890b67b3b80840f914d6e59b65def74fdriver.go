package ctrl

import "cloudtask-agent/cache"
import "common/models"
import "common/gutils/logger"

import (
	"time"
)

/*
  DriverDispose 处理任务执行
  回调状态后需要通报jobserver服务器(任务启动停止状态，执行结果等等)
*/
func (c *Controller) DriverDispose(event cache.CacheEvent, action *models.Action, jobbase *models.JobBase) {

	logger.INFO("[#ctrl#] driver dispose:%s jobid:%s", event.String(), jobbase.JobId)
	if c.Quit {
		logger.INFO("[#ctrl#] controller is quit, return workdriverproc.")
		return
	}

	switch event {
	case cache.ONCACHE_JOBSET:
		{
			logger.INFO("[#ctrl#] driver set %s.", jobbase.JobId)
			c.Driver.Set(jobbase)
		}
	case cache.ONCACHE_JOBREMOVE:
		{
			logger.INFO("[#ctrl#] driver remove %s.", jobbase.JobId)
			c.Driver.Release(jobbase.JobId)
		}
	case cache.ONCACHE_JOBACTION:
		{
			logger.INFO("[#ctrl#] driver %s, action %s.", jobbase.JobId, action.Type.String())
			c.Driver.Action(action)
		}
	}
}

/*
  DriverClear 清空任务执行对象
  强制清空，不会触发任何回调
*/
func (c *Controller) DriverClear() {

	logger.INFO("[#ctrl#] driver clear.")
	c.Driver.Clear()
}

/*
  DriverStartDispatch 开启任务调度轮询检测
  Quit后触发WaitStoped chan
*/
func (c *Controller) DriverStartDispatch() {

	logger.INFO("[#ctrl#] driver start dispatch...")
NEW_TICK_DURATION:
	c.Ticker = time.NewTicker(time.Second * 1)
	for {
		select {
		case <-c.WaitStoped:
			c.Ticker.Stop()
			return
		case <-c.Ticker.C:
			c.Driver.Dispatch()
			c.Ticker.Stop()
			goto NEW_TICK_DURATION
		}
	}
}

/*
  DriverStopDispatch 停止任务调度轮询检测
  WaitStoped chan 等待停止全部job子程序后退出主程序
*/
func (c *Controller) DriverStopDispatch() {

	logger.INFO("[#ctrl#] driver stop dispatch...")
	c.WaitStoped = make(chan bool)
	c.Quit = true
	c.WaitStoped <- true //等待退出
	close(c.WaitStoped)
	c.Driver.Clear() //开始清空退出
}
