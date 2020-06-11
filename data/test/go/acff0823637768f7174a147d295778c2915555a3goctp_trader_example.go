
package _example

//import (
//	"flag"
//	"myApp/goctp"
//	"log"
//	"os"
//
//	"fmt"
//
//)
//
//var (
//	broker_id    = flag.String("BrokerID", "9999", "经纪公司编号,SimNow BrokerID统一为：9999")
//	investor_id  = flag.String("InvestorID", "093858", "交易用户代码")
//	pass_word    = flag.String("Password", "kobekobe520", "交易用户密码")
//	market_front = flag.String("MarketFront", "tcp://180.168.146.187:10031", "行情前置,SimNow的测试环境: tcp://180.168.146.187:10031")
//	trade_front  = flag.String("TradeFront", "tcp://180.168.146.187:10030", "交易前置,SimNow的测试环境: tcp://180.168.146.187:10030")
//)
//
//var CTP GoCTPClient
//
//
//
//type GoCTPClient struct {
//	BrokerID   string
//	InvestorID string
//	Password   string
//
//	MdFront string
//	MdApi   goctp.CThostFtdcMdApi
//
//	TraderFront string
//	TraderApi   goctp.CThostFtdcTraderApi
//
//	MdRequestID     int
//	TraderRequestID int
//}
//
//func (g *GoCTPClient) GetMdRequestID() int {
//	g.MdRequestID += 1
//	return g.MdRequestID
//}
//
//func (g *GoCTPClient) GetTraderRequestID() int {
//	g.TraderRequestID += 1
//	return g.TraderRequestID
//}
//
//func NewDirectorCThostFtdcTraderSpi(v interface{}) goctp.CThostFtdcTraderSpi {
//	return goctp.NewDirectorCThostFtdcTraderSpi(v)
//}
//
//type GoCThostFtdcTraderSpi struct {
//	Client GoCTPClient
//}
//
//func (p *GoCThostFtdcTraderSpi) OnRspError(pRspInfo goctp.CThostFtdcRspInfoField, nRequestID int, bIsLast bool) {
//	log.Println("GoCThostFtdcTraderSpi.OnRspError.")
//	p.IsErrorRspInfo(pRspInfo)
//}
//
//func (p *GoCThostFtdcTraderSpi) OnFrontDisconnected(nReason int) {
//	log.Printf("GoCThostFtdcTraderSpi.OnFrontDisconnected: %#v", nReason)
//}
//
//func (p *GoCThostFtdcTraderSpi) OnHeartBeatWarning(nTimeLapse int) {
//	log.Printf("GoCThostFtdcTraderSpi.OnHeartBeatWarning: %#v", nTimeLapse)
//}
//
//func (p *GoCThostFtdcTraderSpi) OnFrontConnected() {
//	log.Println("GoCThostFtdcTraderSpi.OnFrontConnected.")
//	p.ReqUserLogin()
//}
//
//func (p *GoCThostFtdcTraderSpi) ReqUserLogin() {
//	log.Println("GoCThostFtdcTraderSpi.ReqUserLogin.")
//
//	req := goctp.NewCThostFtdcReqUserLoginField()
//	req.SetBrokerID(p.Client.BrokerID)
//	req.SetUserID(p.Client.InvestorID)
//	req.SetPassword(p.Client.Password)
//
//	iResult := p.Client.TraderApi.ReqUserLogin(req, p.Client.GetTraderRequestID())
//
//	if iResult != 0 {
//		log.Println("发送用户登录请求: 失败.")
//	} else {
//		log.Println("发送用户登录请求: 成功.")
//	}
//}
//
//func (p *GoCThostFtdcTraderSpi) IsFlowControl(iResult int) bool {
//	return ((iResult == -2) || (iResult == -3))
//}
//
//func (p *GoCThostFtdcTraderSpi) IsErrorRspInfo(pRspInfo goctp.CThostFtdcRspInfoField) bool {
//	// 如果ErrorID != 0, 说明收到了错误的响应
//	bResult := (pRspInfo.GetErrorID() != 0)
//	if bResult {
//		log.Printf("ErrorID=%v ErrorMsg=%v\n", pRspInfo.GetErrorID(), pRspInfo.GetErrorMsg())
//	}
//	return bResult
//}
//
//func (p *GoCThostFtdcTraderSpi) OnRspUserLogin(pRspUserLogin goctp.CThostFtdcRspUserLoginField, pRspInfo goctp.CThostFtdcRspInfoField, nRequestID int, bIsLast bool) {
//
//	log.Println("GoCThostFtdcTraderSpi.OnRspUserLogin.")
//	if bIsLast && !p.IsErrorRspInfo(pRspInfo) {
//
//		log.Printf("获取当前交易日  : %#v\n", p.Client.TraderApi.GetTradingDay())
//		log.Printf("获取用户登录信息: %#v %#v %#v\n", pRspUserLogin.GetFrontID(), pRspUserLogin.GetSessionID(), pRspUserLogin.GetMaxOrderRef())
//
//		 //// 保存会话参数
//		 //FRONT_ID = pRspUserLogin->FrontID;
//		 //SESSION_ID = pRspUserLogin->SessionID;
//		 //int iNextOrderRef = atoi(pRspUserLogin->MaxOrderRef);
//		 //iNextOrderRef++;
//		 //sprintf(ORDER_REF, "%d", iNextOrderRef);
//		 //sprintf(EXECORDER_REF, "%d", 1);
//		 //sprintf(FORQUOTE_REF, "%d", 1);
//		 //sprintf(QUOTE_REF, "%d", 1);
//		 /////获取当前交易日
//		 //cerr << "获取当前交易日 = " << pMdApi->GetTradingDay() << endl;
//		 /////投资者结算结果确认
//		p.ReqSettlementInfoConfirm()
//	}
//}
//
//func (p *GoCThostFtdcTraderSpi) ReqSettlementInfoConfirm() {
//	req := goctp.NewCThostFtdcSettlementInfoConfirmField()
//
//	req.SetBrokerID(p.Client.BrokerID)
//	req.SetInvestorID(p.Client.InvestorID)
//
//	iResult := p.Client.TraderApi.ReqSettlementInfoConfirm(req, p.Client.GetTraderRequestID())
//
//	if iResult != 0 {
//		log.Println("投资者结算结果确认: 失败.")
//	} else {
//		log.Println("投资者结算结果确认: 成功.")
//	}
//}
//
//func (p *GoCThostFtdcTraderSpi) OnRspSettlementInfoConfirm(pSettlementInfoConfirm goctp.CThostFtdcSettlementInfoConfirmField, pRspInfo goctp.CThostFtdcRspInfoField, nRequestID int, bIsLast bool) {
//	//cerr << "--->>> " << "OnRspSettlementInfoConfirm" << endl
//	log.Println("GoCThostFtdcTraderSpi.OnRspSettlementInfoConfirm.")
//	if bIsLast && !p.IsErrorRspInfo(pRspInfo) {
//		///请求查询合约
//		p.ReqQryInstrument()
//	}
//}
//
//func (p *GoCThostFtdcTraderSpi) ReqQryInstrument() {
//
//
//	req := goctp.NewCThostFtdcQryInstrumentField()
//
//	var id string = "rb1710"
//	req.SetInstrumentID(id)
//
//
//	iResult := p.Client.TraderApi.ReqQryInstrument(req, p.Client.GetTraderRequestID())
//	for {
//		if !p.IsFlowControl(iResult) {
//			log.Printf("--->>> 请求查询合约: 成功 %#v\n", iResult)
//			break
//		} else {
//			log.Printf("--->>> 请求查询合约: 受到流控 %#v\n", iResult)
//			break
//		}
//	}
//}
//
//func (p *GoCThostFtdcTraderSpi) OnRspQryInstrument(pInstrument goctp.CThostFtdcInstrumentField, pRspInfo goctp.CThostFtdcRspInfoField, nRequestID int, bIsLast bool) {
//	log.Println("GoCThostFtdcTraderSpi.OnRspQryInstrument: ", pInstrument.GetInstrumentID(), pInstrument.GetExchangeID(),
//		pInstrument.GetInstrumentName(), pInstrument.GetExchangeInstID(), pInstrument.GetProductID(), pInstrument.GetProductClass(),
//		pInstrument.GetDeliveryYear(), pInstrument.GetDeliveryMonth(), pInstrument.GetMaxMarketOrderVolume(), pInstrument.GetMinMarketOrderVolume(),
//		pInstrument.GetMaxLimitOrderVolume(), pInstrument.GetMinLimitOrderVolume(), pInstrument.GetVolumeMultiple(), pInstrument.GetPriceTick(),
//		pInstrument.GetCreateDate(), pInstrument.GetOpenDate(), pInstrument.GetExpireDate(), pInstrument.GetStartDelivDate(), pInstrument.GetEndDelivDate(),
//		nRequestID, bIsLast)
//
//	p.ReqQryTradingAccount()
//	//fmt.Println("a")
//	//if bIsLast && !p.IsErrorRspInfo(pRspInfo) {
//	//	///请求查询合约
//	//	fmt.Println("b")
//	//
//	//
//	//} else{
//	//	fmt.Println("Error in OnRspQryInstrument:",p.IsErrorRspInfo(pRspInfo))
//	//}
//}
//
//func (p *GoCThostFtdcTraderSpi) ReqQryTradingAccount() {
//	req := goctp.NewCThostFtdcQryTradingAccountField()
//	req.SetBrokerID(p.Client.BrokerID)
//	req.SetInvestorID(p.Client.InvestorID)
//
//
//	iResult := p.Client.TraderApi.ReqQryTradingAccount(req, p.Client.GetTraderRequestID())
//	for {
//		if !p.IsFlowControl(iResult) {
//			log.Printf("--->>> 请求查询资金账户: 成功 %#v\n", iResult)
//			break
//		} else {
//			log.Printf("--->>> 请求查询资金账户: 受到流控 %#v\n", iResult)
//
//		}
//	}
//}
//
//func (p *GoCThostFtdcTraderSpi) OnRspQryTradingAccount(pTradingAccount goctp.CThostFtdcTradingAccountField, pRspInfo goctp.CThostFtdcRspInfoField, nRequestID int, bIsLast bool) {
//
//	log.Println("GoCThostFtdcTraderSpi.OnRspQryTradingAccount.")
//
//	if bIsLast && !p.IsErrorRspInfo(pRspInfo) {
//		///请求查询投资者持仓
//		p.ReqQryInvestorPosition()
//	}
//}
//
//func (p *GoCThostFtdcTraderSpi) ReqQryInvestorPosition() {
//
//	req := goctp.NewCThostFtdcQryInvestorPositionField()
//	req.SetBrokerID(p.Client.BrokerID)
//	req.SetInvestorID(p.Client.InvestorID)
//	req.SetInstrumentID("rb1710")
//
//	for {
//		iResult := p.Client.TraderApi.ReqQryInvestorPosition(req, p.Client.GetTraderRequestID())
//
//		if !p.IsFlowControl(iResult) {
//			log.Printf("--->>> 请求查询投资者持仓: 成功 %#v\n", iResult)
//			break;
//		} else {
//			log.Printf("--->>> 请求查询投资者持仓: 受到流控 %#v\n", iResult)
//			break
//		}
//	}
//}
//
//func (p *GoCThostFtdcTraderSpi) OnRspQryInvestorPosition(pInvestorPosition goctp.CThostFtdcInvestorPositionField, pRspInfo goctp.CThostFtdcRspInfoField, nRequestID int, bIsLast bool) {
//	log.Println("GoCThostFtdcTraderSpi.OnRspQryInvestorPosition.")
//	fmt.Println("position data:",pInvestorPosition.GetPositionDate())
//	fmt.Println("InstrumentID:",pInvestorPosition.GetInstrumentID())
//
//
//	if bIsLast && !p.IsErrorRspInfo(pRspInfo) {
//		// ///报单录入请求
//		p.ReqOrderInsert();
//		// //执行宣告录入请求
//		// ReqExecOrderInsert();
//		// //询价录入
//		// ReqForQuoteInsert();
//		// //做市商报价录入
//		// ReqQuoteInsert();
//	}
//}
//
////---------------------------------------------------------------
//// send order
//
//func (p *GoCThostFtdcTraderSpi) ReqOrderInsert(){
//
//	req := goctp.NewCThostFtdcInputOrderField()
//
//	req.SetAccountID("1")
//	req.SetBrokerID(p.Client.BrokerID)
//	req.SetInvestorID(p.Client.InvestorID)
//	req.SetUserID(p.Client.InvestorID)
//	req.SetExchangeID("SHFE")
//	req.SetDirection(goctp.THOST_FTDC_D_Sell)
//	req.SetInstrumentID("rb1710")
//	req.SetCombOffsetFlag("0")
//	req.SetOrderPriceType(goctp.THOST_FTDC_OPT_LimitPrice)
//	req.SetCombHedgeFlag("3")
//	req.SetLimitPrice(3943)
//	req.SetVolumeTotalOriginal(1)
//	req.SetTimeCondition(goctp.THOST_FTDC_TC_GFD)
//	req.SetVolumeCondition(goctp.THOST_FTDC_VC_AV)
//	req.SetMinVolume(1)
//	req.SetContingentCondition(goctp.THOST_FTDC_CC_Immediately)
//	req.SetForceCloseReason(goctp.THOST_FTDC_FCC_NotForceClose)
//	req.SetIsAutoSuspend(0)
//	req.SetUserForceClose(0)
//
//	fmt.Println("start...")
//	result := p.Client.TraderApi.ReqOrderInsert(req,1)
//	for {
//		if result == 0 {
//			fmt.Println("send order cuccess!")
//			break
//		} else {
//			fmt.Println("send faild :", result)
//		}
//	}
//
//}
//
//// order respone
//
//func (p *GoCThostFtdcTraderSpi)OnRspOrderInsert(arg2 goctp.CThostFtdcInputOrderField, arg3 goctp.CThostFtdcRspInfoField, arg4 int, arg5 bool){
//
//
//	fmt.Println("OnRspOrderInsert...")
//	if arg5 && !p.IsErrorRspInfo(arg3) {
//		fmt.Println("end")
//	} else{
//		fmt.Println("Error:",p.IsErrorRspInfo(arg3))
//	}
//}
//
//func init() {
//	log.SetFlags(log.LstdFlags)
//	log.SetPrefix("CTP: ")
//}
//
//func main() {
//
//	if len(os.Args) < 2 {
//		log.Fatal("usage: ./goctp_trader_example -BrokerID 9999 -InvestorID 000000 -Password 000000 -MarketFront tcp://180.168.146.187:10010 -TradeFront tcp://180.168.146.187:10000")
//	}
//
//	flag.Parse()
//
//	CTP = GoCTPClient{
//		BrokerID:   *broker_id,
//		InvestorID: *investor_id,
//		Password:   *pass_word,
//
//		MdFront: *market_front,
//		MdApi:   goctp.CThostFtdcMdApiCreateFtdcMdApi(),
//
//		TraderFront: *trade_front,
//		TraderApi:   goctp.CThostFtdcTraderApiCreateFtdcTraderApi(),
//
//		MdRequestID:     0,
//		TraderRequestID: 0,
//	}
//
//	pTraderSpi := goctp.NewDirectorCThostFtdcTraderSpi(&GoCThostFtdcTraderSpi{Client: CTP})
//
//	CTP.TraderApi.RegisterSpi(pTraderSpi)                         // 注册事件类
//	CTP.TraderApi.SubscribePublicTopic(0 /*THOST_TERT_RESTART*/)  // 注册公有流
//	CTP.TraderApi.SubscribePrivateTopic(0 /*THOST_TERT_RESTART*/) // 注册私有流
//	CTP.TraderApi.RegisterFront(CTP.TraderFront)
//	CTP.TraderApi.Init()
//
//	CTP.TraderApi.Join()
//	CTP.TraderApi.Release()
//}
