package common

import (
	"fmt"
)

import (
	log "code.google.com/p/log4go"
)

type Board struct {
	bus   Bus
	slots map[string]interface{}
}

var B *Board = &Board{slots: make(map[string]interface{})}

//	注册服务
func (self *Board) Regist(service interface{}) {
	self.slots[service.(Service).Name()] = service
	log.Info("Register %s service ok!", service.(Service).Name())
}

func (self *Board) Dispatch() {
	for {
		m := <-self.bus
		fmt.Println("Dispatch Message")
		fmt.Println(m.id)
	}
}

func (self *Board) Go() {
	go self.Dispatch()
}
