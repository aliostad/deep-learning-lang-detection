package market

import (
	oanda "github.com/santegoeds/oanda"
)

type Tick struct {
	Symbol, Time string
	Ask, Bid     float64
}

func (m *Market) LoadPriceServer(symbols []string) error {
	var err error = nil

	// Loading price server
	m.priceServer, err = m.client.NewPriceServer(symbols...)
	if err != nil {
		return err
	}

	m.symbols = symbols
	return err
}

func (m *Market) LaunchPriceServer(channel chan *Tick) error {
	m.priceServer.ConnectAndHandle(func(instrument string, tick oanda.PriceTick) {
		var formatedTick Tick
		formatedTick.Symbol = instrument
		formatedTick.Time = string(tick.Time)
		formatedTick.Ask = tick.Ask
		formatedTick.Bid = tick.Bid
		select {
		case channel <- &formatedTick:
		default:
		}
	})

	return nil
}

func (m *Market) Symbols() []string {
	return m.symbols
}
