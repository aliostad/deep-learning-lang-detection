// Unit tests for process package
package process

import (
	"log"
	"testing"
)

// ProcessState listener implementation
type ProcessStateListenerImpl struct {
	monitor chan bool
}

// Callback when process is completed
func (processStateListenerImpl *ProcessStateListenerImpl) OnComplete(processMonitor *ProcessMonitor) {
	log.Println("on complete")
	log.Println("output is\n", string(*processMonitor.Output))
	processStateListenerImpl.monitor <- true
}

// Callback when process encounters error
func (processStateListenerImpl *ProcessStateListenerImpl) OnError(processMonitor *ProcessMonitor, err error) {
	log.Panic("Error encountered", err)
	processStateListenerImpl.monitor <- true
}

// Test case for fork
func TestFork(t *testing.T) {
	processStateListenerImpl := &ProcessStateListenerImpl{make(chan bool)}
	Fork(processStateListenerImpl,"ls", "-a") //("ping","192.168.3.141","-c","3")
	// waiting onto monitor
	<-processStateListenerImpl.monitor
}