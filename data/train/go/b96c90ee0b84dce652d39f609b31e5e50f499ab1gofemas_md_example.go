// Copyright 2012 The Go Authors.  All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package main

import (
	"flag"
	"github.com/qerio/gofemas"
	"log"
	"os"
)

var (
	broker_id    = flag.String("BrokerID", "9999", "经纪公司编号,SimNow BrokerID统一为：9999")
	investor_id  = flag.String("InvestorID", "<InvestorID>", "交易用户代码")
	pass_word    = flag.String("Password", "<Password>", "交易用户密码")
	market_front = flag.String("MarketFront", "tcp://180.168.146.187:10031", "行情前置,SimNow的测试环境: tcp://180.168.146.187:10031")
	trade_front  = flag.String("TradeFront", "tcp://180.168.146.187:10030", "交易前置,SimNow的测试环境: tcp://180.168.146.187:10030")
)

var Femas GoFemasClient

type GoFemasClient struct {
	BrokerID   string
	InvestorID string
	Password   string

	MdFront string
	MdApi   gofemas.CUstpFtdcMduserApi

	TraderFront string
	TraderApi   gofemas.CUstpFtdcTraderApi

	MdRequestID     int
	TraderRequestID int
}

func (g *GoFemasClient) GetMdRequestID() int {
	g.MdRequestID += 1
	return g.MdRequestID
}

func (g *GoFemasClient) GetTraderRequestID() int {
	g.TraderRequestID += 1
	return g.TraderRequestID
}

func NewDirectorCUstpFtdcMduserSpi(v interface{}) gofemas.CUstpFtdcMduserSpi {

	return gofemas.NewDirectorCUstpFtdcMduserSpi(v)
}

type GoCUstpFtdcMduserSpi struct {
	Client GoFemasClient
}

func (p *GoCUstpFtdcMduserSpi) OnRspError(pRspInfo gofemas.CUstpFtdcRspInfoField, nRequestID int, bIsLast bool) {
	log.Println("*GoCUstpFtdcMduserSpi.OnRspError.")
	p.IsErrorRspInfo(pRspInfo)
}

func (p *GoCUstpFtdcMduserSpi) OnFrontDisconnected(nReason int) {
	log.Printf("*GoCUstpFtdcMduserSpi.OnFrontDisconnected: %#v\n", nReason)
}

func (p *GoCUstpFtdcMduserSpi) OnHeartBeatWarning(nTimeLapse int) {
	log.Printf("*GoCUstpFtdcMduserSpi.OnHeartBeatWarning: %v", nTimeLapse)
}

func (p *GoCUstpFtdcMduserSpi) OnFrontConnected() {
	log.Println("*GoCUstpFtdcMduserSpi.OnFrontConnected.")
	p.ReqUserLogin()
}

func (p *GoCUstpFtdcMduserSpi) ReqUserLogin() {
	log.Println("*GoCUstpFtdcMduserSpi.ReqUserLogin.")

	req := gofemas.NewCUstpFtdcReqUserLoginField()
	req.SetBrokerID(p.Client.BrokerID)
	req.SetUserID(p.Client.InvestorID)
	req.SetPassword(p.Client.Password)

	iResult := p.Client.MdApi.ReqUserLogin(req, p.Client.GetMdRequestID())

	if iResult != 0 {
		log.Println("发送用户登录请求: 失败.")
	} else {
		log.Println("发送用户登录请求: 成功.")
	}
}

func (p *GoCUstpFtdcMduserSpi) IsErrorRspInfo(pRspInfo gofemas.CUstpFtdcRspInfoField) bool {
	// 如果ErrorID != 0, 说明收到了错误的响应
	bResult := (pRspInfo.GetErrorID() != 0)
	if bResult {
		log.Printf("ErrorID=%v ErrorMsg=%v\n", pRspInfo.GetErrorID(), pRspInfo.GetErrorMsg())
	}
	return bResult
}

func (p *GoCUstpFtdcMduserSpi) OnRspUserLogin(pRspUserLogin gofemas.CUstpFtdcRspUserLoginField, pRspInfo gofemas.CUstpFtdcRspInfoField, nRequestID int, bIsLast bool) {

	if bIsLast && !p.IsErrorRspInfo(pRspInfo) {

		//log.Printf("获取版本信息    : %#v\n", gofemas.CUstpFtdcTraderApiGetApiVersion())
		log.Printf("获取当前交易日  : %#v\n", p.Client.MdApi.GetTradingDay())
		//log.Printf("获取用户登录信息: %#v %#v %#v\n", pRspUserLogin.GetLoginTime(), pRspUserLogin.GetSystemName(), pRspUserLogin.GetSessionID())

		ppInstrumentID := []string{"cu1610", "cu1611", "cu1612", "cu1701", "cu1702", "cu1703"}

		p.SubscribeMarketDataTopic(0, 0) ///订阅市场行情。
		p.SubMarketData(ppInstrumentID)  ///订阅合约行情。
	}
}

func (p *GoCUstpFtdcMduserSpi) SubscribeMarketDataTopic(nTopicID int, nResumeType int) {

	p.Client.MdApi.SubscribeMarketDataTopic(0, 0)

	log.Println("发送订阅市场行情: 成功.")
}

