package login

import (
	"cellnet"
	"db"
	"network"
	"proto/loginproto"
)

func init() {
	var queue cellnet.EventQueue
	cellnet.RegisterMessageToQueue(network.Peer, queue, "loginproto.CSToken", dispatchToken)
	cellnet.RegisterMessageToQueue(network.Peer, queue, "loginproto.CSLogin", dispatchLogin)
	cellnet.RegisterMessageToQueue(network.Peer, queue, "loginproto.CSRoleList", dispatchRoleList)
	cellnet.RegisterMessageToQueue(network.Peer, queue, "loginproto.CSLoginRole", dispatchLoginRole)
}

func dispatchToken(ev *cellner.Event) {

}

func dispatchLogin(ev *cellnet.Event) {
	msg := ev.Msg.(loginproto.CSLogin)
	id := msg.Id
	conn := db.Pool.Get()
	account := db.QuerryAccount(conn, id)
	if account == nil {
		return
	}
	if account.Pwd != msg.Pwd {
		return
	}

}

func dispatchRoleList(ev *cellnet.Event) {
}

func dispatchLoginRole(ev *cellnet.Event) {
}
