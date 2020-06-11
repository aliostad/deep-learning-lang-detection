package common

import (
	"bytes"
	"fmt"
    //"log"
    "github.com/frameyl/log4go"
)

type SsmpDispatch struct {
	// Name of dispatch
	name string
	// Mode of Dispatch
	mode int
	// Channel of packet buffer
	bufChan chan []byte
	// Channel of control message
	cntlChan chan int
	// Channel of register
	regChan chan SsmpDispatchReg
	// Map from Magic Number to FSM input channel
	mapFsm map[uint64]chan []byte
	// Listener for server only
	listener *SsmpListener
	// Counters
	DispatchCnt
}

type SsmpDispatchReg struct {
	Magic   uint64
	BufChan chan []byte
}

const SSMP_DISP_CLOSE = 0
const SSMP_DISP_RESET = 1

const (
	SSMP_DISP_SVR = iota
	SSMP_DISP_CLNT
)

func NewSsmpDispatch(dispName string, mode int) *SsmpDispatch {
	disp := &SsmpDispatch{
		name:        dispName,
		mode:        mode,
		bufChan:     make(chan []byte, 100),
		cntlChan:    make(chan int, 10),
		regChan:     make(chan SsmpDispatchReg, 100),
		mapFsm:      make(map[uint64]chan []byte),
		DispatchCnt: DispatchCnt{}}

	return disp
}

func (disp SsmpDispatch) Name() string {
	return disp.name
}

func (disp SsmpDispatch) GetBufChan() chan []byte {
	return disp.bufChan
}

func (disp SsmpDispatch) Close() error {
	disp.cntlChan <- SSMP_DISP_CLOSE
	return nil
}

func (disp SsmpDispatch) Reset() error {
	disp.cntlChan <- SSMP_DISP_RESET
	return nil
}

func (disp SsmpDispatch) Register(magic uint64, bufChan chan []byte) error {
	disp.regChan <- SsmpDispatchReg{magic, bufChan}
	return nil
}

func (disp SsmpDispatch) Unregister(magic uint64) error {
	disp.regChan <- SsmpDispatchReg{magic, nil}
	return nil
}

func (disp *SsmpDispatch) SetListener(listener *SsmpListener) {
	disp.listener = listener
}

func (disp SsmpDispatch) GetCnt() DispatchCnt {
	return disp.DispatchCnt
}

func (disp *SsmpDispatch) Handle(nextStep chan []byte) (err error) {
	for {
		select {
		case packet := <-disp.bufChan:
			disp.Rx++
			// Not a SSMP packet
			pkt := bytes.NewReader(packet)
			if isSsmpPkt, _ := IsSsmpPacket(pkt); !isSsmpPkt {
				if nextStep != nil {
					nextStep <- packet
				}
				disp.Bypass++
				continue
			}

			// With a unknow message name
			if msgType, _ := ReadMsgType(pkt); msgType == MSG_UNKNOWN {
				disp.Discard++
				continue
			}

			// Dispatch packet according to the magic number
			magic, _ := ReadMagicNum(pkt)

			fsmChan, ok := disp.mapFsm[magic]
			if ok {
				fsmChan <- packet
				disp.Handled++
				continue
			} else {
				// Handle it as an incoming session if I'm a server
				// Discard if I'm a client
				if disp.mode == SSMP_DISP_CLNT {
					disp.Discard++
					continue
				} else if disp.mode == SSMP_DISP_SVR {
                    if disp.listener == nil {
                        log4go.Critical("%s: Listener is not initialized", disp.name)
                        disp.Discard++
                        continue
                    }
                    
					disp.listener.ListenerChan <- packet
					disp.Handled++
					continue
				}
			}

		case cmd := <-disp.cntlChan:
			// Command 0 means terminate the routine
			if cmd == SSMP_DISP_CLOSE {
				close(disp.bufChan)
				close(disp.cntlChan)
				close(disp.regChan)
				return nil
			} else if cmd == SSMP_DISP_RESET {
				disp.mapFsm = make(map[uint64]chan []byte)
				log4go.Trace("Reset Dispatch %s", disp.name)
			}

		case reg := <-disp.regChan:
			if reg.BufChan != nil {
				if _, ok := disp.mapFsm[reg.Magic]; ok {
					log4go.Error("Try to register a MagicNum already existed %v\n", reg.Magic)
					continue
				}
				disp.mapFsm[reg.Magic] = reg.BufChan
				log4go.Trace("%s: Register a MagicNum %X\n", disp.name, reg.Magic)
			} else {
				if _, ok := disp.mapFsm[reg.Magic]; !ok {
					log4go.Error("Try to unregister a MagicNum not existed %v\n", reg.Magic)
					continue
				}
				delete(disp.mapFsm, reg.Magic)
				log4go.Trace("%s: Unregister a MagicNum %X\n", disp.name, reg.Magic)
			}
		}
	}

	return nil
}

func (disp SsmpDispatch) DumpCounters() string {
    return fmt.Sprintf("%s: Rx %d, Handled %d, Bypass %d, Discard %d", disp.name, disp.Rx, disp.Handled, disp.Bypass, disp.Discard)
}