func (p *GoCUstpFtdcMduserSpi) SubMarketData(name []string) {

	iResult := p.Client.MdApi.SubMarketData(name)
	if iResult != 0 {
		log.Println("发送订阅合约行情: 失败.")
	} else {
		log.Println("发送订阅合约行情: 成功.")
	}
}

// func (p *GoCUstpFtdcMduserSpi) OnRspSubMarketData(pSpecificInstrument gofemas.CUstpFtdcSpecificInstrumentField, pRspInfo gofemas.CUstpFtdcRspInfoField, nRequestID int, bIsLast bool) {
// 	log.Printf("*GoCUstpFtdcMduserSpi.OnRspSubMarketData: %#v %#v %#v\n", pSpecificInstrument.GetInstrumentID(), nRequestID, bIsLast)
// 	p.IsErrorRspInfo(pRspInfo)
// }

// func (p *GoCUstpFtdcMduserSpi) OnRspSubForQuoteRsp(pSpecificInstrument gofemas.CUstpFtdcSpecificInstrumentField, pRspInfo gofemas.CUstpFtdcRspInfoField, nRequestID int, bIsLast bool) {
// 	log.Printf("*GoCUstpFtdcMduserSpi.OnRspSubForQuoteRsp: %#v %#v %#v\n", pSpecificInstrument.GetInstrumentID(), nRequestID, bIsLast)
// 	p.IsErrorRspInfo(pRspInfo)
// }

// func (p *GoCUstpFtdcMduserSpi) OnRspUnSubMarketData(pSpecificInstrument gofemas.CUstpFtdcSpecificInstrumentField, pRspInfo gofemas.CUstpFtdcRspInfoField, nRequestID int, bIsLast bool) {
// 	log.Printf("*GoCUstpFtdcMduserSpi.OnRspUnSubMarketData: %#v %#v %#v\n", pSpecificInstrument.GetInstrumentID(), nRequestID, bIsLast)
// 	p.IsErrorRspInfo(pRspInfo)
// }

// func (p *GoCUstpFtdcMduserSpi) OnRspUnSubForQuoteRsp(pSpecificInstrument gofemas.CUstpFtdcSpecificInstrumentField, pRspInfo gofemas.CUstpFtdcRspInfoField, nRequestID int, bIsLast bool) {
// 	log.Printf("*GoCUstpFtdcMduserSpi.OnRspUnSubForQuoteRsp: %#v %#v %#v\n", pSpecificInstrument.GetInstrumentID(), nRequestID, bIsLast)
// 	p.IsErrorRspInfo(pRspInfo)
// }

///订阅主题应答
func (p *GoCUstpFtdcMduserSpi) OnRspSubscribeTopic(pDissemination gofemas.CUstpFtdcDisseminationField, pRspInfo gofemas.CUstpFtdcRspInfoField, nRequestID int, bIsLast bool) {
	log.Printf("*GoCUstpFtdcMduserSpi.OnRspSubscribeTopic: %#v\n", pDissemination)
}

///主题查询应答
func (p *GoCUstpFtdcMduserSpi) OnRspQryTopic(pDissemination gofemas.CUstpFtdcDisseminationField, pRspInfo gofemas.CUstpFtdcRspInfoField, nRequestID int, bIsLast bool) {
	log.Printf("*GoCUstpFtdcMduserSpi.OnRspQryTopic: %#v\n", pDissemination)
}

///深度行情通知
func (p *GoCUstpFtdcMduserSpi) OnRtnDepthMarketData(pDepthMarketData gofemas.CUstpFtdcDepthMarketDataField) {
	log.Printf("*GoCUstpFtdcMduserSpi.OnRtnDepthMarketData: %#v\n", pDepthMarketData)
}

///订阅合约的相关信息
func (p *GoCUstpFtdcMduserSpi) OnRspSubMarketData(pSpecificInstrument gofemas.CUstpFtdcSpecificInstrumentField, pRspInfo gofemas.CUstpFtdcRspInfoField, nRequestID int, bIsLast bool) {
	log.Printf("*GoCUstpFtdcMduserSpi.OnRspSubMarketData: %#v\n", pSpecificInstrument)
}

func init() {
	log.SetFlags(log.LstdFlags)
	log.SetPrefix("Femas: ")
}

func main() {

	if len(os.Args) < 2 {
		log.Fatal("usage: ./gofemas_md_example -BrokerID 9999 -InvestorID 000000 -Password 000000 -MarketFront tcp://180.168.146.187:10010 -TradeFront tcp://180.168.146.187:10000")
	}

	flag.Parse()

	Femas = GoFemasClient{
		BrokerID:   *broker_id,
		InvestorID: *investor_id,
		Password:   *pass_word,

		MdFront: *market_front,
		MdApi:   gofemas.CUstpFtdcMduserApiCreateFtdcMduserApi(),

		TraderFront: *trade_front,
		TraderApi:   gofemas.CUstpFtdcTraderApiCreateFtdcTraderApi(),

		MdRequestID:     0,
		TraderRequestID: 0,
	}

	// Md
	pMdSpi := gofemas.NewDirectorCUstpFtdcMduserSpi(&GoCUstpFtdcMduserSpi{Client: Femas})

	Femas.MdApi.RegisterSpi(pMdSpi)
	Femas.MdApi.RegisterFront(Femas.MdFront)
	Femas.MdApi.Init()

	// wait for exit
	Femas.MdApi.Join()
	Femas.MdApi.Release()
}
