package goemail

import (
	"strconv"
	"sync"
	"time"
)

var (
	dispatch_mux *sync.Mutex = new(sync.Mutex) // 调度锁
	pools        []*Pool     = nil             // 调度池
	poolIdx      int         = 0               // 调度顺序
)

// StartService start email service
func StartService() error {
	dispatch_mux.Lock()
	defer dispatch_mux.Unlock()
	if pools == nil || len(pools) == 0 {
		return ERR_POOL
	}
	for _, p := range pools {
		if p != nil {
			p.Start()
		}
	}
	return nil
}

// StopService stop email service
func StopService() error {
	dispatch_mux.Lock()
	defer dispatch_mux.Unlock()
	if pools == nil || len(pools) == 0 {
		return ERR_POOL
	}
	for _, p := range pools {
		if p != nil {
			p.Stop()
		}
	}
	pools = nil
	return nil
}

func dispatchPool() (*Pool, error) {
	dispatch_mux.Lock()
	defer dispatch_mux.Unlock()
	if pools == nil || len(pools) == 0 {
		return nil, ERR_POOL
	} else if poolIdx >= len(pools) {
		poolIdx = 0
	}
	if p := pools[poolIdx]; p != nil {
		if p.IsFull() {
			return nil, ERR_FULL_POOL
		}
		poolIdx++
		return p, nil
	}
	return nil, ERR_POOL
}

// SendEmail send a email e
func SendEmail(e *Email) error {
	if e == nil || !e.Valid() {
		return ERR_EMAIL
	} else if e.TryCount >= 5 {
		return ERR_EMAIL_TOO_MUCH
	} else if p, err := dispatchPool(); err != nil {
		return err
	} else if err := p.Send(e.
		AddTag(strconv.Itoa(poolIdx)).
		SetFrom(p.config.User, p.config.Name).
		Increase()); err != nil {
		return SendEmail(e)
	}
	return nil
}

// SendEmailDelay send a email delay one second
func SendEmailDelay(e *Email) {
	go func() {
		time.Sleep(time.Second)
		SendEmail(e)
	}()
}
