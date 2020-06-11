package netmanager

import (
	"ffCommon/net/base"
	"ffCommon/net/tcpserver"
	"ffCommon/uuid"
	"ffProto"
)

type netServer struct {
	config            *base.ServeConfig     // 配置
	sendExtraDataType ffProto.ExtraDataType // 发送的协议的附加数据类型
	recvExtraDataType ffProto.ExtraDataType // 接收的协议的附加数据类型

	// server 底层server
	server base.Server
	// uuid server.UUID()
	uuid uuid.UUID

	// chNewSession 用于接收新连接事件
	chNewSession chan base.Session
	// chNetExit 用于接收底层退出事件
	chNetExit chan struct{}
}

func (net *netServer) onAgentClosed() {
}

func (net *netServer) Stop() {
	net.server.StopAccept()
}

func (net *netServer) BackNet() {
	net.server.Back()
	net.server = nil
}

func (net *netServer) NewSessionChan() chan base.Session {
	return net.chNewSession
}

func (net *netServer) WaitNetExit() {
	<-net.chNetExit
}

func (net *netServer) UUID() uuid.UUID {
	return net.uuid
}

func (net *netServer) Clear() {
	close(net.chNewSession)
	net.chNewSession = nil

	close(net.chNetExit)
	net.chNetExit = nil
}

func (net *netServer) SendExtraDataType() ffProto.ExtraDataType {
	return net.sendExtraDataType
}

func (net *netServer) RecvExtraDataType() ffProto.ExtraDataType {
	return net.recvExtraDataType
}

func (net *netServer) SessionNetEventDataCache() int {
	return net.config.SessionNetEventDataCache
}

func (net *netServer) SessionSendProtoCache() int {
	return net.config.SessionSendProtoCache
}

func newNetServer(config *base.ServeConfig) (net inet, err error) {
	sendExtraDataType, err := ffProto.GetExtraDataType(config.SendExtraDataType)
	if err != nil {
		return
	}

	recvExtraDataType, err := ffProto.GetExtraDataType(config.RecvExtraDataType)
	if err != nil {
		return
	}

	server, err := tcpserver.NewServer(config.ListenAddr)
	if err != nil {
		return
	}

	chNewSession := make(chan base.Session, config.AcceptNewSessionCache)
	chNetExit := make(chan struct{}, 1)

	// 开启服务器
	if err = server.Start(chNewSession, chNetExit); err != nil {
		close(chNewSession)
		close(chNetExit)

		// 开启失败, 回收
		server.Back()
		return
	}

	net = &netServer{
		config:            config,
		sendExtraDataType: sendExtraDataType,
		recvExtraDataType: recvExtraDataType,

		server: server,
		uuid:   server.UUID(),

		chNewSession: chNewSession,
		chNetExit:    chNetExit,
	}

	return
}
