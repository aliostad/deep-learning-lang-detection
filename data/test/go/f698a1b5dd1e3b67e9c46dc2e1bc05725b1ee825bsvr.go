package bsvr

import (
	"net/http"

	"github.com/simplejia/clog"
	"github.com/simplejia/connsvr/comm"
	"github.com/simplejia/connsvr/core"
	"github.com/simplejia/connsvr/proto"
)

func Bserver(host string) {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		msg := proto.NewMsg(comm.SVR)
		ok := msg.Decode(nil, nil, r)
		if !ok {
			w.Write([]byte(`{"code": -1}`))
			return
		}

		clog.Debug("Bserver() msg.Decode %+v", msg)
		dispatchCmd(msg)
		w.Write([]byte(`{"code": 0}`))
	})

	clog.Error("Bserver() err: %v", http.ListenAndServe(host, nil))
}

func dispatchCmd(msg proto.Msg) {
	switch msg.Cmd() {
	case comm.PUSH:
		core.RM.Push(msg)
	default:
		clog.Error("bsvr:dispatchCmd() unexpected cmd: %v", msg.Cmd())
	}
}
