package Manager

import (
	"Config/Config"
	"Config/CronScript"
	"Cron/Cron"
	"Cron/CronInfo"
	"Cron/CronMessage"
	"Cron/CronTask"
	"Cron/CronTimer"
	"HistoryMem/HistoryMem"
	"Logger/Logger"
	"Web/WebClient"
	"Web/WebServer"
	"fmt"
	"sync"
	"time"
)
import (
	"log"
)

// It is main structure
type Manager struct {
	config            *Config.Config
	cron              *Cron.Cron
	chCronFrom        chan CronMessage.Mess
	chCronTo          chan CronMessage.Mess
	chMainIn          chan CronMessage.Mess
	httpClientChannel chan CronMessage.Mess

	Wg            sync.WaitGroup
	LastCheckTime time.Time

	// Script Info && Log
	Currently map[string]*CronInfo.MyCronInfo
	History   *HistoryMem.HistoryMem

	// Timer
	timer       *CronTimer.Timer
	chTimerFrom chan CronMessage.Mess

	// Logger
	logger *Logger.Logger
}

func New(config *Config.Config) *Manager {

	manager := Manager{}
	var wg sync.WaitGroup

	manager.Wg = wg
	manager.config = config
	manager.cron = Cron.NewCron(config)

	//config.LogFile()

	manager.chTimerFrom = CronMessage.Channel()
	manager.timer = CronTimer.Start(1, manager.Wg, manager.chTimerFrom)

	manager.chCronTo = manager.cron.ChCronTo
	manager.chCronFrom = manager.cron.GetChannelProscessFrom()

	manager.chMainIn = CronMessage.Channel()

	manager.LastCheckTime = time.Now()

	manager.Currently = map[string]*CronInfo.MyCronInfo{}
	manager.History = HistoryMem.New()

	return &manager
}

func (manager *Manager) SetLogger(logger *Logger.Logger) {
	manager.logger = logger
}

func (manager *Manager) ToLog(i ...interface{}) {
	if manager.logger != nil {
		manager.logger.ToLog(i...)
	}
}

func (manager *Manager) ToLogAct(act string, i ...interface{}) {
	if manager.logger != nil {
		manager.logger.ToLogAct(act, i...)
	}
}

func (manager *Manager) Live(server *WebServer.Server, client *WebClient.Client) {

	manager.httpClientChannel = client.ChannelIn
	client.Run()

	manager.Wg.Add(1)
	manager.Rules(server)
	manager.Wg.Done()
}

func (manager *Manager) FixCronMessage(mes CronMessage.Mess) error {

	id := mes.ID

	info, find := manager.Currently[id]
	if !find {
		err := fmt.Errorf("FixCronMessage. NOT FOUND SCRIPT ID %s", mes.ID)
		manager.ErrToLog(err)
		return err
	}

	switch mes.Type {
	case "result":
		info.StdRes = &mes
	case "stderr":
		info.StdErr = &mes
	case "stdout":
		info.StdOut = &mes
	case "finish":
		manager.finishScript(id)
	default:
		err := fmt.Errorf("FixCronMessage. NOT FOUND TYPE MESSAGE FROM %s", mes.Type)
		manager.ErrToLog(err)
		return err
	}

	return nil
}

func (manager *Manager) findCurrentScript(id string) (*CronInfo.MyCronInfo, bool) {

	log.Printf("manager.findCurrentScript id: %s\n", id)
	log.Printf("manager.findCurrentScript manager.Currently: %+v\n", manager.Currently)

	info, find := manager.Currently[id]
	return info, find
}

func (manager *Manager) finishScript(id string) error {

	log.Printf("manager.finishScript id: %s\n", id)

	info, find := manager.findCurrentScript(id)
	if !find {
		log.Printf("finishScript. Script %s not found", id)
		return fmt.Errorf("finishScript. Script %s not found", id)
	}

	delete(manager.Currently, id)

	log.Printf("manager.finishScript id 2: %s\n", id)

	info.Script.MarkFinish() // set time.Now() as finish moment
	// Help Gargabe Collector
	info.Clean()
	log.Printf("manager.finishScript id 3: %s\n", id)

	log.Printf("manager.finishScript info: %+v\n", info)
	manager.History.Add(info)

	//manager.History = append(manager.History, &h)
	manager.SaveResult()

	// We're waiting for running script.
	// If the script was marked as deleted, check it now
	manager.config.CheckDeletedScript(id)

	return nil
}

func (manager *Manager) logScriptById(id string) map[string]interface{} {

	out := map[string]interface{}{}
	list := []map[string]interface{}{}
	out["status"] = "not_found"

	now, findNow := manager.Currently[id]
	if findNow {
		d := map[string]interface{}{
			"stdout":    "",
			"result":    "",
			"error":     "",
			"start":     now.Script.LastStart.Format(Logger.DateLayOut),
			"finish":    "",
			"task_id":   now.Info.TaskID,
			"script_id": id,
			"status":    "in_progress",
		}
		list = append(list, d)
		out["status"] = "in_progress"
	}

	if old, findOld := manager.History.LastExe(id); findOld {
		list = append(list, old...)
		if !findNow {
			out["status"] = "finish"
		}
	}

	log.Printf("manager.Currently: %+v\n", manager.Currently)

	out["list"] = list

	return out
}

func (manager *Manager) startScriptById(id string) error {

	script, find := manager.config.GetScript(id)
	if !find {
		return fmt.Errorf("%s", "NOT FOUDN")
	}

	if err := manager.startScript(script); err != nil {
		return err
	}

	return nil
}

func (manager *Manager) startScript(script *CronScript.Script) error {

	id := script.ID

	if _, find := manager.findCurrentScript(id); find {
		return nil
	}

	if _, find := manager.cron.GetTask(id); !find {
		task := manager.scriptToCronTask(script)
		manager.cron.AddTask(task)
	}

	script.MarkStart(time.Now())

	info, err := manager.cron.Do(id)

	if err != nil {
		manager.ErrToLog(err)
		return err
	}

	manager.Currently[id] = &CronInfo.MyCronInfo{
		Info:   info,
		Script: script,
	}

	manager.SaveStart(script)

	return nil
}

func (manager *Manager) TimerAction(t ...time.Time) {
	if len(t) > 0 {
		manager.LastCheckTime = t[0]
	} else {
		manager.LastCheckTime = time.Now()
	}

	list := manager.config.StartNow(manager.LastCheckTime)

	for _, script := range list {
		log.Printf("TimerAction. script: %+v\n", script)
		manager.startScript(script)
	}
}

func (manager *Manager) scriptToCronTask(script *CronScript.Script) *CronTask.Task {
	task := CronTask.NewTask(script.ID, script.Exe, script.Params)
	return task
}

func (manager *Manager) TxtLog(f string, i ...interface{}) {
	str := fmt.Sprintf(f, i...)
	manager.ToLog(str)
}

func (manager *Manager) ErrToLog(err error) {
	manager.ToLog(fmt.Sprintf("%s", err))
}

func (manager *Manager) SaveStart(script *CronScript.Script) {

	d := map[string]interface{}{
		"id":     script.ID,
		"exe":    script.Exe,
		"env":    script.Env,
		"params": script.Params,
	}

	manager.ToLogAct("start_script", d)
}

func (manager *Manager) SaveResult() {

	if d, find := manager.History.Last(); find {
		manager.ToLogAct("result_script", d)
	}
}
