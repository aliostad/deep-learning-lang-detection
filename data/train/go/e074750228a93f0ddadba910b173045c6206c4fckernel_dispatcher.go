package server

import (
	"fmt"
	"server/libs/log"
)

const (
	DP_BEAT        = 1
	DP_BEGINUPDATE = 1 << 1
	DP_UPDATE      = 1 << 2
	DP_LASTUPDATE  = 1 << 3
	DP_FRAME       = 1 << 4
	DP_FLUSH       = 1 << 5
	DP_ALL         = DP_BEAT | DP_BEGINUPDATE | DP_UPDATE | DP_LASTUPDATE | DP_FRAME | DP_FLUSH
)

var (
	alltypes = []int{DP_BEAT, DP_BEGINUPDATE, DP_UPDATE, DP_LASTUPDATE, DP_FRAME, DP_FLUSH}
)

type Dispatcher interface {
	OnBeatRun()
	OnBeginUpdate()
	OnUpdate()
	OnLastUpdate()
	OnFrame()
	OnFlush()
	SetDispatchID(string)
	GetDispatchID() string
}

type DispatchSlot struct {
	Dispatchs map[string]Dispatcher
}

func NewDispatchSlot() *DispatchSlot {
	ds := &DispatchSlot{}
	ds.Dispatchs = make(map[string]Dispatcher)
	return ds
}

func (ds *DispatchSlot) Len() int {
	return len(ds.Dispatchs)
}

func (ds *DispatchSlot) Add(name string, d Dispatcher) bool {
	if _, dup := ds.Dispatchs[name]; dup {
		return false
	}
	ds.Dispatchs[name] = d
	return true
}

func (ds *DispatchSlot) Remove(name string) {
	delete(ds.Dispatchs, name)
}

//调度组件
type Dispatch struct {
	name string
}

func (d *Dispatch) OnBeatRun() {
}

func (d *Dispatch) OnBeginUpdate() {
}

func (d *Dispatch) OnUpdate() {
}

func (d *Dispatch) OnLastUpdate() {
}

func (d *Dispatch) OnFrame() {
}

func (d *Dispatch) OnFlush() {
}

func (d *Dispatch) SetDispatchID(n string) {
	d.name = n
}

func (d *Dispatch) GetDispatchID() string {
	return d.name
}

//挂载组件
func (kernel *Kernel) AddDispatch(name string, d Dispatcher, dtyp int) bool {
	for _, t := range alltypes {
		if dtyp&t != 0 {
			ds := kernel.dispatcherList[t]
			if ds == nil {
				ds = NewDispatchSlot()
				kernel.dispatcherList[t] = ds
			}
			d.SetDispatchID(name)
			if ds.Add(name, d) {
				log.LogMessage("add dispatch:", name, " type:", t)
			} else {
				log.LogError("add dispatch ", name, " type:", t, " failed")
			}
		}
	}
	return true
}

func (kernel *Kernel) AddDispatchNoName(d Dispatcher, dtyp int) bool {
	kernel.dispatchserial++
	return kernel.AddDispatch(fmt.Sprintf("dispatch%d", kernel.dispatchserial), d, dtyp)
}

func (kernel *Kernel) RemoveDispatch(name string) {
	for t, ds := range kernel.dispatcherList {
		if ds != nil {
			ds.Remove(name)
			log.LogMessage("remove dispatch:", name, " type:", t)
		}
	}
}
