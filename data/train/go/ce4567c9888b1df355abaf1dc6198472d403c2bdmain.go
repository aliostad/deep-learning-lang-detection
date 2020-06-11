// main
package main

import (
	//"log"
	"bytes"
	"flag"
	"go-state-machine/common"
	"time"

	"github.com/frameyl/log4go"
)

var size int

var ChanServer2Client chan []byte
var ChanClient2Server chan []byte

var DispMngServer common.DispatchMng
var DispMngClient common.DispatchMng

var SsmpDispServer *common.SsmpDispatch
var SsmpDispClient *common.SsmpDispatch

var SessionGroup *common.SessionGroupClient

func main() {
	log4go.LoadConfiguration("log.xml")

	//log.SetFlags(log.Ldate | log.Lmicroseconds)

	size := flag.Uint("size", 1000, "How many clinet session")

	flag.Parse()

	ChanClient2Server = make(chan []byte, 10)
	ChanServer2Client = make(chan []byte, 10)

	log4go.Info("Init Client...")
	init_client(int(*size))
	log4go.Info("Init Server...")
	init_server()

	go func() {
		for {
			packet := <-ChanClient2Server
			DispMngServer.Handle(packet)

			pkt := bytes.NewReader(packet)
			log4go.Fine("Receive a packet from client", common.DumpSsmpPacket(pkt))
		}
	}()

	go func() {
		for {
			packet := <-ChanServer2Client
			DispMngClient.Handle(packet)

			pkt := bytes.NewReader(packet)
			log4go.Fine("Receive a packet from server", common.DumpSsmpPacket(pkt))
		}
	}()

	log4go.Info("Start Client...")
	start_client()

	for {
		SessionGroup.Dump()
		log4go.Info(SsmpDispClient.DumpCounters())
		log4go.Info(SsmpDispServer.DumpCounters())
		time.Sleep(50 * time.Millisecond)

		if SessionGroup.Established == int(*size) {
			break
		}
	}
}

func init_server() {
	// Initialize dispatch for server
	SsmpDispServer = common.NewSsmpDispatch("ServerDisp1", common.SSMP_DISP_SVR)
	listener := common.NewSsmpListener("ServerMine1", 1001, 11001, ChanServer2Client)

	SsmpDispServer.SetListener(listener)

	go listener.RunListener(SsmpDispServer)

	DispMngServer.Add(SsmpDispServer)

	DispMngServer.Start()
}

func init_client(size int) {
	// Initialize dispatch for client
	SsmpDispClient = common.NewSsmpDispatch("ClientDisp1", common.SSMP_DISP_CLNT)

	DispMngClient.Add(SsmpDispClient)

	// Initialize session group for client
	SessionGroup = common.NewSessionGroupClient(1, size, SsmpDispClient, ChanClient2Server)

	DispMngClient.Start()
}

func start_client() {
	SessionGroup.Start()
}
