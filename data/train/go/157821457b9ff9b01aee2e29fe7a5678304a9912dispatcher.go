package dispatcher

import (
	"connect-server/model"
	core "connect-server/protocol"
	"encoding/binary"
	"fmt"
	"net"
	"strconv"
	"td-server/protocol"
	"time"
)

type Dispatcher struct {
	IP             string
	Port           int
	DispacthListen net.Listener
	Tokens         *model.Tokens
	Relations      *model.Relations
}

func NewDispatcher(IP string, Port int, tokens *model.Tokens, relations *model.Relations) *Dispatcher {
	return &Dispatcher{IP: IP, Port: Port, Tokens: tokens, Relations: relations}
}

func (this *Dispatcher) Start() {
	var err error
	this.DispacthListen, err = net.Listen("tcp", this.IP+":"+strconv.Itoa(this.Port))
	if err != nil {
		fmt.Println("dispatcher listen error")
		return
	}
	for {
		Conn, err := this.DispacthListen.Accept()
		if err != nil {
			continue
		}
		lengthBuff := make([]byte, 8)
		n, err := Conn.Read(lengthBuff)
		if n == 0 || err != nil {
			fmt.Println("dispatcher read error")
			CloseConn(&Conn)
			continue
		}
		length := binary.BigEndian.Uint64(lengthBuff)
		if length > 100 {
			CloseConn(&Conn)
			continue
		}

		requestBuff := make([]byte, length-8)
		n, err = Conn.Read(requestBuff)
		if n == 0 || err != nil {
			CloseConn(&Conn)
			continue
		}

		buffer := make([]byte, 0)
		buffer = append(buffer, lengthBuff...)
		buffer = append(buffer, requestBuff...)
		dispatchMsgRequest := &protocol.DispatchMsgRequest{}
		err = dispatchMsgRequest.Decode(buffer)
		if err != nil {
			err = fmt.Errorf("Dispacther Start Error: %v", err)
			fmt.Println(err.Error())
			CloseConn(&Conn)
			continue
		}
		if dispatchMsgRequest.Number != protocol.USER_REQ_SEND {
			fmt.Println("Not the right number")
			CloseConn(&Conn)
			continue
		}
		status := 0
		var tokener *model.Tokener
		var relation *model.Relation
		var related *model.RelatedV
		var uuid string
		if tokener, err = this.Tokens.Query(dispatchMsgRequest.FromUuid, dispatchMsgRequest.DestUuid); tokener != nil && err == nil && tokener.TimeOut-time.Now().Unix() > 0 {
			//主动方
			fmt.Println("主动方")
			if tokener.FromToken == dispatchMsgRequest.Token {
				status = 1
				uuid = dispatchMsgRequest.FromUuid + dispatchMsgRequest.DestUuid
			} else {
				//token验证失败
				fmt.Println("token验证失败")
				TokenErr(&Conn)
				CloseConn(&Conn)
				continue
			}
		} else if tokener, err = this.Tokens.Query(dispatchMsgRequest.DestUuid, dispatchMsgRequest.FromUuid); tokener != nil && err == nil && tokener.TimeOut-time.Now().Unix() > 0 {
			fmt.Println("被动方")
			if tokener.DestToken == dispatchMsgRequest.Token {
				status = 2
				uuid = dispatchMsgRequest.DestUuid + dispatchMsgRequest.FromUuid
			} else {
				//token验证失败
				fmt.Println("token验证失败")
				TokenErr(&Conn)
				CloseConn(&Conn)
				continue
			}
		} else {
			//没有token 或 已经超时
			fmt.Println("没有token或token已超时")
			TokenErr(&Conn)
			CloseConn(&Conn)
			continue
		}

		switch status {
		//主动方
		case 1:
			related = &model.RelatedV{FromUuid: dispatchMsgRequest.FromUuid, DestUuid: dispatchMsgRequest.DestUuid}
			this.Relations.AddFrom(dispatchMsgRequest.FromUuid, dispatchMsgRequest.DestUuid, dispatchMsgRequest.Token, &Conn)
		//被动方
		case 2:
			related = &model.RelatedV{FromUuid: dispatchMsgRequest.DestUuid, DestUuid: dispatchMsgRequest.FromUuid}
			this.Relations.AddDest(dispatchMsgRequest.FromUuid, dispatchMsgRequest.DestUuid, dispatchMsgRequest.Token, &Conn)
		}

		if r, err := this.Relations.Query(uuid); r != nil && err == nil {
			if r.FromConn != nil && r.DestConn != nil {
				go func() {
					id := uuid
					if relation, err = this.Relations.Query(uuid); relation != nil && err == nil && relation.Status == 0 {
						if relation.FromConn != nil && relation.DestConn != nil {
							relation.Status = 0
							TokenOk(relation.FromConn)
							TokenOk(relation.DestConn)

							if relation.Status == 0 {
								err := this.Relations.UpdateStatus(id, 1)
								if err != nil {
									err = fmt.Errorf("dispatcher Start Error: %v", err)
									fmt.Println(err.Error())
									return
								}
								ch := make(chan *model.RelatedV, 0)
								go DispatchWithTcp(relation.FromConn, relation.DestConn, ch, related, 30)
								go this.Handle(ch)
							}
						}
					}
				}()
			}
		}
	}
}

func (this *Dispatcher) Handle(ch chan *model.RelatedV) {
	var err error
	related := <-ch

	err = this.Tokens.Delete(related.FromUuid, related.DestUuid)
	if err != nil {
		err = fmt.Errorf("dispatcher Handler Error", err)
		fmt.Println(err.Error())
		return
	}
	if relation, err := this.Relations.Query(related.FromUuid + related.DestUuid); relation != nil && err == nil {
		(*relation.FromConn).Close()
		(*relation.DestConn).Close()
	}
	err = this.Relations.Delete(related.FromUuid + related.DestUuid)
	if err != nil {
		err = fmt.Errorf("dispatcher Handler Error", err)
		fmt.Println(err.Error())
		return
	}
}
func TokenOk(Conn *net.Conn) {
	response := &protocol.DispatchMsgResponse{protocol.TsHead{Len: 13, Version: 1, Type: core.CTRL, Number: protocol.USER_RES_SEND_STATUS}, 1}
	responseBuff, err := response.Encode()
	if err != nil {
		return
	}
	n, err := (*Conn).Write(responseBuff)
	if n == 0 || err != nil {
		return
	}
}

func TokenErr(Conn *net.Conn) {
	response := &protocol.DispatchMsgResponse{protocol.TsHead{Len: 13, Version: 1, Type: core.CTRL, Number: protocol.USER_RES_SEND_STATUS}, 0}
	responseBuff, err := response.Encode()
	if err != nil {
		return
	}
	n, err := (*Conn).Write(responseBuff)
	if n == 0 || err != nil {
		return
	}
	CloseConn(Conn)
}

func CloseConn(Conn *net.Conn) {
	(*Conn).Close()
}
