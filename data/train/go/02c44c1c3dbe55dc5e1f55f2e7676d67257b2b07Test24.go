package main

import (
	"fmt"
	"reflect"
	"strings"
)

type EventMessage struct{}

type DispatchDownWorkspace struct {
	EventMessageQueue    chan *EventMessage
}

func (ddws *DispatchDownWorkspace) SendMessage(msg interface{}) (err error) {

	//拿到了消息的类型名
	str := reflect.TypeOf(msg).String()
	str = strings.Split(str,".")[len(strings.Split(str,"."))-1]

	//拿到了队列的接口
	mQueue := reflect.ValueOf(ddws).Elem().FieldByName(str+"Queue").Interface()

	select {
	//此处必须有强制类型装换
	case mQueue.(chan *EventMessage) <- msg.(*EventMessage):
	default:
		err = fmt.Errorf(str+"Queue is full")
	}

	return
}

func main() {
	//构建消息队列
	ddws := DispatchDownWorkspace{}
	ddws.EventMessageQueue = make(chan *EventMessage)
	//创建消息
	eMessage := EventMessage{}
	//发送消息
	ddws.SendMessage(&eMessage)
}