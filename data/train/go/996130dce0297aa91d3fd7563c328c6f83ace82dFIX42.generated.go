package dict

type FIX42 struct {
}

func (f FIX42) Version() string {
	return "FIX.4.2"
}

func (f FIX42) TagName(tag int) (string, bool) {
	switch tag {
	case 1:
		return "Account", true
	case 2:
		return "AdvId", true
	case 3:
		return "AdvRefID", true
	case 4:
		return "AdvSide", true
	case 5:
		return "AdvTransType", true
	case 6:
		return "AvgPx", true
	case 7:
		return "BeginSeqNo", true
	case 8:
		return "BeginString", true
	case 9:
		return "BodyLength", true
	case 10:
		return "CheckSum", true
	case 11:
		return "ClOrdID", true
	case 12:
		return "Commission", true
	case 13:
		return "CommType", true
	case 14:
		return "CumQty", true
	case 15:
		return "Currency", true
	case 16:
		return "EndSeqNo", true
	case 17:
		return "ExecID", true
	case 18:
		return "ExecInst", true
	case 19:
		return "ExecRefID", true
	case 20:
		return "ExecTransType", true
	case 21:
		return "HandlInst", true
	case 22:
		return "IDSource", true
	case 23:
		return "IOIid", true
	case 24:
		return "IOIOthSvc", true
	case 25:
		return "IOIQltyInd", true
	case 26:
		return "IOIRefID", true
	case 27:
		return "IOIShares", true
	case 28:
		return "IOITransType", true
	case 29:
		return "LastCapacity", true
	case 30:
		return "LastMkt", true
	case 31:
		return "LastPx", true
	case 32:
		return "LastShares", true
	case 33:
		return "LinesOfText", true
	case 34:
		return "MsgSeqNum", true
	case 35:
		return "MsgType", true
	case 36:
		return "NewSeqNo", true
	case 37:
		return "OrderID", true
	case 38:
		return "OrderQty", true
	case 39:
		return "OrdStatus", true
	case 40:
		return "OrdType", true
	case 41:
		return "OrigClOrdID", true
	case 42:
		return "OrigTime", true
	case 43:
		return "PossDupFlag", true
	case 44:
		return "Price", true
	case 45:
		return "RefSeqNum", true
	case 46:
		return "RelatdSym", true
	case 47:
		return "Rule80A", true
	case 48:
		return "SecurityID", true
	case 49:
		return "SenderCompID", true
	case 50:
		return "SenderSubID", true
	case 51:
		return "SendingDate", true
	case 52:
		return "SendingTime", true
	case 53:
		return "Shares", true
	case 54:
		return "Side", true
	case 55:
		return "Symbol", true
	case 56:
		return "TargetCompID", true
	case 57:
		return "TargetSubID", true
	case 58:
		return "Text", true
	case 59:
		return "TimeInForce", true
	case 60:
		return "TransactTime", true
	case 61:
		return "Urgency", true
	case 62:
		return "ValidUntilTime", true
	case 63:
		return "SettlmntTyp", true
	case 64:
		return "FutSettDate", true
	case 65:
		return "SymbolSfx", true
	case 66:
		return "ListID", true
	case 67:
		return "ListSeqNo", true
	case 68:
		return "TotNoOrders", true
	case 69:
		return "ListExecInst", true
	case 70:
		return "AllocID", true
	case 71:
		return "AllocTransType", true
	case 72:
		return "RefAllocID", true
	case 73:
		return "NoOrders", true
	case 74:
		return "AvgPrxPrecision", true
	case 75:
		return "TradeDate", true
	case 76:
		return "ExecBroker", true
	case 77:
		return "OpenClose", true
	case 78:
		return "NoAllocs", true
	case 79:
		return "AllocAccount", true
	case 80:
		return "AllocShares", true
	case 81:
		return "ProcessCode", true
	case 82:
		return "NoRpts", true
	case 83:
		return "RptSeq", true
	case 84:
		return "CxlQty", true
	case 85:
		return "NoDlvyInst", true
	case 86:
		return "DlvyInst", true
	case 87:
		return "AllocStatus", true
	case 88:
		return "AllocRejCode", true
	case 89:
		return "Signature", true
	case 90:
		return "SecureDataLen", true
	case 91:
		return "SecureData", true
	case 92:
		return "BrokerOfCredit", true
	case 93:
		return "SignatureLength", true
	case 94:
		return "EmailType", true
	case 95:
		return "RawDataLength", true
	case 96:
		return "RawData", true
	case 97:
		return "PossResend", true
	case 98:
		return "EncryptMethod", true
	case 99:
		return "StopPx", true
	case 100:
		return "ExDestination", true
	case 102:
		return "CxlRejReason", true
	case 103:
		return "OrdRejReason", true
	case 104:
		return "IOIQualifier", true
	case 105:
		return "WaveNo", true
	case 106:
		return "Issuer", true
	case 107:
		return "SecurityDesc", true
	case 108:
		return "HeartBtInt", true
	case 109:
		return "ClientID", true
	case 110:
		return "MinQty", true
	case 111:
		return "MaxFloor", true
	case 112:
		return "TestReqID", true
	case 113:
		return "ReportToExch", true
	case 114:
		return "LocateReqd", true
	case 115:
		return "OnBehalfOfCompID", true
	case 116:
		return "OnBehalfOfSubID", true
	case 117:
		return "QuoteID", true
	case 118:
		return "NetMoney", true
	case 119:
		return "SettlCurrAmt", true
	case 120:
		return "SettlCurrency", true
	case 121:
		return "ForexReq", true
	case 122:
		return "OrigSendingTime", true
	case 123:
		return "GapFillFlag", true
	case 124:
		return "NoExecs", true
	case 125:
		return "CxlType", true
	case 126:
		return "ExpireTime", true
	case 127:
		return "DKReason", true
	case 128:
		return "DeliverToCompID", true
	case 129:
		return "DeliverToSubID", true
	case 130:
		return "IOINaturalFlag", true
	case 131:
		return "QuoteReqID", true
	case 132:
		return "BidPx", true
	case 133:
		return "OfferPx", true
	case 134:
		return "BidSize", true
	case 135:
		return "OfferSize", true
	case 136:
		return "NoMiscFees", true
	case 137:
		return "MiscFeeAmt", true
	case 138:
		return "MiscFeeCurr", true
	case 139:
		return "MiscFeeType", true
	case 140:
		return "PrevClosePx", true
	case 141:
		return "ResetSeqNumFlag", true
	case 142:
		return "SenderLocationID", true
	case 143:
		return "TargetLocationID", true
	case 144:
		return "OnBehalfOfLocationID", true
	case 145:
		return "DeliverToLocationID", true
	case 146:
		return "NoRelatedSym", true
	case 147:
		return "Subject", true
	case 148:
		return "Headline", true
	case 149:
		return "URLLink", true
	case 150:
		return "ExecType", true
	case 151:
		return "LeavesQty", true
	case 152:
		return "CashOrderQty", true
	case 153:
		return "AllocAvgPx", true
	case 154:
		return "AllocNetMoney", true
	case 155:
		return "SettlCurrFxRate", true
	case 156:
		return "SettlCurrFxRateCalc", true
	case 157:
		return "NumDaysInterest", true
	case 158:
		return "AccruedInterestRate", true
	case 159:
		return "AccruedInterestAmt", true
	case 160:
		return "SettlInstMode", true
	case 161:
		return "AllocText", true
	case 162:
		return "SettlInstID", true
	case 163:
		return "SettlInstTransType", true
	case 164:
		return "EmailThreadID", true
	case 165:
		return "SettlInstSource", true
	case 166:
		return "SettlLocation", true
	case 167:
		return "SecurityType", true
	case 168:
		return "EffectiveTime", true
	case 169:
		return "StandInstDbType", true
	case 170:
		return "StandInstDbName", true
	case 171:
		return "StandInstDbID", true
	case 172:
		return "SettlDeliveryType", true
	case 173:
		return "SettlDepositoryCode", true
	case 174:
		return "SettlBrkrCode", true
	case 175:
		return "SettlInstCode", true
	case 176:
		return "SecuritySettlAgentName", true
	case 177:
		return "SecuritySettlAgentCode", true
	case 178:
		return "SecuritySettlAgentAcctNum", true
	case 179:
		return "SecuritySettlAgentAcctName", true
	case 180:
		return "SecuritySettlAgentContactName", true
	case 181:
		return "SecuritySettlAgentContactPhone", true
	case 182:
		return "CashSettlAgentName", true
	case 183:
		return "CashSettlAgentCode", true
	case 184:
		return "CashSettlAgentAcctNum", true
	case 185:
		return "CashSettlAgentAcctName", true
	case 186:
		return "CashSettlAgentContactName", true
	case 187:
		return "CashSettlAgentContactPhone", true
	case 188:
		return "BidSpotRate", true
	case 189:
		return "BidForwardPoints", true
	case 190:
		return "OfferSpotRate", true
	case 191:
		return "OfferForwardPoints", true
	case 192:
		return "OrderQty2", true
	case 193:
		return "FutSettDate2", true
	case 194:
		return "LastSpotRate", true
	case 195:
		return "LastForwardPoints", true
	case 196:
		return "AllocLinkID", true
	case 197:
		return "AllocLinkType", true
	case 198:
		return "SecondaryOrderID", true
	case 199:
		return "NoIOIQualifiers", true
	case 200:
		return "MaturityMonthYear", true
	case 201:
		return "PutOrCall", true
	case 202:
		return "StrikePrice", true
	case 203:
		return "CoveredOrUncovered", true
	case 204:
		return "CustomerOrFirm", true
	case 205:
		return "MaturityDay", true
	case 206:
		return "OptAttribute", true
	case 207:
		return "SecurityExchange", true
	case 208:
		return "NotifyBrokerOfCredit", true
	case 209:
		return "AllocHandlInst", true
	case 210:
		return "MaxShow", true
	case 211:
		return "PegDifference", true
	case 212:
		return "XmlDataLen", true
	case 213:
		return "XmlData", true
	case 214:
		return "SettlInstRefID", true
	case 215:
		return "NoRoutingIDs", true
	case 216:
		return "RoutingType", true
	case 217:
		return "RoutingID", true
	case 218:
		return "SpreadToBenchmark", true
	case 219:
		return "Benchmark", true
	case 223:
		return "CouponRate", true
	case 231:
		return "ContractMultiplier", true
	case 262:
		return "MDReqID", true
	case 263:
		return "SubscriptionRequestType", true
	case 264:
		return "MarketDepth", true
	case 265:
		return "MDUpdateType", true
	case 266:
		return "AggregatedBook", true
	case 267:
		return "NoMDEntryTypes", true
	case 268:
		return "NoMDEntries", true
	case 269:
		return "MDEntryType", true
	case 270:
		return "MDEntryPx", true
	case 271:
		return "MDEntrySize", true
	case 272:
		return "MDEntryDate", true
	case 273:
		return "MDEntryTime", true
	case 274:
		return "TickDirection", true
	case 275:
		return "MDMkt", true
	case 276:
		return "QuoteCondition", true
	case 277:
		return "TradeCondition", true
	case 278:
		return "MDEntryID", true
	case 279:
		return "MDUpdateAction", true
	case 280:
		return "MDEntryRefID", true
	case 281:
		return "MDReqRejReason", true
	case 282:
		return "MDEntryOriginator", true
	case 283:
		return "LocationID", true
	case 284:
		return "DeskID", true
	case 285:
		return "DeleteReason", true
	case 286:
		return "OpenCloseSettleFlag", true
	case 287:
		return "SellerDays", true
	case 288:
		return "MDEntryBuyer", true
	case 289:
		return "MDEntrySeller", true
	case 290:
		return "MDEntryPositionNo", true
	case 291:
		return "FinancialStatus", true
	case 292:
		return "CorporateAction", true
	case 293:
		return "DefBidSize", true
	case 294:
		return "DefOfferSize", true
	case 295:
		return "NoQuoteEntries", true
	case 296:
		return "NoQuoteSets", true
	case 297:
		return "QuoteAckStatus", true
	case 298:
		return "QuoteCancelType", true
	case 299:
		return "QuoteEntryID", true
	case 300:
		return "QuoteRejectReason", true
	case 301:
		return "QuoteResponseLevel", true
	case 302:
		return "QuoteSetID", true
	case 303:
		return "QuoteRequestType", true
	case 304:
		return "TotQuoteEntries", true
	case 305:
		return "UnderlyingIDSource", true
	case 306:
		return "UnderlyingIssuer", true
	case 307:
		return "UnderlyingSecurityDesc", true
	case 308:
		return "UnderlyingSecurityExchange", true
	case 309:
		return "UnderlyingSecurityID", true
	case 310:
		return "UnderlyingSecurityType", true
	case 311:
		return "UnderlyingSymbol", true
	case 312:
		return "UnderlyingSymbolSfx", true
	case 313:
		return "UnderlyingMaturityMonthYear", true
	case 314:
		return "UnderlyingMaturityDay", true
	case 315:
		return "UnderlyingPutOrCall", true
	case 316:
		return "UnderlyingStrikePrice", true
	case 317:
		return "UnderlyingOptAttribute", true
	case 318:
		return "UnderlyingCurrency", true
	case 319:
		return "RatioQty", true
	case 320:
		return "SecurityReqID", true
	case 321:
		return "SecurityRequestType", true
	case 322:
		return "SecurityResponseID", true
	case 323:
		return "SecurityResponseType", true
	case 324:
		return "SecurityStatusReqID", true
	case 325:
		return "UnsolicitedIndicator", true
	case 326:
		return "SecurityTradingStatus", true
	case 327:
		return "HaltReason", true
	case 328:
		return "InViewOfCommon", true
	case 329:
		return "DueToRelated", true
	case 330:
		return "BuyVolume", true
	case 331:
		return "SellVolume", true
	case 332:
		return "HighPx", true
	case 333:
		return "LowPx", true
	case 334:
		return "Adjustment", true
	case 335:
		return "TradSesReqID", true
	case 336:
		return "TradingSessionID", true
	case 337:
		return "ContraTrader", true
	case 338:
		return "TradSesMethod", true
	case 339:
		return "TradSesMode", true
	case 340:
		return "TradSesStatus", true
	case 341:
		return "TradSesStartTime", true
	case 342:
		return "TradSesOpenTime", true
	case 343:
		return "TradSesPreCloseTime", true
	case 344:
		return "TradSesCloseTime", true
	case 345:
		return "TradSesEndTime", true
	case 346:
		return "NumberOfOrders", true
	case 347:
		return "MessageEncoding", true
	case 348:
		return "EncodedIssuerLen", true
	case 349:
		return "EncodedIssuer", true
	case 350:
		return "EncodedSecurityDescLen", true
	case 351:
		return "EncodedSecurityDesc", true
	case 352:
		return "EncodedListExecInstLen", true
	case 353:
		return "EncodedListExecInst", true
	case 354:
		return "EncodedTextLen", true
	case 355:
		return "EncodedText", true
	case 356:
		return "EncodedSubjectLen", true
	case 357:
		return "EncodedSubject", true
	case 358:
		return "EncodedHeadlineLen", true
	case 359:
		return "EncodedHeadline", true
	case 360:
		return "EncodedAllocTextLen", true
	case 361:
		return "EncodedAllocText", true
	case 362:
		return "EncodedUnderlyingIssuerLen", true
	case 363:
		return "EncodedUnderlyingIssuer", true
	case 364:
		return "EncodedUnderlyingSecurityDescLen", true
	case 365:
		return "EncodedUnderlyingSecurityDesc", true
	case 366:
		return "AllocPrice", true
	case 367:
		return "QuoteSetValidUntilTime", true
	case 368:
		return "QuoteEntryRejectReason", true
	case 369:
		return "LastMsgSeqNumProcessed", true
	case 370:
		return "OnBehalfOfSendingTime", true
	case 371:
		return "RefTagID", true
	case 372:
		return "RefMsgType", true
	case 373:
		return "SessionRejectReason", true
	case 374:
		return "BidRequestTransType", true
	case 375:
		return "ContraBroker", true
	case 376:
		return "ComplianceID", true
	case 377:
		return "SolicitedFlag", true
	case 378:
		return "ExecRestatementReason", true
	case 379:
		return "BusinessRejectRefID", true
	case 380:
		return "BusinessRejectReason", true
	case 381:
		return "GrossTradeAmt", true
	case 382:
		return "NoContraBrokers", true
	case 383:
		return "MaxMessageSize", true
	case 384:
		return "NoMsgTypes", true
	case 385:
		return "MsgDirection", true
	case 386:
		return "NoTradingSessions", true
	case 387:
		return "TotalVolumeTraded", true
	case 388:
		return "DiscretionInst", true
	case 389:
		return "DiscretionOffset", true
	case 390:
		return "BidID", true
	case 391:
		return "ClientBidID", true
	case 392:
		return "ListName", true
	case 393:
		return "TotalNumSecurities", true
	case 394:
		return "BidType", true
	case 395:
		return "NumTickets", true
	case 396:
		return "SideValue1", true
	case 397:
		return "SideValue2", true
	case 398:
		return "NoBidDescriptors", true
	case 399:
		return "BidDescriptorType", true
	case 400:
		return "BidDescriptor", true
	case 401:
		return "SideValueInd", true
	case 402:
		return "LiquidityPctLow", true
	case 403:
		return "LiquidityPctHigh", true
	case 404:
		return "LiquidityValue", true
	case 405:
		return "EFPTrackingError", true
	case 406:
		return "FairValue", true
	case 407:
		return "OutsideIndexPct", true
	case 408:
		return "ValueOfFutures", true
	case 409:
		return "LiquidityIndType", true
	case 410:
		return "WtAverageLiquidity", true
	case 411:
		return "ExchangeForPhysical", true
	case 412:
		return "OutMainCntryUIndex", true
	case 413:
		return "CrossPercent", true
	case 414:
		return "ProgRptReqs", true
	case 415:
		return "ProgPeriodInterval", true
	case 416:
		return "IncTaxInd", true
	case 417:
		return "NumBidders", true
	case 418:
		return "TradeType", true
	case 419:
		return "BasisPxType", true
	case 420:
		return "NoBidComponents", true
	case 421:
		return "Country", true
	case 422:
		return "TotNoStrikes", true
	case 423:
		return "PriceType", true
	case 424:
		return "DayOrderQty", true
	case 425:
		return "DayCumQty", true
	case 426:
		return "DayAvgPx", true
	case 427:
		return "GTBookingInst", true
	case 428:
		return "NoStrikes", true
	case 429:
		return "ListStatusType", true
	case 430:
		return "NetGrossInd", true
	case 431:
		return "ListOrderStatus", true
	case 432:
		return "ExpireDate", true
	case 433:
		return "ListExecInstType", true
	case 434:
		return "CxlRejResponseTo", true
	case 435:
		return "UnderlyingCouponRate", true
	case 436:
		return "UnderlyingContractMultiplier", true
	case 437:
		return "ContraTradeQty", true
	case 438:
		return "ContraTradeTime", true
	case 439:
		return "ClearingFirm", true
	case 440:
		return "ClearingAccount", true
	case 441:
		return "LiquidityNumSecurities", true
	case 442:
		return "MultiLegReportingType", true
	case 443:
		return "StrikeTime", true
	case 444:
		return "ListStatusText", true
	case 445:
		return "EncodedListStatusTextLen", true
	case 446:
		return "EncodedListStatusText", true
	default:
		return "", false
	}
}

