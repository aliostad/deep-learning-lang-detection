package stat

import (
    "indie/core"
    "fmt"
    "time"
    "reflect"
)

/**
 * 1. inherit from core.Module
 * 2. implement IModule interface
 */
type StatModule struct {
    // inherit from core.Module
    core.Module
}

// implement IModule interface
func (t StatModule) Config(conf *core.ModuleConf) {
    dispatchWorker, _ := conf.Int("dispatch_worker")
    fmt.Println("Config " + t.Name + "'s configuratons, dispatch_worker: ", dispatchWorker)
}

// Module start to work
func (t StatModule) Handle() {
    fmt.Println(reflect.TypeOf(t).String())

    time.Sleep(time.Second * 3)
    fmt.Println(t.Name + " start to run...")
}

// When receive TERM signal, Stop func will be invoked
func (t StatModule) Stop() {
    fmt.Println(t.Name + " stop")
}

func NewStatModule() *StatModule {
    m := new(StatModule)

    // Module name, and [MODULE_STAT] configuration section will be parse
    m.Name = "STAT"
    return m
}
