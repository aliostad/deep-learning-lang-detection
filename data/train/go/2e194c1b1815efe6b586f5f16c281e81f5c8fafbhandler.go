package internal

import (
	"fmt"
	"reflect"

	"bearserver/msg"

	"github.com/name5566/leaf/gate"
)

func init() {
	handler(&msg.Dispatch{}, handleDispatch) //处理dispatch
}

func handler(m interface{}, h interface{}) {
	skeleton.RegisterChanRPC(reflect.TypeOf(m), h)
}

func handleDispatch(args []interface{}) {
	m := args[0].(*msg.Dispatch)
	a := args[1].(gate.Agent)
	method := m.Cmd

	before()
	var response *msg.Response
	switch method {
	case "hello":
		response = handleHello(args)
	case "playCard":
		response = (&PlayerModuel{}).HandlePlayCard(args)

	case "pushMsg":
		//response = handlePushMsg(args)

	default:
		response.Cmd = method
		fmt.Println("api method not found")
	}

	after()
	a.WriteMsg(response)
}

func before() {

}

func after() {

}
