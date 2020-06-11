package prize_center

import (
	"cfg"
	"helper"
)

const (
	LOAD_QUEUE_SIZE = 32767
)

var (
	_loadCh   chan LoadReq
	_loadOKCh chan LoadRsp
)

type LoadReq struct {
	Api    int16
	Box    int8
	UserId int64
	Args   interface{}
}

type LoadRsp struct {
	Api  int16
	Box  int8
	User *UserPrize
	Args interface{}
}

func init() {
	_loadCh = make(chan LoadReq, LOAD_QUEUE_SIZE)
	_loadOKCh = make(chan LoadRsp, LOAD_QUEUE_SIZE)
}

func loadWorker() {
	loadInit()
	for retry := 0; retry < MAXN_RETRY_TIMES; {
		err := loadLoop()
		if err == nil {
			break
		}
		retry++
		cfg.LogErrf("Recovered:", err)
		cfg.LogWarnf("Restart load worker...retry=%d.", retry)

	}
	cfg.LogWarnf("Worker quit...")
}

func loadInit() {
}

func loadLoop() (err interface{}) {
	defer func() {
		if err = recover(); err != nil {
			helper.BackTrace("worker")
			cfg.LogErrf("Catch panic err %v", err)
		}
	}()
	for {
		select {
		case msg, err := <-_loadCh:
			if !err {
				cfg.LogErr("LoadCh close chan error:", err)
				break
			}
			loadUserPrize(msg.Api, msg.Box, msg.UserId, msg.Args)
		}
	}

}

func loadUserReq(api int16, box int8, userId int64, args interface{}) {
	if len(_loadCh) >= LOAD_QUEUE_SIZE {
		cfg.LogWarnf("drop load req %v user", userId)
		return
	}
	_loadCh <- LoadReq{api, box, userId, args}

}

func loadUserPrize(api int16, box int8, userId int64, args interface{}) {
	userPrize, _ := FindUserPrize(userId)
	_loadOKCh <- LoadRsp{api, box, &UserPrize{userId, userPrize}, args}
}
