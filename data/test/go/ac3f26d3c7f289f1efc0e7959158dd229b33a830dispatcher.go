package main

import (
	"gopkg.in/ini.v1"
	"justdevelop.it/goaway/modules/analyzer"
	"justdevelop.it/goaway/modules/guardian"
	"justdevelop.it/goaway/modules/janitor"
	"justdevelop.it/goaway/modules/recorder"
	"sync"
	"justdevelop.it/goaway/modules"
	"fmt"
	"justdevelop.it/goaway/utils"
)

type Dispatcher struct {
	wg                sync.WaitGroup
	dispatchedModules []modules.LongRunner
}

func NewDispatcher() *Dispatcher {
	return &Dispatcher{}
}

func (d *Dispatcher) StopRunningModules() {
	for _, module := range d.dispatchedModules {
		module.Quit()
	}
	d.dispatchedModules = nil
}

func (d *Dispatcher) DispatcherWait() {
	d.wg.Wait()
}

func (d *Dispatcher) DispatchAnalyzer(cfg *ini.File) {
	fmt.Println("Disptacher: disptaching Analyzer")
	pps := analyzer.Pps(cfg, serviceManager)
	d.dispatch(pps)
}

func (d *Dispatcher) DispatchJanitor(cfg *ini.File) {
	jan := janitor.New(cfg, serviceManager)
	d.dispatch(jan)
}

func (d *Dispatcher) DispatchServer(cfg *ini.File) {
	d.DispatchAnalyzer(cfg)
	d.DispatchJanitor(cfg)
}

func (d *Dispatcher) DispatchRecorder(cfg *ini.File) {
	recp := recorder.NewPacketRecorder(cfg, serviceManager)
	d.dispatch(recp)
}

func (d *Dispatcher) DispatchGuardian(cfg *ini.File) {
	guard := guardian.New(cfg, serviceManager)
	d.dispatch(guard)
}

func (d *Dispatcher) dispatch(module modules.LongRunner) {
	d.wg.Add(1)

	//register all dispatched modules
	d.dispatchedModules = append(d.dispatchedModules, module)
	//module.SetReloadChan(d.quitChan)
	go func() {
		defer utils.HandleErrors()
		defer d.wg.Done()
		module.Setup()
		module.Run()
		return
	}()

}
