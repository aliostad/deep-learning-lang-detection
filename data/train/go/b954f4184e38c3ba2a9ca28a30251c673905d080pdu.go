package cimd

import (
	"bufio"
	"bytes"
	"log"
	"net"
	"strings"
	"sync/atomic"
	"time"

	"github.com/jcaberio/go-cimd/util"
	"github.com/jcaberio/go-cimd/view"
	"github.com/pkg/errors"
	"github.com/spf13/viper"
	"golang.org/x/sync/syncmap"
)

var RemoteClients = syncmap.Map{}

type PDU struct {
	Conn   net.Conn
	CmdID  []byte
	SeqNum []byte
	Data   map[string]string
}

func NewPDU(c net.Conn) (*PDU, error) {
	reader := bufio.NewReader(c)
	raw, _ := reader.ReadSlice(ETX)
	if len(raw) == 0 {
		return nil, errors.New("Empty read on connection")
	}
	pduParts := bytes.Split(raw, []byte{TAB})[:]
	pduPartsETXOmitted := pduParts[:len(pduParts)-1]
	data := make(map[string]string)
	for _, pduPart := range pduPartsETXOmitted {
		paramClnVal := string(pduPart[:])
		paramValSlice := strings.Split(paramClnVal, ":")
		param := paramValSlice[0]
		val := paramValSlice[1]
		data[param] = val
	}
	rawHeader := pduPartsETXOmitted[0]
	header := bytes.TrimFunc(rawHeader, func(c rune) bool { return c == STX || c == ETX })
	cmdAndSeq := bytes.Split(header, []byte{COLON})
	cmdID := cmdAndSeq[0]
	seqNum := cmdAndSeq[1]

	return &PDU{
		CmdID:  cmdID,
		SeqNum: seqNum,
		Data:   data,
		Conn:   c,
	}, nil
}

func (p *PDU) Decode() {
	go func() {
		moMessage := <-util.MoMsgChan
		p.DeliverMessage(moMessage)
	}()
	switch string(p.CmdID[:]) {
	case LOGIN:
		log.Println("LOGIN COMMAND")
		p.LoginResp(p.Authenticate())

	case ALIVE:
		log.Println("ALIVE COMMAND")
		p.KeepAlive()
	case LOGOUT:
		log.Println("LOGOUT COMMAND")
		p.LogoutResp()

	case SUBMIT_MSG:
		log.Println("SUBMIT_MESSAGE COMMAND")
		p.SubmitMessageResp(p.SubmitMessage())
		arrivalTime := []byte(time.Now().Format("20060102150405"))
		go func(arrivalTime []byte) {
			const DELIVERY_SUCCESSFUL = "8"
			if p.Data[STATUS_REPORT_REQUEST] == DELIVERY_SUCCESSFUL {
				deliveryDelay := viper.GetInt("delivery_delay")
				time.Sleep(time.Duration(deliveryDelay) * time.Second)
				deliveryTime := []byte(time.Now().Format("20060102150405"))
				p.DeliverStatusReport(arrivalTime, deliveryTime)
				view.DRCountChan <- atomic.AddUint64(&util.DeliveryCount, 1)
			}

		}(arrivalTime)
	case DELIVER_STAT_REPORT_RESP:
		log.Println("DELIVER_STAT_REPORT_RESP COMMAND")
	case DELIVER_MESSAGE_RESP:
		log.Println("DELIVER_MESSAGE_RESP COMMAND")
	default:
		log.Println("UNKNOWN COMMAND")
		p.UnknownCmd()
	}
}

