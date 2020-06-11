package invt

func Buy(a *Account, instrumentId string, units int32, price float64) {
	Trade(a, instrumentId, units, price, SIDE_BUY)
}

func Sell(a *Account, instrumentId string, units int32, price float64) {
	Trade(a, instrumentId, units, price, SIDE_SELL)
}

func TradeQuote(a *Account, q *Quote, units int32, side int) {
	if side == SIDE_BUY {
		Trade(a, q.InstrumentId, units, q.Ask, SIDE_BUY)
	} else {
		Trade(a, q.InstrumentId, units, q.Bid, SIDE_SELL)
	}
}

func Trade(a *Account, instrumentId string, units int32, price float64, side int) {
	pos := &OpenPosition{instrumentId, units, price, side}
	if other, ok := a.OpenPositions[pos.InstrumentId]; ok {
		mergePositions(a, pos, other)
	} else {
		openNewPosition(a, pos)
	}
}

func closePosition(a *Account, pos *OpenPosition, price float64) {
	a.Balance += pos.Value()                                         // Gain value of position
	pl := float64(pos.Side) * pos.FloatUnits() * (price - pos.Price) // Gain delta
	a.Balance += pl
	a.RealizedPl += pl
	a.Stats.AddTrade(pl)
}

func mergePositions(a *Account, from, to *OpenPosition) {
	if from.Side == to.Side {
		a.Balance -= from.Value()
		totalUnits := from.Units + to.Units
		totalValue := from.Value() + to.Value()
		avgPrice := totalValue / float64(totalUnits)

		to.Price = avgPrice
		to.Units = totalUnits
	} else {
		if from.Units == to.Units {
			closePosition(a, to, from.Price)
			delete(a.OpenPositions, to.InstrumentId)
		} else if to.Units > from.Units {
			toclose := to.SplitPosition(from.Units)
			closePosition(a, toclose, from.Price)
		} else if from.Units > to.Units {
			closePosition(a, to, from.Price)
			delete(a.OpenPositions, to.InstrumentId)
			from.Units -= to.Units
			openNewPosition(a, from)
		}
	}
}

func openNewPosition(a *Account, pos *OpenPosition) {
	a.Balance -= pos.Value()
	a.OpenPositions[pos.InstrumentId] = pos
}
