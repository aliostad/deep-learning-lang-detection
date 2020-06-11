package dispatcher

import (
	"testing"
)

type MClass struct {
	dispatcher Events
	t          *testing.T
}

func Test_tbs(t *testing.T) {
	mc := &MClass{t: t}
	mc.Start()
}

func (t *MClass) Start() {
	f := NewLine()
	dis0 := NewForkEvent(f)
	dis0.AddEvent("test", t.onTest)
	dis0.AddEvent("test", "test2")
	dis0.OnlyOnce("test", t.onTest4)
	dis0.AddEvent("test2", t.onTest2)

	dis0.AddEvent("test", t.onTest3)

	dis0.Dispatch("test", 10, "hehe1")
	dis0.Dispatch("test", "hehe2", 11)
	dis0.Dispatch("test", "hehe3", 11)

}

func (t *MClass) onTest(a string) {
	t.t.Log("onTest", a)
}

func (t *MClass) onTest2(a string, b int, c *uint) {
	t.t.Log("onTest2", a, b)
}

func (t *MClass) onTest3(a string, b int, c *uint) {
	t.t.Log("onTest3", a, b)
}

func (t *MClass) onTest4(a string) {
	t.t.Log("onTest4", a)
}
