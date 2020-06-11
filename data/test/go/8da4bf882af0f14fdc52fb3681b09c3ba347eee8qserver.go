package qserver

import (
	"connect-server/model"
	"fmt"
	"net"
	"strconv"
)

type QServer struct {
	IP         string
	Port       int
	DispatchIP string
	TokenPort  int
	UserCache  *model.UserCache
	Listener   net.Listener
	Conn       *net.UDPConn
	UDPServer  *UDPServer
	Error      error
}

func NewQServer(ip string, port int, userCache *model.UserCache, dispatchIP string, tokenPort int) *QServer {
	return &QServer{
		UserCache:  userCache,
		IP:         ip,
		Port:       port,
		DispatchIP: dispatchIP,
		TokenPort:  tokenPort,
	}
}

func (server *QServer) Start() {
	server.Listener, server.Error = net.Listen("tcp", server.IP+":"+strconv.Itoa(server.Port))
	if server.Error != nil {
		server.Error = fmt.Errorf("QServer Start Error: %v", server.Error)
		return
	}
	defer server.Listener.Close()
	server.Receive()
}

func (server *QServer) Receive() {
	for {
		Conn, err := server.Listener.Accept()
		if err != nil {
			continue
		}
		tcpHandler := NewTCPHandler(server.UserCache, &Conn, server.DispatchIP, server.TokenPort)
		go tcpHandler.Handle()
	}
}
