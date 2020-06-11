package core

import (
	"github.com/wujunwei/vcloud/entity/resource/instance"

	"log"
)

type broker struct {
	vmList        []*instance.Vm
	containerList []*instance.Container
	vmAck         int
	containerAck  int
}

func NewBroker(
	vmList []*instance.Vm,
	containerList []*instance.Container,
	vmAck int,
	containerAck int,
) *broker{
	return &broker{
		vmList,
		containerList,
		vmAck,
		containerAck,
	}
}

func (broker *broker) Start(
	vmReq chan instance.Vm, vmResp chan bool,
	containerReq chan instance.Container, containerResp chan bool, done chan bool) {

	//submit requests that launch vm
	wait := broker.allocateVms(vmReq, vmResp)
	<-wait

	//submit requests that launch container
	wait = broker.allocateContainers(containerReq, containerResp)
	<-wait

	done <- true
	log.Print("broker.next")
}

func (broker *broker) allocateVms(vmReq chan instance.Vm, vmResp chan bool) chan bool {
	wait := make(chan bool)

	go func() {
		go broker.submitVms(vmReq)

		for {
			select {
			case <-vmResp:
				broker.vmAck--
				if broker.vmAck == 0 {
					wait <- true
					return
				}
			}
		}
	}()

	return wait
}

func (broker *broker) submitVms(vmReq chan instance.Vm) {
	for _, vm := range broker.vmList {
		vmReq <- *vm
		log.Printf("broker.vm.sending:%d", vm.GetId())
	}
	close(vmReq)
}

func (broker *broker) allocateContainers(containerReq chan instance.Container, containerResp chan bool) chan bool {
	wait := make(chan bool)

	go func() {
		go broker.submitContainers(containerReq)

		for {
			select {
			case <-containerResp:
				broker.containerAck--
				if broker.containerAck == 0 {
					wait <- true
					return
				}
			}
		}
	}()

	return wait
}

func (broker *broker) submitContainers(containerReq chan instance.Container) {
	for _, container := range broker.containerList {
		containerReq <- *container
		log.Printf("broker.container.sending:%d", container.GetId())
	}
	close(containerReq)
}

func (broker *broker) GetContainers() []*instance.Container {
	return broker.containerList
}

func (broker *broker) GetVms() []*instance.Vm {
	return broker.vmList
}

