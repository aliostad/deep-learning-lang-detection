// ssmp_session_group.go
package common

import (
    //"fmt"
    //"log"
    "github.com/frameyl/log4go"
)

type SessionGroupClient struct {
	sessions  []*SessionClient
	dispatch  *SsmpDispatch
	magicChan chan MagicReg
	SessionGroupClientCounter
}

type SessionGroupClientCounter struct {
	Idle int
	Connecting int
	Disconnecting int
	Established int
    SessionCnt
    SessionClientCnt
}

func NewSessionGroupClient(startid int, size int, dispatch *SsmpDispatch, outputChan chan []byte) *SessionGroupClient {
	sg := &SessionGroupClient{
		sessions:  make([]*SessionClient, size),
		dispatch:  dispatch,
		magicChan: make(chan MagicReg, size/50),
	}

	for i, _ := range sg.sessions {
		sg.sessions[i] = NewClientSession(startid+i, outputChan, sg.magicChan)
		go sg.sessions[i].RunClient()
	}

	go sg.Register()

	return sg
}

func (sg *SessionGroupClient) Start() {
	for _, s := range sg.sessions {
		s.CntlChan <- S_CMD_START
	}

	return
}

func (sg *SessionGroupClient) Stop() {
	for _, s := range sg.sessions {
		s.CntlChan <- S_CMD_STOP
	}

	return
}

func (sg *SessionGroupClient) Register() {
	for {
		reg := <-sg.magicChan
		if reg.BufChan == nil {
			sg.dispatch.Unregister(reg.Magic)
		} else {
			sg.dispatch.Register(reg.Magic, reg.BufChan)
		}
	}
}

func (sg *SessionGroupClient) Stats() {
	sg.SessionGroupClientCounter = SessionGroupClientCounter{}
	
	for _, s := range sg.sessions {
		if s.Current() == "idle" {
			sg.Idle++
		} else if s.Current() == "est" {
			sg.Established++
		} else if s.Current() == "close" {
			sg.Disconnecting++
		} else {
			sg.Connecting++
		}
        
        sg.Tx += s.Tx
        sg.TxHello += s.TxHello
        sg.TxRequest += s.TxRequest
        sg.TxConfirm += s.TxConfirm
        sg.TxDisc += s.TxDisc
        sg.Rx += s.Rx
        sg.RxHello += s.RxHello
        sg.RxReply += s.RxReply
        sg.RxDisc += s.RxDisc
        sg.Retry += s.Retry
	}
}

func (sg *SessionGroupClient) Dump() {
	sg.Stats()
	
	log4go.Info("Session Group Counter: Idle %d, Connecting %d, Disconecting %d, Established %d",
		sg.Idle, sg.Connecting, sg.Disconnecting, sg.Established)
    log4go.Info("Session Group Packet Counter: Tx %d, Rx %d, Retry %d, TxHello %d, RxHello %d, TxRequest %d, TxConfirm %d, RxReply %d",
        sg.Tx, sg.Rx, sg.Retry, sg.TxHello, sg.RxHello, sg.TxRequest, sg.TxConfirm, sg.RxReply)
}

func (sg *SessionGroupClient) DumpAll() {
	for _, s := range sg.sessions {
		log4go.Info("Session %d: Sid %d, state %s", s.Id, s.Sid, s.Current())
	}
}

type SessionGroupServer struct {
	sessions []*SessionServer
	dispatch *SsmpDispatch
}

func NewSessionGroupServer(startid int, size int, svrid string, dispatch *SsmpDispatch, outputChan chan []byte) *SessionGroupServer {
	sg := &SessionGroupServer{
		sessions: make([]*SessionServer, size),
		dispatch: dispatch,
	}

	for i, _ := range sg.sessions {
		sg.sessions[i] = NewServerSession(startid+i, uint32(startid+i), svrid, 0, outputChan)
	}

	return sg
}
