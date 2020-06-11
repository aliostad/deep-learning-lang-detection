package main

import (
	_ "sdaccel"

	aximemory "axi/memory"
	axiprotocol "axi/protocol"

	"github.com/tomokane/add"
)

func Top(
	a uint32,
	b uint32,
	addr uintptr,

	memReadAddr chan<- axiprotocol.Addr,
	memReadData <-chan axiprotocol.ReadData,

	memWriteAddr chan<- axiprotocol.Addr,
	memWriteData chan<- axiprotocol.WriteData,
	memWriteResp <-chan axiprotocol.WriteResp) {

	go axiprotocol.ReadDisable(memReadAddr, memReadData)

	val := add.Add(a, b)

	aximemory.WriteUInt32(
		memWriteAddr, memWriteData, memWriteResp, false, addr, val)
}