func (p *PDU) DeliverStatusReport(arrivalTime, deliveryTime []byte) {
	byteToWrite := make([]byte, 0)
	byteToWrite = append(byteToWrite, STX)
	byteToWrite = append(byteToWrite, DELIVER_STAT_REPORT_REQ...)
	byteToWrite = append(byteToWrite, COLON)
	byteToWrite = append(byteToWrite, util.NextSeqNum()...)
	byteToWrite = append(byteToWrite, TAB)
	byteToWrite = append(byteToWrite, DST_ADDR_RESP...)
	byteToWrite = append(byteToWrite, COLON)
	byteToWrite = append(byteToWrite, []byte(p.Data[DST_ADDR])...)
	byteToWrite = append(byteToWrite, TAB)
	byteToWrite = append(byteToWrite, SVC_CENTER_RESP...)
	byteToWrite = append(byteToWrite, COLON)
	byteToWrite = append(byteToWrite, arrivalTime...)
	byteToWrite = append(byteToWrite, TAB)
	byteToWrite = append(byteToWrite, STATUS_CODE...)
	byteToWrite = append(byteToWrite, COLON)
	byteToWrite = append(byteToWrite, []byte(SUCCESSFUL_DELIVERY)...)
	byteToWrite = append(byteToWrite, TAB)
	byteToWrite = append(byteToWrite, DISCHARGE_TIME...)
	byteToWrite = append(byteToWrite, COLON)
	byteToWrite = append(byteToWrite, deliveryTime...)
	byteToWrite = append(byteToWrite, TAB)
	byteToWrite = append(byteToWrite, ETX)
	p.Conn.Write(byteToWrite)
}

func (p *PDU) LoginResp(b bool) {
	if b {
		RemoteClients.Store(p.Conn.RemoteAddr().String(), true)
		byteToWrite := make([]byte, 0)
		byteToWrite = append(byteToWrite, STX)
		byteToWrite = append(byteToWrite, LOGIN_RESP...)
		byteToWrite = append(byteToWrite, COLON)
		byteToWrite = append(byteToWrite, p.SeqNum...)
		byteToWrite = append(byteToWrite, TAB)
		byteToWrite = append(byteToWrite, ETX)
		p.Conn.Write(byteToWrite)
		log.Println("VALID LOGIN")
	} else {
		RemoteClients.Store(p.Conn.RemoteAddr().String(), false)
		byteToWrite := make([]byte, 0)
		byteToWrite = append(byteToWrite, STX)
		byteToWrite = append(byteToWrite, GENERAL_ERROR_RESP...)
		byteToWrite = append(byteToWrite, COLON)
		byteToWrite = append(byteToWrite, p.SeqNum...)
		byteToWrite = append(byteToWrite, TAB)
		byteToWrite = append(byteToWrite, ERROR_CODE...)
		byteToWrite = append(byteToWrite, COLON)
		byteToWrite = append(byteToWrite, INVALID_LOGIN...)
		byteToWrite = append(byteToWrite, TAB)
		byteToWrite = append(byteToWrite, ETX)
		p.Conn.Write(byteToWrite)
		log.Println("INVALID LOGIN")
	}
}

func (p *PDU) LogoutResp() {
	RemoteClients.Store(p.Conn.RemoteAddr().String(), false)
	byteToWrite := make([]byte, 0)
	byteToWrite = append(byteToWrite, STX)
	byteToWrite = append(byteToWrite, LOGOUT_RESP...)
	byteToWrite = append(byteToWrite, COLON)
	byteToWrite = append(byteToWrite, p.SeqNum...)
	byteToWrite = append(byteToWrite, TAB)
	byteToWrite = append(byteToWrite, ETX)
	p.Conn.Write(byteToWrite)
}

func (p *PDU) Authenticate() bool {
	userIdentity := p.Data[USER_IDENTITY]
	password := p.Data[PASSWORD]
	ui := viper.GetString("cimd_user")
	pw := viper.GetString("cimd_pw")
	log.Println("username: ", ui)
	log.Println("password: ", pw)
	return userIdentity == ui && password == pw
}

func (p *PDU) KeepAlive() {
	byteToWrite := make([]byte, 0)
	byteToWrite = append(byteToWrite, STX)
	byteToWrite = append(byteToWrite, ALIVE_RESP...)
	byteToWrite = append(byteToWrite, COLON)
	byteToWrite = append(byteToWrite, p.SeqNum...)
	byteToWrite = append(byteToWrite, TAB)
	byteToWrite = append(byteToWrite, ETX)
	p.Conn.Write(byteToWrite)
}