func (f FIX42) ValueName(tag int, value string) (string, bool) {
	switch tag {
	case 4:
		switch value {
		case "B":
			return `Buy`, true
		case "S":
			return `Sell`, true
		case "T":
			return `Trade`, true
		case "X":
			return `Cross`, true
		}

	case 5:
		switch value {
		case "C":
			return `Cancel`, true
		case "N":
			return `New`, true
		case "R":
			return `Replace`, true
		}

	case 13:
		switch value {
		case "1":
			return `per share`, true
		case "2":
			return `percentage`, true
		case "3":
			return `absolute`, true
		}

	case 18:
		switch value {
		case "0":
			return `Stay on offerside`, true
		case "1":
			return `Not held`, true
		case "2":
			return `Work`, true
		case "3":
			return `Go along`, true
		case "4":
			return `Over the day`, true
		case "5":
			return `Held`, true
		case "6":
			return `Participate don't initiate`, true
		case "7":
			return `Strict scale`, true
		case "8":
			return `Try to scale`, true
		case "9":
			return `Stay on bidside`, true
		case "A":
			return `No cross (cross is forbidden)`, true
		case "B":
			return `OK to cross`, true
		case "C":
			return `Call first`, true
		case "D":
			return `Percent of volume (indicates that the sender does not want to be all of the volume on the floor vs. a specific percentage)`, true
		case "E":
			return `Do not increase - DNI`, true
		case "F":
			return `Do not reduce - DNR`, true
		case "G":
			return `All or none - AON`, true
		case "I":
			return `Institutions only`, true
		case "L":
			return `Last peg (last sale)`, true
		case "M":
			return `Mid-price peg (midprice of inside quote)`, true
		case "N":
			return `Non-negotiable`, true
		case "O":
			return `Opening peg`, true
		case "P":
			return `Market peg`, true
		case "R":
			return `Primary peg (primary market - buy at bid/sell at offer)`, true
		case "S":
			return `Suspend`, true
		case "T":
			return `Fixed Peg to Local best bid or offer at time of order`, true
		case "U":
			return `Customer Display Instruction (Rule11Ac1-1/4)`, true
		case "V":
			return `Netting (for Forex)`, true
		case "W":
			return `Peg to VWAP`, true
		}

	case 20:
		switch value {
		case "0":
			return `New`, true
		case "1":
			return `Cancel`, true
		case "2":
			return `Correct`, true
		case "3":
			return `Status`, true
		}

	case 21:
		switch value {
		case "1":
			return `Automated execution order, private, no Broker intervention`, true
		case "2":
			return `Automated execution order, public, Broker intervention OK`, true
		case "3":
			return `Manual order, best execution`, true
		}

	case 22:
		switch value {
		case "1":
			return `CUSIP`, true
		case "2":
			return `SEDOL`, true
		case "3":
			return `QUIK`, true
		case "4":
			return `ISIN number`, true
		case "5":
			return `RIC code`, true
		case "6":
			return `ISO Currency Code`, true
		case "7":
			return `ISO Country Code`, true
		case "8":
			return `Exchange Symbol`, true
		case "9":
			return `Consolidated Tape Association (CTA) Symbol (SIAC CTS/CQS line format)`, true
		}

	case 25:
		switch value {
		case "H":
			return `High`, true
		case "L":
			return `Low`, true
		case "M":
			return `Medium`, true
		}

	case 27:
		switch value {
		case "L":
			return `Large`, true
		case "M":
			return `Medium`, true
		case "S":
			return `Small`, true
		}

	case 28:
		switch value {
		case "C":
			return `Cancel`, true
		case "N":
			return `New`, true
		case "R":
			return `Replace`, true
		}

	case 29:
		switch value {
		case "1":
			return `Agent`, true
		case "2":
			return `Cross as agent`, true
		case "3":
			return `Cross as principal`, true
		case "4":
			return `Principal`, true
		}

	case 35:
		switch value {
		case "0":
			return `Heartbeat`, true
		case "1":
			return `Test Request`, true
		case "2":
			return `Resend Request`, true
		case "3":
			return `Reject`, true
		case "4":
			return `Sequence Reset`, true
		case "5":
			return `Logout`, true
		case "6":
			return `Indication of Interest`, true
		case "7":
			return `Advertisement`, true
		case "8":
			return `Execution Report`, true
		case "9":
			return `Order Cancel Reject`, true
		case "a":
			return `Quote Status Request`, true
		case "A":
			return `Logon`, true
		case "B":
			return `News`, true
		case "b":
			return `Quote Acknowledgement`, true
		case "C":
			return `Email`, true
		case "c":
			return `Security Definition Request`, true
		case "D":
			return `Order Single`, true
		case "d":
			return `Security Definition`, true
		case "E":
			return `Order List`, true
		case "e":
			return `Security Status Request`, true
		case "f":
			return `Security Status`, true
		case "F":
			return `Order Cancel Request`, true
		case "G":
			return `Order Cancel/Replace Request`, true
		case "g":
			return `Trading Session Status Request`, true
		case "H":
			return `Order Status Request`, true
		case "h":
			return `Trading Session Status`, true
		case "i":
			return `Mass Quote`, true
		case "j":
			return `Business Message Reject`, true
		case "J":
			return `Allocation`, true
		case "K":
			return `List Cancel Request`, true
		case "k":
			return `Bid Request`, true
		case "l":
			return `Bid Response (lowercase L)`, true
		case "L":
			return `List Execute`, true
		case "m":
			return `List Strike Price`, true
		case "M":
			return `List Status Request`, true
		case "N":
			return `List Status`, true
		case "P":
			return `Allocation ACK`, true
		case "Q":
			return `Dont Know Trade (DK)`, true
		case "R":
			return `Quote Request`, true
		case "S":
			return `Quote`, true
		case "T":
			return `Settlement Instructions`, true
		case "V":
			return `Market Data Request`, true
		case "W":
			return `Market Data-Snapshot/Full Refresh`, true
		case "X":
			return `Market Data-Incremental Refresh`, true
		case "Y":
			return `Market Data Request Reject`, true
		case "Z":
			return `Quote Cancel`, true
		}

	case 39:
		switch value {
		case "0":
			return `New`, true
		case "1":
			return `Partially filled`, true
		case "2":
			return `Filled`, true
		case "3":
			return `Done for day`, true
		case "4":
			return `Canceled`, true
		case "5":
			return `Replaced`, true
		case "6":
			return `Pending Cancel (e.g. result of Order Cancel Request)`, true
		case "7":
			return `Stopped`, true
		case "8":
			return `Rejected`, true
		case "9":
			return `Suspended`, true
		case "A":
			return `Pending New`, true
		case "B":
			return `Calculated`, true
		case "C":
			return `Expired`, true
		case "D":
			return `Accepted for bidding`, true
		case "E":
			return `Pending Replace (e.g. result of Order Cancel/Replace Request)`, true
		}

	case 40:
		switch value {
		case "1":
			return `Market`, true
		case "2":
			return `Limit`, true
		case "3":
			return `Stop`, true
		case "4":
			return `Stop limit`, true
		case "5":
			return `Market on close`, true
		case "6":
			return `With or without`, true
		case "7":
			return `Limit or better`, true
		case "8":
			return `Limit with or without`, true
		case "9":
			return `On basis`, true
		case "A":
			return `On close`, true
		case "B":
			return `Limit on close`, true
		case "C":
			return `Forex - Market`, true
		case "D":
			return `Previously quoted`, true
		case "E":
			return `Previously indicated`, true
		case "F":
			return `Forex - Limit`, true
		case "G":
			return `Forex - Swap`, true
		case "H":
			return `Forex - Previously Quoted`, true
		case "I":
			return `Funari (Limit Day Order with unexecuted portion handled as Market On Close. e.g. Japan)`, true
		case "P":
			return `Pegged`, true
		}

	case 43:
		switch value {
		case "N":
			return `Original transmission`, true
		case "Y":
			return `Possible duplicate`, true
		}

	case 47:
		switch value {
		case "A":
			return `Agency single order`, true
		case "B":
			return `Short exempt transaction (refer to A type)`, true
		case "C":
			return `Program Order, non-index arb, for Member firm/org`, true
		case "D":
			return `Program Order, index arb, for Member firm/org`, true
		case "E":
			return `Registered Equity Market Maker trades`, true
		case "F":
			return `Short exempt transaction (refer to W type)`, true
		case "H":
			return `Short exempt transaction (refer to I type)`, true
		case "I":
			return `Individual Investor, single order`, true
		case "J":
			return `Program Order, index arb, for individual customer`, true
		case "K":
			return `Program Order, non-index arb, for individual customer`, true
		case "L":
			return `Short exempt transaction for member competing market-maker affiliated with the firm clearing the trade (refer to P and O types)`, true
		case "M":
			return `Program Order, index arb, for other member`, true
		case "N":
			return `Program Order, non-index arb, for other member`, true
		case "O":
			return `Competing dealer trades`, true
		case "P":
			return `Principal`, true
		case "R":
			return `Competing dealer trades`, true
		case "S":
			return `Specialist trades`, true
		case "T":
			return `Competing dealer trades`, true
		case "U":
			return `Program Order, index arb, for other agency`, true
		case "W":
			return `All other orders as agent for other member`, true
		case "X":
			return `Short exempt transaction for member competing market-maker not affiliated with the firm clearing the trade (refer to W and T types)`, true
		case "Y":
			return `Program Order, non-index arb, for other agency`, true
		case "Z":
			return `Short exempt transaction for non-member competing market-maker (refer to A and R types)`, true
		}

	case 54:
		switch value {
		case "1":
			return `Buy`, true
		case "2":
			return `Sell`, true
		case "3":
			return `Buy minus`, true
		case "4":
			return `Sell plus`, true
		case "5":
			return `Sell short`, true
		case "6":
			return `Sell short exempt`, true
		case "7":
			return `Undisclosed (valid for IOI and List Order messages only)`, true
		case "8":
			return `Cross (orders where counterparty is an exchange, valid for all messages except IOIs)`, true
		case "9":
			return `Cross short`, true
		}

	case 59:
		switch value {
		case "0":
			return `Day`, true
		case "1":
			return `Good Till Cancel (GTC)`, true
		case "2":
			return `At the Opening (OPG)`, true
		case "3":
			return `Immediate or Cancel (IOC)`, true
		case "4":
			return `Fill or Kill (FOK)`, true
		case "5":
			return `Good Till Crossing (GTX)`, true
		case "6":
			return `Good Till Date`, true
		}

	case 61:
		switch value {
		case "0":
			return `Normal`, true
		case "1":
			return `Flash`, true
		case "2":
			return `Background`, true
		}

	case 63:
		switch value {
		case "0":
			return `Regular`, true
		case "1":
			return `Cash`, true
		case "2":
			return `Next Day`, true
		case "3":
			return `T+2`, true
		case "4":
			return `T+3`, true
		case "5":
			return `T+4`, true
		case "6":
			return `Future`, true
		case "7":
			return `When Issued`, true
		case "8":
			return `Sellers Option`, true
		case "9":
			return `T+ 5`, true
		}

	case 71:
		switch value {
		case "0":
			return `New`, true
		case "1":
			return `Replace`, true
		case "2":
			return `Cancel`, true
		case "3":
			return `Preliminary (without MiscFees and NetMoney)`, true
		case "4":
			return `Calculated (includes MiscFees and NetMoney)`, true
		case "5":
			return `Calculated without Preliminary (sent unsolicited by broker, includes MiscFees and NetMoney)`, true
		}

	case 77:
		switch value {
		case "C":
			return `Close`, true
		case "O":
			return `Open`, true
		}

	case 81:
		switch value {
		case "0":
			return `regular`, true
		case "1":
			return `soft dollar`, true
		case "2":
			return `step-in`, true
		case "3":
			return `step-out`, true
		case "4":
			return `soft-dollar step-in`, true
		case "5":
			return `soft-dollar step-out`, true
		case "6":
			return `plan sponsor`, true
		}

	case 87:
		switch value {
		case "0":
			return `accepted (successfully processed)`, true
		case "1":
			return `rejected`, true
		case "2":
			return `partial accept`, true
		case "3":
			return `received (received, not yet processed)`, true
		}

	case 88:
		switch value {
		case "0":
			return `unknown account(s)`, true
		case "1":
			return `incorrect quantity`, true
		case "2":
			return `incorrect average price`, true
		case "3":
			return `unknown executing broker mnemonic`, true
		case "4":
			return `commission difference`, true
		case "5":
			return `unknown OrderID`, true
		case "6":
			return `unknown ListID`, true
		case "7":
			return `other`, true
		}

	case 94:
		switch value {
		case "0":
			return `New`, true
		case "1":
			return `Reply`, true
		case "2":
			return `Admin Reply`, true
		}

	case 97:
		switch value {
		case "N":
			return `Original transmission`, true
		case "Y":
			return `Possible resend`, true
		}

	case 98:
		switch value {
		case "0":
			return `None / other`, true
		case "1":
			return `PKCS (proprietary)`, true
		case "2":
			return `DES (ECB mode)`, true
		case "3":
			return `PKCS/DES (proprietary)`, true
		case "4":
			return `PGP/DES (defunct)`, true
		case "5":
			return `PGP/DES-MD5 (see app note on FIX web site)`, true
		case "6":
			return `PEM/DES-MD5 (see app note on FIX web site)`, true
		}

	case 102:
		switch value {
		case "0":
			return `Too late to cancel`, true
		case "1":
			return `Unknown order`, true
		case "2":
			return `Broker Option`, true
		case "3":
			return `Order already in Pending Cancel or Pending Replace status`, true
		}

	case 103:
		switch value {
		case "0":
			return `Broker option`, true
		case "1":
			return `Unknown symbol`, true
		case "2":
			return `Exchange closed`, true
		case "3":
			return `Order exceeds limit`, true
		case "4":
			return `Too late to enter`, true
		case "5":
			return `Unknown Order`, true
		case "6":
			return `Duplicate Order (e.g. dupe ClOrdID)`, true
		case "7":
			return `Duplicate of a verbally communicated order`, true
		case "8":
			return `Stale Order`, true
		}

	case 104:
		switch value {
		case "A":
			return `All or none`, true
		case "C":
			return `At the close`, true
		case "I":
			return `In touch with`, true
		case "L":
			return `Limit`, true
		case "M":
			return `More behind`, true
		case "O":
			return `At the open`, true
		case "P":
			return `Taking a position`, true
		case "Q":
			return `At the Market (previously called Current Quote)`, true
		case "R":
			return `Ready to trade`, true
		case "S":
			return `Portfolio show-n`, true
		case "T":
			return `Through the day`, true
		case "V":
			return `Versus`, true
		case "W":
			return `Indication - Working away`, true
		case "X":
			return `Crossing opportunity`, true
		case "Y":
			return `At the Midpoint`, true
		case "Z":
			return `Pre-open`, true
		}

	case 113:
		switch value {
		case "N":
			return `Indicates that party sending message will report trade`, true
		case "Y":
			return `Indicates that party receiving message must report trade`, true
		}

	case 114:
		switch value {
		case "N":
			return `Indicates the broker is not required to locate`, true
		case "Y":
			return `Indicates the broker is responsible for locating the stock`, true
		}

	case 121:
		switch value {
		case "N":
			return `Do not execute Forex after security trade`, true
		case "Y":
			return `Execute Forex after security trade`, true
		}

	case 123:
		switch value {
		case "N":
			return `Sequence Reset, ignore MsgSeqNum`, true
		case "Y":
			return `Gap Fill message, MsgSeqNum field valid`, true
		}

	case 127:
		switch value {
		case "A":
			return `Unknown symbol`, true
		case "B":
			return `Wrong side`, true
		case "C":
			return `Quantity exceeds order`, true
		case "D":
			return `No matching order`, true
		case "E":
			return `Price exceeds limit`, true
		case "Z":
			return `Other`, true
		}

	case 130:
		switch value {
		case "N":
			return `Not natural`, true
		case "Y":
			return `Natural`, true
		}

	case 139:
		switch value {
		case "1":
			return `Regulatory (e.g. SEC)`, true
		case "2":
			return `Tax`, true
		case "3":
			return `Local Commission`, true
		case "4":
			return `Exchange Fees`, true
		case "5":
			return `Stamp`, true
		case "6":
			return `Levy`, true
		case "7":
			return `Other`, true
		case "8":
			return `Markup`, true
		case "9":
			return `Consumption Tax`, true
		}

	case 141:
		switch value {
		case "N":
			return `No`, true
		case "Y":
			return `Yes, reset sequence numbers`, true
		}

	case 150:
		switch value {
		case "0":
			return `New`, true
		case "1":
			return `Partial fill`, true
		case "2":
			return `Fill`, true
		case "3":
			return `Done for day`, true
		case "4":
			return `Canceled`, true
		case "5":
			return `Replace`, true
		case "6":
			return `Pending Cancel (e.g. result of Order Cancel Request)`, true
		case "7":
			return `Stopped`, true
		case "8":
			return `Rejected`, true
		case "9":
			return `Suspended`, true
		case "A":
			return `Pending New`, true
		case "B":
			return `Calculated`, true
		case "C":
			return `Expired`, true
		case "D":
			return `Restated (ExecutionRpt sent unsolicited by sellside, with ExecRestatementReason set)`, true
		case "E":
			return `Pending Replace (e.g. result of Order Cancel/Replace Request)`, true
		}

	case 160:
		switch value {
		case "0":
			return `Default`, true
		case "1":
			return `Standing Instructions Provided`, true
		case "2":
			return `Specific Allocation Account Overriding`, true
		case "3":
			return `Specific Allocation Account Standing`, true
		}

	case 163:
		switch value {
		case "C":
			return `Cancel`, true
		case "N":
			return `New`, true
		case "R":
			return `Replace`, true
		}

	case 165:
		switch value {
		case "1":
			return `Brokers Instructions`, true
		case "2":
			return `Institutions Instructions`, true
		}

	case 166:
		switch value {
		case "CED":
			return `CEDEL`, true
		case "DTC":
			return `Depository Trust Company`, true
		case "EUR":
			return `Euroclear`, true
		case "FED":
			return `Federal Book Entry`, true
		case "ISO Country Code":
			return `Local Market Settle Location`, true
		case "PNY":
			return `Physical`, true
		case "PTC":
			return `Participant Trust Company`, true
		}

	case 167:
		switch value {
		case "?":
			return `Wildcard entry (used on Security Definition Request message)`, true
		case "BA":
			return `Bankers Acceptance`, true
		case "CB":
			return `Convertible Bond (Note not part of ISITC spec)`, true
		case "CD":
			return `Certificate Of Deposit`, true
		case "CMO":
			return `Collateralize Mortgage Obligation`, true
		case "CORP":
			return `Corporate Bond`, true
		case "CP":
			return `Commercial Paper`, true
		case "CPP":
			return `Corporate Private Placement`, true
		case "CS":
			return `Common Stock`, true
		case "FHA":
			return `Federal Housing Authority`, true
		case "FHL":
			return `Federal Home Loan`, true
		case "FN":
			return `Federal National Mortgage Association`, true
		case "FOR":
			return `Foreign Exchange Contract`, true
		case "FUT":
			return `Future`, true
		case "GN":
			return `Government National Mortgage Association`, true
		case "GOVT":
			return `Treasuries + Agency Debenture`, true
		case "IET":
			return `Mortgage IOETTE`, true
		case "MF":
			return `Mutual Fund`, true
		case "MIO":
			return `Mortgage Interest Only`, true
		case "MPO":
			return `Mortgage Principal Only`, true
		case "MPP":
			return `Mortgage Private Placement`, true
		case "MPT":
			return `Miscellaneous Pass-Thru`, true
		case "MUNI":
			return `Municipal Bond`, true
		case "NONE":
			return `No ISITC Security Type`, true
		case "OPT":
			return `Option`, true
		case "PS":
			return `Preferred Stock`, true
		case "RP":
			return `Repurchase Agreement`, true
		case "RVRP":
			return `Reverse Repurchase Agreement`, true
		case "SL":
			return `Student Loan Marketing Association`, true
		case "TD":
			return `Time Deposit`, true
		case "USTB":
			return `US Treasury Bill`, true
		case "WAR":
			return `Warrant`, true
		case "ZOO":
			return `Cats, Tigers & Lions (a real code: US Treasury Receipts)`, true
		}

	case 169:
		switch value {
		case "0":
			return `Other`, true
		case "1":
			return `DTC SID`, true
		case "2":
			return `Thomson ALERT`, true
		case "3":
			return `A Global Custodian (StandInstDbName must be provided)`, true
		}

	case 197:
		switch value {
		case "0":
			return `F/X Netting`, true
		case "1":
			return `F/X Swap`, true
		}

	case 201:
		switch value {
		case "0":
			return `Put`, true
		case "1":
			return `Call`, true
		}

	case 203:
		switch value {
		case "0":
			return `Covered`, true
		case "1":
			return `Uncovered`, true
		}

	case 204:
		switch value {
		case "0":
			return `Customer`, true
		case "1":
			return `Firm`, true
		}

	case 208:
		switch value {
		case "N":
			return `Details should not be communicated`, true
		case "Y":
			return `Details should be communicated`, true
		}

	case 209:
		switch value {
		case "1":
			return `Match`, true
		case "2":
			return `Forward`, true
		case "3":
			return `Forward and Match`, true
		}

	case 216:
		switch value {
		case "1":
			return `Target Firm`, true
		case "2":
			return `Target List`, true
		case "3":
			return `Block Firm`, true
		case "4":
			return `Block List`, true
		}

	case 219:
		switch value {
		case "1":
			return `CURVE`, true
		case "2":
			return `5-YR`, true
		case "3":
			return `OLD-5`, true
		case "4":
			return `10-YR`, true
		case "5":
			return `OLD-10`, true
		case "6":
			return `30-YR`, true
		case "7":
			return `OLD-30`, true
		case "8":
			return `3-MO-LIBOR`, true
		case "9":
			return `6-MO-LIBOR`, true
		}

	case 263:
		switch value {
		case "0":
			return `Snapshot`, true
		case "1":
			return `Snapshot + Updates (Subscribe)`, true
		case "2":
			return `Disable previous Snapshot + Update Request (Unsubscribe)`, true
		}

	case 265:
		switch value {
		case "0":
			return `Full Refresh`, true
		case "1":
			return `Incremental Refresh`, true
		}

	case 266:
		switch value {
		case "N":
			return `Multiple entries per side per price allowed`, true
		case "Y":
			return `one book entry per side per price`, true
		}

	case 269:
		switch value {
		case "0":
			return `Bid`, true
		case "1":
			return `Offer`, true
		case "2":
			return `Trade`, true
		case "3":
			return `Index Value`, true
		case "4":
			return `Opening Price`, true
		case "5":
			return `Closing Price`, true
		case "6":
			return `Settlement Price`, true
		case "7":
			return `Trading Session High Price`, true
		case "8":
			return `Trading Session Low Price`, true
		case "9":
			return `Trading Session VWAP Price`, true
		}

	case 274:
		switch value {
		case "0":
			return `Plus Tick`, true
		case "1":
			return `Zero-Plus Tick`, true
		case "2":
			return `Minus Tick`, true
		case "3":
			return `Zero-Minus Tick`, true
		}

	case 276:
		switch value {
		case "A":
			return `Open / Active`, true
		case "B":
			return `Closed / Inactive`, true
		case "C":
			return `Exchange Best`, true
		case "D":
			return `Consolidated Best`, true
		case "E":
			return `Locked`, true
		case "F":
			return `Crossed`, true
		case "G":
			return `Depth`, true
		case "H":
			return `Fast Trading`, true
		case "I":
			return `Non-Firm`, true
		}

	case 277:
		switch value {
		case "A":
			return `Cash (only) Market`, true
		case "B":
			return `Average Price Trade`, true
		case "C":
			return `Cash Trade (same day clearing)`, true
		case "D":
			return `Next Day (only) Market`, true
		case "E":
			return `Opening / Reopening Trade Detail`, true
		case "F":
			return `Intraday Trade Detail`, true
		case "G":
			return `Rule 127 Trade (NYSE)`, true
		case "H":
			return `Rule 155 Trade (Amex)`, true
		case "I":
			return `Sold Last (late reporting)`, true
		case "J":
			return `Next Day Trade (next day clearing)`, true
		case "K":
			return `Opened (late report of opened trade)`, true
		case "L":
			return `Seller`, true
		case "M":
			return `Sold (out of sequence)`, true
		case "N":
			return `Stopped Stock (guarantee of price but does not execute the order)`, true
		}

	case 279:
		switch value {
		case "0":
			return `New`, true
		case "1":
			return `Change`, true
		case "2":
			return `Delete`, true
		}

	case 281:
		switch value {
		case "0":
			return `Unknown symbol`, true
		case "1":
			return `Duplicate MDReqID`, true
		case "2":
			return `Insufficient Bandwidth`, true
		case "3":
			return `Insufficient Permissions`, true
		case "4":
			return `Unsupported SubscriptionRequestType`, true
		case "5":
			return `Unsupported MarketDepth`, true
		case "6":
			return `Unsupported MDUpdateType`, true
		case "7":
			return `Unsupported AggregatedBook`, true
		case "8":
			return `Unsupported MDEntryType`, true
		}

	case 285:
		switch value {
		case "0":
			return `Cancelation / Trade Bust`, true
		case "1":
			return `Error`, true
		}

	case 286:
		switch value {
		case "0":
			return `Daily Open / Close / Settlement price`, true
		case "1":
			return `Session Open / Close / Settlement price`, true
		case "2":
			return `Delivery Settlement price`, true
		}

	case 291:
		switch value {
		case "1":
			return `Bankrupt`, true
		}

	case 292:
		switch value {
		case "A":
			return `Ex-Dividend`, true
		case "B":
			return `Ex-Distribution`, true
		case "C":
			return `Ex-Rights`, true
		case "D":
			return `New`, true
		case "E":
			return `Ex-Interest`, true
		}

	case 297:
		switch value {
		case "0":
			return `Accepted`, true
		case "1":
			return `Canceled for Symbol(s)`, true
		case "2":
			return `Canceled for Security Type(s)`, true
		case "3":
			return `Canceled for Underlying`, true
		case "4":
			return `Canceled All`, true
		case "5":
			return `Rejected`, true
		}

	case 298:
		switch value {
		case "1":
			return `Cancel for Symbol(s)`, true
		case "2":
			return `Cancel for Security Type(s)`, true
		case "3":
			return `Cancel for Underlying Symbol`, true
		case "4":
			return `Cancel for All Quotes`, true
		}

	case 300:
		switch value {
		case "1":
			return `Unknown symbol (Security)`, true
		case "2":
			return `Exchange (Security) closed`, true
		case "3":
			return `Quote Request exceeds limit`, true
		case "4":
			return `Too late to enter`, true
		case "5":
			return `Unknown Quote`, true
		case "6":
			return `Duplicate Quote`, true
		case "7":
			return `Invalid bid/ask spread`, true
		case "8":
			return `Invalid price`, true
		case "9":
			return `Not authorized to quote security`, true
		}

	case 301:
		switch value {
		case "0":
			return `No Acknowledgement (Default)`, true
		case "1":
			return `Acknowledge only negative or erroneous quotes`, true
		case "2":
			return `Acknowledge each quote messages`, true
		}

	case 303:
		switch value {
		case "1":
			return `Manual`, true
		case "2":
			return `Automatic`, true
		}

	case 321:
		switch value {
		case "0":
			return `Request Security identity and specifications`, true
		case "1":
			return `Request Security identity for the specifications provided (Name of the security is not supplied)`, true
		case "2":
			return `Request List Security Types`, true
		case "3":
			return `Request List Securities (Can be qualified with Symbol, SecurityType, TradingSessionID, SecurityExchange is provided then only list Securities for the specific type)`, true
		}

	case 323:
		switch value {
		case "1":
			return `Accept security proposal as is`, true
		case "2":
			return `Accept security proposal with revisions as indicated in the message`, true
		case "3":
			return `List of security types returned per request`, true
		case "4":
			return `List of securities returned per request`, true
		case "5":
			return `Reject security proposal`, true
		case "6":
			return `Can not match selection criteria`, true
		}

	case 325:
		switch value {
		case "N":
			return `Message is being sent as a result of a prior request`, true
		case "Y":
			return `Message is being sent unsolicited`, true
		}

	case 326:
		switch value {
		case "1":
			return `Opening Delay`, true
		case "10":
			return `Market On Close Imbalance Sell`, true
		case "12":
			return `No Market Imbalance`, true
		case "13":
			return `No Market On Close Imbalance`, true
		case "14":
			return `ITS Pre-Opening`, true
		case "15":
			return `New Price Indication`, true
		case "16":
			return `Trade Dissemination Time`, true
		case "17":
			return `Ready to trade (start of session)`, true
		case "18":
			return `Not Available for trading (end of session)`, true
		case "19":
			return `Not Traded on this Market`, true
		case "2":
			return `Trading Halt`, true
		case "20":
			return `Unknown or Invalid`, true
		case "3":
			return `Resume`, true
		case "4":
			return `No Open/No Resume`, true
		case "5":
			return `Price Indication`, true
		case "6":
			return `Trading Range Indication`, true
		case "7":
			return `Market Imbalance Buy`, true
		case "8":
			return `Market Imbalance Sell`, true
		case "9":
			return `Market On Close Imbalance Buy`, true
		}

	case 327:
		switch value {
		case "D":
			return `News Dissemination`, true
		case "E":
			return `Order Influx`, true
		case "I":
			return `Order Imbalance`, true
		case "M":
			return `Additional Information`, true
		case "P":
			return `News Pending`, true
		case "X":
			return `Equipment Changeover`, true
		}

	case 328:
		switch value {
		case "N":
			return `Halt was not related to a halt of the common stock`, true
		case "Y":
			return `Halt was due to common stock being halted`, true
		}

	case 329:
		switch value {
		case "N":
			return `Halt was not related to a halt of the related security`, true
		case "Y":
			return `Halt was due to related security being halted`, true
		}

	case 334:
		switch value {
		case "1":
			return `Cancel`, true
		case "2":
			return `Error`, true
		case "3":
			return `Correction`, true
		}

	case 338:
		switch value {
		case "1":
			return `Electronic`, true
		case "2":
			return `Open Outcry`, true
		case "3":
			return `Two Party`, true
		}

	case 339:
		switch value {
		case "1":
			return `Testing`, true
		case "2":
			return `Simulated`, true
		case "3":
			return `Production`, true
		}

	case 340:
		switch value {
		case "1":
			return `Halted`, true
		case "2":
			return `Open`, true
		case "3":
			return `Closed`, true
		case "4":
			return `Pre-Open`, true
		case "5":
			return `Pre-Close`, true
		}

	case 347:
		switch value {
		case "EUC-JP":
			return `(for using EUC)`, true
		case "ISO-2022-JP":
			return `(for using JIS)`, true
		case "Shift_JIS":
			return `(for using SJIS)`, true
		case "UTF-8":
			return `(for using Unicode)`, true
		}

	case 368:
		switch value {
		case "1":
			return `Unknown symbol (Security)`, true
		case "2":
			return `Exchange (Security) closed`, true
		case "3":
			return `Quote exceeds limit`, true
		case "4":
			return `Too late to enter`, true
		case "5":
			return `Unknown Quote`, true
		case "6":
			return `Duplicate Quote`, true
		case "7":
			return `Invalid bid/ask spread`, true
		case "8":
			return `Invalid price`, true
		case "9":
			return `Not authorized to quote security`, true
		}

	case 373:
		switch value {
		case "0":
			return `Invalid tag number`, true
		case "1":
			return `Required tag missing`, true
		case "10":
			return `SendingTime accuracy problem`, true
		case "11":
			return `Invalid MsgType`, true
		case "2":
			return `Tag not defined for this message type`, true
		case "3":
			return `Undefined Tag`, true
		case "4":
			return `Tag specified without a value`, true
		case "5":
			return `Value is incorrect (out of range) for this tag`, true
		case "6":
			return `Incorrect data format for value`, true
		case "7":
			return `Decryption problem`, true
		case "8":
			return `Signature problem`, true
		case "9":
			return `CompID problem`, true
		}

	case 374:
		switch value {
		case "C":
			return `Cancel`, true
		case "N":
			return `New`, true
		}

	case 377:
		switch value {
		case "N":
			return `Was not solicited`, true
		case "Y":
			return `Was solcitied`, true
		}

	case 378:
		switch value {
		case "0":
			return `GT Corporate action`, true
		case "1":
			return `GT renewal / restatement (no corporate action)`, true
		case "2":
			return `Verbal change`, true
		case "3":
			return `Repricing of order`, true
		case "4":
			return `Broker option`, true
		case "5":
			return `Partial decline of OrderQty (e.g. exchange-initiated partial cancel)`, true
		}

	case 380:
		switch value {
		case "0":
			return `Other`, true
		case "1":
			return `Unkown ID`, true
		case "2":
			return `Unknown Security`, true
		case "3":
			return `Unsupported Message Type`, true
		case "4":
			return `Application not available`, true
		case "5":
			return `Conditionally Required Field Missing`, true
		}

	case 385:
		switch value {
		case "R":
			return `Receive`, true
		case "S":
			return `Send`, true
		}

	case 388:
		switch value {
		case "0":
			return `Related to displayed price`, true
		case "1":
			return `Related to market price`, true
		case "2":
			return `Related to primary price`, true
		case "3":
			return `Related to local primary price`, true
		case "4":
			return `Related to midpoint price`, true
		case "5":
			return `Related to last trade price`, true
		}

	case 409:
		switch value {
		case "1":
			return `5 day moving average`, true
		case "2":
			return `20 day moving average`, true
		case "3":
			return `Normal Market Size`, true
		case "4":
			return `Other`, true
		}

	case 411:
		switch value {
		case "N":
			return `False`, true
		case "Y":
			return `True`, true
		}

	case 414:
		switch value {
		case "1":
			return `BuySide explicitly requests status using StatusRequest (Default) The sell-side firm can however, send a DONE status List Status Response in an unsolicited fashion`, true
		case "2":
			return `SellSide periodically sends status using ListStatus. Period optionally specified in ProgressPeriod`, true
		case "3":
			return `Real-time execution reports (to be discouraged)`, true
		}

	case 416:
		switch value {
		case "1":
			return `Net`, true
		case "2":
			return `Gross`, true
		}

	case 418:
		switch value {
		case "A":
			return `Agency`, true
		case "G":
			return `VWAP Guarantee`, true
		case "J":
			return `Guaranteed Close`, true
		case "R":
			return `Risk Trade`, true
		}

	case 419:
		switch value {
		case "2":
			return `Closing Price at morning session`, true
		case "3":
			return `Closing Price`, true
		case "4":
			return `Current price`, true
		case "5":
			return `SQ`, true
		case "6":
			return `VWAP through a day`, true
		case "7":
			return `VWAP through a morning session`, true
		case "8":
			return `VWAP through an afternoon session`, true
		case "9":
			return `VWAP through a day except YORI`, true
		case "A":
			return `VWAP through a morning session except YORI`, true
		case "B":
			return `VWAP through an afternoon session except YORI`, true
		case "C":
			return `Strike`, true
		case "D":
			return `Open`, true
		case "Z":
			return `Others`, true
		}

	case 423:
		switch value {
		case "1":
			return `Percentage`, true
		case "2":
			return `per share (e.g. cents per share)`, true
		case "3":
			return `Fixed Amount (absolute value)`, true
		}

	case 427:
		switch value {
		case "0":
			return `book out all trades on day of execution`, true
		case "1":
			return `accumulate executions until order is filled or expires`, true
		case "2":
			return `accumulate until verbally notified otherwise`, true
		}

	case 430:
		switch value {
		case "1":
			return `Net`, true
		case "2":
			return `Gross`, true
		}

	case 433:
		switch value {
		case "1":
			return `Immediate`, true
		case "2":
			return `Wait for Execute Instruction (e.g. a List Execute message or phone call before proceeding with execution of the list)`, true
		}

	case 434:
		switch value {
		case "1":
			return `Order Cancel Request`, true
		case "2":
			return `Order Cancel/Replace Request`, true
		}

	case 442:
		switch value {
		case "1":
			return `Single Security (default if not specified)`, true
		case "2":
			return `Individual leg of a multi-leg security`, true
		case "3":
			return `Multi-leg security`, true
		}

	}
	return "", false
}
