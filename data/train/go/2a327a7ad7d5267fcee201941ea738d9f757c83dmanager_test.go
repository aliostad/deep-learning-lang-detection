package manager

import (
	"fmt"
	"testing"
	"time"
)

func TestGetLabels(t *testing.T) {
	t.SkipNow()
	manager := &Manager{}
	containerID := "6d59e0d9"
	labels, err := manager.GetLabels(containerID)
	if err != nil {
		t.Error(err)
	}
	fmt.Printf("the labels %+v\n: ", labels)

}

func TestGetContainerAllInfo(t *testing.T) {
	t.SkipNow()
	manager := &Manager{}
	containerID := "6b0fbdab7231c659f16160e6cfd5403ff57bc5633f29805194b089e0593d8f1c"
	containerInfo, err := manager.GetContainerAllInfo(containerID, 1)
	if err != nil {
		t.Error(err)
	}
	fmt.Printf("container info: %+v \n", containerInfo)
	time.Sleep(time.Second * 10)
	containerInfo, err = manager.GetContainerAllInfo(containerID, 1)
	if err != nil {
		t.Error(err)
	}
	fmt.Printf("container info after interval second: %+v ", containerInfo)

}

func TestInitialContainer(t *testing.T) {
	t.SkipNow()
	manager := &Manager{}
	err := manager.InitialContainer()
	if err != nil {
		t.Error(err)
	}
	fmt.Printf("the initial value: %+v\n", ContainerCurrnetDetail)
}

func TestParseEventInfo(t *testing.T) {
	t.SkipNow()
	//start to monitor the events
	manager := &Manager{}
	manager.ParseEventInfo()
}

func TestStart(t *testing.T) {
	manager := &Manager{Interval: 3}
	manager.Start()

}
