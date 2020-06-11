// Copyright 2012 The Go Authors.  All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package main

import (
	"flag"
	"github.com/qerio/gofemas"
	"log"
	"os"
	"time"
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

func NewDirectorCUstpFtdcTraderSpi(v interface{}) gofemas.CUstpFtdcTraderSpi {
	return gofemas.NewDirectorCUstpFtdcTraderSpi(v)
}

type GoCUstpFtdcTraderSpi struct {
	Client GoFemasClient
}

func (p *GoCUstpFtdcTraderSpi) OnRspError(pRspInfo gofemas.CUstpFtdcRspInfoField, nRequestID int, bIsLast bool) {
	log.Println("GoCUstpFtdcTraderSpi.OnRspError.")
	p.IsErrorRspInfo(pRspInfo)
}

func (p *GoCUstpFtdcTraderSpi) OnFrontDisconnected(nReason int) {
	log.Printf("GoCUstpFtdcTraderSpi.OnFrontDisconnected: %#v", nReason)
}

func (p *GoCUstpFtdcTraderSpi) OnHeartBeatWarning(nTimeLapse int) {
	log.Printf("GoCUstpFtdcTraderSpi.OnHeartBeatWarning: %#v", nTimeLapse)
}

func (p *GoCUstpFtdcTraderSpi) OnFrontConnected() {
	log.Println("GoCUstpFtdcTraderSpi.OnFrontConnected.")
	p.ReqUserLogin()
}

func (p *GoCUstpFtdcTraderSpi) ReqUserLogin() {
	log.Println("GoCUstpFtdcTraderSpi.ReqUserLogin.")

	req := gofemas.NewCUstpFtdcReqUserLoginField()
	req.SetBrokerID(p.Client.BrokerID)
	req.SetUserID(p.Client.InvestorID)
	req.SetPassword(p.Client.Password)

	iResult := p.Client.TraderApi.ReqUserLogin(req, p.Client.GetTraderRequestID())

	if iResult != 0 {
		log.Println("发送用户登录请求: 失败.")
	} else {
		log.Println("发送用户登录请求: 成功.")
	}
}

func (p *GoCUstpFtdcTraderSpi) IsFlowControl(iResult int) bool {
	return ((iResult == -2) || (iResult == -3))
}

func (p *GoCUstpFtdcTraderSpi) IsErrorRspInfo(pRspInfo gofemas.CUstpFtdcRspInfoField) bool {
	// 如果ErrorID != 0, 说明收到了错误的响应
	bResult := (pRspInfo.GetErrorID() != 0)
	if bResult {
		log.Printf("ErrorID=%v ErrorMsg=%v\n", pRspInfo.GetErrorID(), pRspInfo.GetErrorMsg())
	}
	return bResult
}

func (p *GoCUstpFtdcTraderSpi) OnRspUserLogin(pRspUserLogin gofemas.CUstpFtdcRspUserLoginField, pRspInfo gofemas.CUstpFtdcRspInfoField, nRequestID int, bIsLast bool) {

	log.Println("GoCUstpFtdcTraderSpi.OnRspUserLogin.")
	if bIsLast && !p.IsErrorRspInfo(pRspInfo) {

		log.Printf("获取当前交易日  : %#v\n", p.Client.TraderApi.GetTradingDay())
		//log.Printf("获取用户登录信息: %#v %#v %#v\n", pRspUserLogin.GetFrontID(), pRspUserLogin.GetSessionID(), pRspUserLogin.GetMaxOrderRef())

		// // 保存会话参数
		// FRONT_ID = pRspUserLogin->FrontID;
		// SESSION_ID = pRspUserLogin->SessionID;
		// int iNextOrderRef = atoi(pRspUserLogin->MaxOrderRef);
		// iNextOrderRef++;
		// sprintf(ORDER_REF, "%d", iNextOrderRef);
		// sprintf(EXECORDER_REF, "%d", 1);
		// sprintf(FORQUOTE_REF, "%d", 1);
		// sprintf(QUOTE_REF, "%d", 1);
		// ///获取当前交易日
		// cerr << "获取当前交易日 = " << pMdApi->GetTradingDay() << endl;
		// ///投资者结算结果确认
		//p.ReqSettlementInfoConfirm()
	}
}

// func (p *GoCUstpFtdcTraderSpi) ReqSettlementInfoConfirm() {
// 	req := gofemas.NewCUstpFtdcSettlementInfoConfirmField()

// 	req.SetBrokerID(p.Client.BrokerID)
// 	req.SetInvestorID(p.Client.InvestorID)

// 	iResult := p.Client.TraderApi.ReqSettlementInfoConfirm(req, p.Client.GetTraderRequestID())

// 	if iResult != 0 {
// 		log.Println("投资者结算结果确认: 失败.")
// 	} else {
// 		log.Println("投资者结算结果确认: 成功.")
// 	}
// }

// func (p *GoCUstpFtdcTraderSpi) OnRspSettlementInfoConfirm(pSettlementInfoConfirm gofemas.CUstpFtdcSettlementInfoConfirmField, pRspInfo gofemas.CUstpFtdcRspInfoField, nRequestID int, bIsLast bool) {
// 	//cerr << "--->>> " << "OnRspSettlementInfoConfirm" << endl
// 	log.Println("GoCUstpFtdcTraderSpi.OnRspSettlementInfoConfirm.")
// 	if bIsLast && !p.IsErrorRspInfo(pRspInfo) {
// 		///请求查询合约
// 		p.ReqQryInstrument()
// 	}
// }

func (p *GoCUstpFtdcTraderSpi) ReqQryInstrument() {
	req := gofemas.NewCUstpFtdcQryInstrumentField()

	var id string = "cu1612"
	req.SetInstrumentID(id)

	for {
		iResult := p.Client.TraderApi.ReqQryInstrument(req, p.Client.GetTraderRequestID())

		if !p.IsFlowControl(iResult) {
			log.Printf("--->>> 请求查询合约: 成功 %#v\n", iResult)
			//break
		} else {
			log.Printf("--->>> 请求查询合约: 受到流控 %#v\n", iResult)
			time.Sleep(1 * time.Second)
		}
	}
}

// func (p *GoCUstpFtdcTraderSpi) OnRspQryInstrument(pInstrument gofemas.CUstpFtdcInstrumentField, pRspInfo gofemas.CUstpFtdcRspInfoField, nRequestID int, bIsLast bool) {
// 	log.Println("GoCUstpFtdcTraderSpi.OnRspQryInstrument: ", pInstrument.GetInstrumentID(), pInstrument.GetExchangeID(),
// 		pInstrument.GetInstrumentName(), pInstrument.GetExchangeInstID(), pInstrument.GetProductID(), pInstrument.GetProductClass(),
// 		pInstrument.GetDeliveryYear(), pInstrument.GetDeliveryMonth(), pInstrument.GetMaxMarketOrderVolume(), pInstrument.GetMinMarketOrderVolume(),
// 		pInstrument.GetMaxLimitOrderVolume(), pInstrument.GetMinLimitOrderVolume(), pInstrument.GetVolumeMultiple(), pInstrument.GetPriceTick(),
// 		pInstrument.GetCreateDate(), pInstrument.GetOpenDate(), pInstrument.GetExpireDate(), pInstrument.GetStartDelivDate(), pInstrument.GetEndDelivDate(),
// 		nRequestID, bIsLast)
// 	if bIsLast && !p.IsErrorRspInfo(pRspInfo) {

// 		///请求查询合约
// 		p.ReqQryTradingAccount()
// 	}
// }

// func (p *GoCUstpFtdcTraderSpi) ReqQryTradingAccount() {
// 	req := gofemas.NewCUstpFtdcQryTradingAccountField()
// 	req.SetBrokerID(p.Client.BrokerID)
// 	req.SetInvestorID(p.Client.InvestorID)

// 	for {
// 		iResult := p.Client.TraderApi.ReqQryTradingAccount(req, p.Client.GetTraderRequestID())

// 		if !p.IsFlowControl(iResult) {
// 			log.Printf("--->>> 请求查询资金账户: 成功 %#v\n", iResult)
// 			//break
// 		} else {
// 			log.Printf("--->>> 请求查询资金账户: 受到流控 %#v\n", iResult)
// 			time.Sleep(1 * time.Second)
// 		}
// 	}
// }

// func (p *GoCUstpFtdcTraderSpi) OnRspQryTradingAccount(pTradingAccount gofemas.CUstpFtdcTradingAccountField, pRspInfo gofemas.CUstpFtdcRspInfoField, nRequestID int, bIsLast bool) {

// 	log.Println("GoCUstpFtdcTraderSpi.OnRspQryTradingAccount.")

// 	if bIsLast && !p.IsErrorRspInfo(pRspInfo) {
// 		///请求查询投资者持仓
// 		p.ReqQryInvestorPosition()
// 	}
// }

// func (p *GoCUstpFtdcTraderSpi) ReqQryInvestorPosition() {

// 	req := gofemas.NewCUstpFtdcQryInvestorPositionField()
// 	req.SetBrokerID(p.Client.BrokerID)
// 	req.SetInvestorID(p.Client.InvestorID)
// 	req.SetInstrumentID("cu1612")

// 	for {
// 		iResult := p.Client.TraderApi.ReqQryInvestorPosition(req, p.Client.GetTraderRequestID())

// 		if !p.IsFlowControl(iResult) {
// 			log.Printf("--->>> 请求查询投资者持仓: 成功 %#v\n", iResult)
// 			//break;
// 		} else {
// 			log.Printf("--->>> 请求查询投资者持仓: 受到流控 %#v\n", iResult)
// 			time.Sleep(1 * time.Second)
// 		}
// 	}
// }

// func (p *GoCUstpFtdcTraderSpi) OnRspQryInvestorPosition(pInvestorPosition gofemas.CUstpFtdcInvestorPositionField, pRspInfo gofemas.CUstpFtdcRspInfoField, nRequestID int, bIsLast bool) {
// 	log.Println("GoCUstpFtdcTraderSpi.OnRspQryInvestorPosition.")

// 	if bIsLast && !p.IsErrorRspInfo(pRspInfo) {
// 		// ///报单录入请求
// 		// ReqOrderInsert();
// 		// //执行宣告录入请求
// 		// ReqExecOrderInsert();
// 		// //询价录入
// 		// ReqForQuoteInsert();
// 		// //做市商报价录入
// 		// ReqQuoteInsert();
// 	}
// }

func init() {
	log.SetFlags(log.LstdFlags)
	log.SetPrefix("Femas: ")
}

func main() {

	if len(os.Args) < 2 {
		log.Fatal("usage: ./gofemas_trader_example -BrokerID 9999 -InvestorID 000000 -Password 000000 -MarketFront tcp://180.168.146.187:10010 -TradeFront tcp://180.168.146.187:10000")
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

	// // Md
	// pMdSpi := gofemas.NewDirectorCUstpFtdcMduserSpi(&GoCUstpFtdcMduserSpi{Client: Femas})

	// Femas.MdApi.RegisterSpi(pMdSpi)
	// Femas.MdApi.RegisterFront(Femas.MdFront)
	// Femas.MdApi.Init()

	// // wait for exit
	// Femas.MdApi.Join()
	// Femas.MdApi.Release()
}
