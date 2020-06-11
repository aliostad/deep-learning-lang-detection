package main

import (
	"fmt"
	"strings"
)

type Dispatch struct {
	master *Master
	slave  *Slave
}

func IsSyncCommand(c []byte) bool {
	for i, k := range c {
		if i%2 == 0 && k <= 'z' && k >= 'a' {
			continue
		}
		if i%2 == 1 && k <= 'Z' && k >= 'A' {
			continue
		}

		return false
	}

	return true
}

func SetSyncCommand(c []byte) {
	for i, k := range c {
		if i%2 == 1 && k <= 'z' && k >= 'a' {
			c[i] = c[i] - 0x20
			continue
		}
		if i%2 == 0 && k <= 'Z' && k >= 'A' {
			c[i] = c[i] + 0x20
			continue
		}
	}
}

func CanSendToSlave(b []byte) bool {
	cmd, ok := GetRedisCommand(b)
	if !ok {
		return false
	}

	fmt.Println("cmd is", string(cmd), len(cmd))

	/* 不同步PING */
	if strings.EqualFold(string(cmd), "PING") {
		return false
	}

	if IsSyncCommand(cmd) {
		return false
	}

	SetSyncCommand(cmd)
	return true
}

func (d *Dispatch) ReadPayload(b []byte, n int) error {
	fmt.Println("read payload:")
	fmt.Println(string(b[:n]))

	if !CanSendToSlave(b[:n]) {
		return nil
	}

	err := d.slave.Sync(b[:n])
	if err != nil {
		fmt.Println(err.Error())
	}

	return nil
}

func (d *Dispatch) GetStatus() (masterId string, offset int) {
	masterId = d.master.MasterId
	if d.master.BaseOffset == -1 {
		offset = d.master.offset
	} else {
		offset = d.master.BaseOffset + d.master.offset
	}

	return
}

func (d *Dispatch) SetMaster(host string, port uint16, masterId string, offset int) {
	if d.master == nil {
		d.master = new(Master)
	}

	if masterId == "" {
		d.master.MasterId = "?"
		d.master.BaseOffset = -1
	} else {
		d.master.MasterId = masterId
		d.master.BaseOffset = offset
	}
	d.master.Port = port
	d.master.Host = host

	d.master.Priv = d
	d.master.ReadCb = func(b []byte, n int, priv interface{}) error {
		d, ok := priv.(*Dispatch)
		if !ok {
			return nil
		}

		return d.ReadPayload(b, n)
	}
}

func (d *Dispatch) SetSlave(host string, port uint16) {
	if d.slave == nil {
		d.slave = new(Slave)
	}

	d.slave.Host = host
	d.slave.Port = port
}

func (d *Dispatch) Start() error {
	var err error

	err = d.slave.ConnSlave()
	if err != nil {
		fmt.Println(err.Error())
	}

	err = d.master.SlaveOf()
	if err != nil {
		fmt.Println(err.Error())
		return err
	}

	return nil
}

func (d *Dispatch) Stop() {
}

/*
func main() {
	var d Dispatch
	//d.SetMaster("127.0.0.1", 6001)
	//d.SetSlave("127.0.0.1", 6002)
	d.SetMaster("127.0.0.1", 6002)
	d.SetSlave("127.0.0.1", 6001)

	d.Start()

	time.Sleep(time.Second * 3000)
}
*/
