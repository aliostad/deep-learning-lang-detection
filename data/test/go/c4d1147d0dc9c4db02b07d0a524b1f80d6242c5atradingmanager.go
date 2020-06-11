package invt

// Everything from trading.go will eventually move here

type TradingManager struct {
	account    *Account
	tpslOrders map[string]TPSLOrder // TODO GC those
}

// Take Profit / Stop Loss Order struct
type TPSLOrder struct {
	instrumentId  string
	price         float64
	originalPrice float64
	expired       bool // For GC
	// TODO expiry date
}

func NewTradingManager(account *Account) *TradingManager {
	tm := &TradingManager{}
	tm.account = account
	tm.tpslOrders = make(map[string]TPSLOrder, 0)
	return tm
}

func (tm *TradingManager) Start() error {
	return nil
}

func (tm *TradingManager) OnData(record []string, format DataFormat) {
	var q *Quote

	if format == DATAFORMAT_QUOTE {
		q = ParseQuoteFromRecord("EURUSD", record)
	} else if format == DATAFORMAT_CANDLE {
		c := ParseCandleFromRecord("EURUSD", record)
		q = &Quote{}
		q.Bid = c.Close
		q.Ask = c.Close + 0.00025
		q.InstrumentId = c.InstrumentId
		q.Timestamp = c.Timestamp
	}

	tm.OnQuote(q)
}

func (tm *TradingManager) OnQuote(q *Quote) {
	for iid, tpsl := range tm.tpslOrders {
		if tpsl.expired {
			continue
		}
		pos, ok := tm.account.OpenPositions[iid]
		if ok {
			nowPrice := q.Price(StringOfSide(pos.Side))
			if sign(tpsl.price-tpsl.originalPrice) == sign(nowPrice-tpsl.price) || tpsl.price == nowPrice {
				tm.ClosePosition(iid, nowPrice)
			}
		}
	}
}

func (tm *TradingManager) OnEnd() {}

// These two should behave the same way since it it just about closing the position
// At a certain point in time.
func (tm *TradingManager) TakeProfit(instrumentId string, price float64, originalPrice float64) {
	order := TPSLOrder{instrumentId, price, originalPrice, false}
	tm.tpslOrders[instrumentId] = order
}

func (tm *TradingManager) StopLoss(instrumentId string, price float64, originalPrice float64) {
	order := TPSLOrder{instrumentId, price, originalPrice, false}
	tm.tpslOrders[instrumentId] = order
}

func (tm *TradingManager) ClosePosition(instrumentId string, price float64) {
	pos := tm.account.OpenPositions[instrumentId]
	tm.account.Balance += pos.Value()                                // Gain value of position
	pl := float64(pos.Side) * pos.FloatUnits() * (price - pos.Price) // Gain delta
	tm.account.Balance += pl
	tm.account.RealizedPl += pl
	tm.account.Stats.AddTrade(pl)
	delete(tm.account.OpenPositions, instrumentId)
}

func (tm *TradingManager) CancelTPSL(instrumentId string) {
	delete(tm.tpslOrders, instrumentId)
}

func sign(f float64) int {
	if f > 0 {
		return 1
	}
	return -1
}