func (p *PDU) SubmitMessage() bool {
	log.Println("DST_ADDR: ", p.Data[DST_ADDR])
	log.Println("ORIG_ADDR: ", p.Data[ORIG_ADDR])
	log.Println("USER_DATA: ", p.Data[USER_DATA])
	log.Println("USER_DATA_BINARY: ", p.Data[USER_DATA_BINARY])
	return p.Data[DST_ADDR] != "" && p.Data[ORIG_ADDR] != "" &&
		(p.Data[USER_DATA] != "" || p.Data[USER_DATA_BINARY] != "")

}

func (p *PDU) SubmitMessageResp(b bool) {
	if b && p.isLogin() {
		go func() {view.SMCountChan <- atomic.AddUint64(&util.SubmitCount, 1)}()
		arrivalTime := []byte(time.Now().Format("20060102150405"))
		byteToWrite := make([]byte, 0)
		byteToWrite = append(byteToWrite, STX)
		byteToWrite = append(byteToWrite, SUBMIT_MSG_RESP...)
		byteToWrite = append(byteToWrite, COLON)
		byteToWrite = append(byteToWrite, p.SeqNum...)
		byteToWrite = append(byteToWrite, TAB)
		byteToWrite = append(byteToWrite, DST_ADDR_RESP...)
		byteToWrite = append(byteToWrite, COLON)
		byteToWrite = append(byteToWrite, []byte(p.Data[DST_ADDR])...)
		byteToWrite = append(byteToWrite, TAB)
		byteToWrite = append(byteToWrite, SVC_CENTER_RESP...)
		byteToWrite = append(byteToWrite, COLON)
		byteToWrite = append(byteToWrite, arrivalTime...)
		byteToWrite = append(byteToWrite, TAB)
		byteToWrite = append(byteToWrite, ETX)
		p.Conn.Write(byteToWrite)
	}
}

func (p *PDU) UnknownCmd() {
	byteToWrite := make([]byte, 0)
	byteToWrite = append(byteToWrite, STX)
	byteToWrite = append(byteToWrite, GENERAL_ERROR_RESP...)
	byteToWrite = append(byteToWrite, COLON)
	byteToWrite = append(byteToWrite, p.SeqNum...)
	byteToWrite = append(byteToWrite, TAB)
	byteToWrite = append(byteToWrite, ERROR_CODE...)
	byteToWrite = append(byteToWrite, COLON)
	byteToWrite = append(byteToWrite, UNEXPECTED_OPERATION...)
	byteToWrite = append(byteToWrite, TAB)
	byteToWrite = append(byteToWrite, ETX)
	p.Conn.Write(byteToWrite)
}

func (p *PDU) DeliverMessage(message string) {
	arrivalTime := []byte(time.Now().Format("20060102150405"))
	byteToWrite := make([]byte, 0)
	byteToWrite = append(byteToWrite, STX)
	byteToWrite = append(byteToWrite, DELIVER_MESSAGE...)
	byteToWrite = append(byteToWrite, COLON)
	byteToWrite = append(byteToWrite, p.SeqNum...)
	byteToWrite = append(byteToWrite, TAB)
	byteToWrite = append(byteToWrite, DST_ADDR_RESP...)
	byteToWrite = append(byteToWrite, COLON)
	byteToWrite = append(byteToWrite, []byte("Receiver")...)
	byteToWrite = append(byteToWrite, TAB)
	byteToWrite = append(byteToWrite, ORIG_ADDR...)
	byteToWrite = append(byteToWrite, COLON)
	byteToWrite = append(byteToWrite, []byte("Sender")...)
	byteToWrite = append(byteToWrite, TAB)
	byteToWrite = append(byteToWrite, SVC_CENTER_RESP...)
	byteToWrite = append(byteToWrite, COLON)
	byteToWrite = append(byteToWrite, arrivalTime...)
	byteToWrite = append(byteToWrite, TAB)
	byteToWrite = append(byteToWrite, USER_DATA...)
	byteToWrite = append(byteToWrite, COLON)
	byteToWrite = append(byteToWrite, []byte(message)...)
	byteToWrite = append(byteToWrite, TAB)
	byteToWrite = append(byteToWrite, ETX)
	p.Conn.Write(byteToWrite)
}

func (p *PDU) isLogin() bool {
	login, _ := RemoteClients.Load(p.Conn.RemoteAddr().String())
	return login.(bool)
}
