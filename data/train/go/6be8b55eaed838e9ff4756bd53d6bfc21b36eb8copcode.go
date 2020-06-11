package common

import (
	"errors"
	"fmt"
)

// LineNo 行号
type LineNo uint16

// Ptr 操作码地址
type Ptr uint16

const ZeroPtr Ptr = 0

// Opcode 表示一个操作码
type Opcode interface {
	Load() error
	Exec(ctx Context) (Ptr, error)
}

type LoadFunc func(loader Loader, ptr Ptr, line LineNo, flag byte) Opcode

var loadFuncs = make(map[byte]LoadFunc, 0)

func RegisterOpcode(code byte, load LoadFunc) {
	if load == nil {
		panic(errors.New("Invalid parameter:load"))
	}
	if _, ok := loadFuncs[code]; ok {
		panic(fmt.Errorf("Dont duplicate defined Opcode with value:0x%X", code))
	}
	loadFuncs[code] = load
}

func NewOpcode(loader Loader, code byte, ptr Ptr, line LineNo, flag byte) (Opcode, error) {
	load, ok := loadFuncs[code]
	if !ok {
		return nil, fmt.Errorf("No defined Opcode with value:0x%X , ptr:%v", code, ptr)
	}
	op := load(loader, ptr, line, flag)

	return op, op.Load()
}
