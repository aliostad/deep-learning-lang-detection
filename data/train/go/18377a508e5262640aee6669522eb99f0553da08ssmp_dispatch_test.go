package common

import (
	"testing"
	"time"
	//"bytes"
	"log"
)

var ticker *time.Ticker = time.NewTicker(10 * time.Millisecond)

func TestSsmpDispatchClnt(t *testing.T) {
	log.SetFlags(log.Ldate | log.Lmicroseconds)

	var dispMng DispatchMng
	ssmpDisp := NewSsmpDispatch("Ssmp Client", SSMP_DISP_CLNT)

	dispMng.Add(ssmpDisp)
	dispMng.Start()

	// Input a short packet which is not a valid SSMP packet
	dispMng.Handle(sample1)

	WaitforCondition(
		func() bool { return ssmpDisp.DispatchCnt == DispatchCnt{1, 0, 1, 0} },
		func() {
			t.Errorf("SSMP Dispatch failed to bypass a non-SSMP packet, %s", ssmpDisp.DispatchCnt)
		},
		10,
	)

	// Input a SSMP hello packet
	dispMng.Handle(ssmp1)

	WaitforCondition(
		func() bool { return ssmpDisp.DispatchCnt == DispatchCnt{2, 0, 1, 1} },
		func() {
			t.Errorf("SSMP Dispatch failed to discard a unknown SSMP packet, %s", ssmpDisp.DispatchCnt)
		},
		10,
	)

	// Register a FSM channel and input a SSMP hello packet
	chanInput := make(chan []byte)
	ssmpDisp.Register(0x11223344aabbccdd, chanInput)

	dispMng.Handle(ssmp1)

	WaitforBufChannel(
		chanInput,
		func(buf []byte) {
			if len(buf) != 64 {
				t.Errorf("SSMP Dispatch distributed a error packet, len %v", len(buf))
			}
		},
		func() {
			t.Errorf("SSMP Dispatch: didn't get the packet")
		},
		10,
	)

	// Unregister a FSM channel and input a SSMP hello packet
	ssmpDisp.Unregister(0x11223344aabbccdd)

	dispMng.Handle(ssmp1)

	WaitforCondition(
		func() bool { return ssmpDisp.DispatchCnt == DispatchCnt{4, 1, 1, 2} },
		func() {
			t.Errorf("SSMP Dispatch failed to discard a SSMP packet, %s", ssmpDisp.DispatchCnt)
		},
		10,
	)

	// Register a FSM channel and input a SSMP reply packet
	ssmpDisp.Register(0x1a002b003c00, chanInput)
	dispMng.Handle(ssmp2)

	WaitforBufChannel(
		chanInput,
		func(buf []byte) {
			if len(buf) != 68 {
				t.Errorf("SSMP Dispatch distributed a error packet, len %v", len(buf))
			}
		},
		func() {
			t.Errorf("SSMP Dispatch: didn't get the packet")
		},
		10,
	)

	// Reset the dispatch and input a SSMP packet
	ssmpDisp.Reset()
	dispMng.Handle(ssmp2)

	WaitforCondition(
		func() bool { return ssmpDisp.DispatchCnt == DispatchCnt{6, 2, 1, 3} },
		func() {
			t.Errorf("SSMP Dispatch failed to discard a SSMP packet, %s", ssmpDisp.DispatchCnt)
		},
		10,
	)

}

func WaitforCondition(cond func() bool, timeoutHnl func(), timeout int) {
	for i := 0; i < timeout; i++ {
		select {
		case <-ticker.C:
			if cond() {
				return
			}
		}
	}

	timeoutHnl()
}

func WaitforBufChannel(bufchan chan []byte, action func(buf []byte), timeoutHnl func(), timeout int) {
	for i := 0; i < timeout; {
		select {
		case <-ticker.C:
			i++
		case buf := <-bufchan:
			action(buf)
			return
		}
	}

	timeoutHnl()
}
