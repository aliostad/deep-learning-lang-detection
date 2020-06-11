package mail_server

import (
	"cfg"
	"helper"
	"mail"
	"maildb"
)

const (
	LOAD_QUEUE_SIZE = 1024
)

var (
	LoadCh   chan int64
	LoadOKCh chan *maildb.PackDbMail
)

func init() {
	LoadCh = make(chan int64, LOAD_QUEUE_SIZE)
	LoadOKCh = make(chan *maildb.PackDbMail, LOAD_QUEUE_SIZE)
}

func loadWorker() {
	defer func() {
		if err := recover(); err != nil {
			helper.BackTrace("load_worker")
		}
	}()
	for {
		select {
		case id, err := <-LoadCh:
			if !err {
				cfg.LogErr("Net close chan error:", err)
				break
			}
			loadUserMail(id)
		}
	}

}

func loadUserMail(userId int64) {
	msg := mail.LoadMail(userId)
	LoadOKCh <- msg
}
