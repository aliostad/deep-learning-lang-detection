package netmanager

import (
	"ffCommon/net/base"
	"ffCommon/net/tcpclient"
	"ffCommon/uuid"
	"ffProto"
)

type netClient struct {
	config            *base.ConnectConfig   // 配置
	sendExtraDataType ffProto.ExtraDataType // 发送的协议的附加数据类型
	recvExtraDataType ffProto.ExtraDataType // 接收的协议的附加数据类型

	// client 底层连接管理对象
	client base.Client
	// uuid client.UUID()
	uuid uuid.UUID

	// chNewSession 用于接收新连接事件
	chNewSession chan base.Session
	// chNetExit 用于接收底层退出事件
	chNetExit chan struct{}
}

func (net *netClient) onAgentClosed() {
	if net.client != nil {
		net.client.ReConnect()
	}
}

func (net *netClient) Stop() {
	net.client.Stop()
}

func (net *netClient) BackNet() {
	net.client.Back()
	net.client = nil
}

func (net *netClient) NewSessionChan() chan base.Session {
	return net.chNewSession
}

func (net *netClient) WaitNetExit() {
	<-net.chNetExit
}

func (net *netClient) UUID() uuid.UUID {
	return net.uuid
}

func (net *netClient) Clear() {
	close(net.chNewSession)
	net.chNewSession = nil

	close(net.chNetExit)
	net.chNetExit = nil
}

func (net *netClient) SendExtraDataType() ffProto.ExtraDataType {
	return net.sendExtraDataType
}

func (net *netClient) RecvExtraDataType() ffProto.ExtraDataType {
	return net.recvExtraDataType
}

func (net *netClient) SessionNetEventDataCache() int {
	return net.config.SessionNetEventDataCache
}

func (net *netClient) SessionSendProtoCache() int {
	return net.config.SessionSendProtoCache
}

func newNetClient(config *base.ConnectConfig) (net inet, err error) {
	sendExtraDataType, err := ffProto.GetExtraDataType(config.SendExtraDataType)
	if err != nil {
		return
	}

	recvExtraDataType, err := ffProto.GetExtraDataType(config.RecvExtraDataType)
	if err != nil {
		return
	}

	client, err := tcpclient.NewClient(config.ConnectAddr)
	if err != nil {
		return
	}

	chNewSession := make(chan base.Session, 1)
	chNetExit := make(chan struct{}, 1)

	// 开启客户端
	client.Start(chNewSession, chNetExit)

	net = &netClient{
		config:            config,
		sendExtraDataType: sendExtraDataType,
		recvExtraDataType: recvExtraDataType,

		client: client,
		uuid:   client.UUID(),

		chNewSession: chNewSession,
		chNetExit:    chNetExit,
	}

	return
}
