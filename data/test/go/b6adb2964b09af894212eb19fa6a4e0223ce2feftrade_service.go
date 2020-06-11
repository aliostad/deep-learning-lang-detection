package robinhood

import (
	"fmt"
	"net/http"
	"net/url"
	"strconv"
)

type TradeParams struct {
	AccountUrl    string
	InstrumentUrl string
	Symbol        string
	Quantity      int
	OrderType     string
	Price         float64
}

type TradeService service

func (s *TradeService) PlaceTrade(symbol, orderType string, quantity int) (*OrderResponse, *http.Response, error) {
	c := s.client
	ar, _, err := c.Accounts.ListAccounts()
	if err != nil {
		return nil, nil, err
	}
	accountUrl := ar.Results[0].URL

	i, _, err := c.Instruments.GetInstrumentFromSymbol(symbol)
	if err != nil {
		return nil, nil, err
	}
	instrumentUrl := i.URL

	q, _, err := c.Quotes.GetQuoteFromInstrument(i)
	if err != nil {
		return nil, nil, err
	}
	lastPrice, _ := strconv.ParseFloat(q.LastTradePrice, 64)
	var price float64
	if orderType == "buy" {
		price = Round(lastPrice+0.2, 2)
	} else {
		price = Round(lastPrice-0.2, 2)
	}

	tp := &TradeParams{
		AccountUrl:    accountUrl,
		InstrumentUrl: instrumentUrl,
		Symbol:        symbol,
		Quantity:      quantity,
		OrderType:     orderType,
		Price:         price,
	}
	return s.placeTrade(tp)
}

func (s *TradeService) placeTrade(tp *TradeParams) (*OrderResponse, *http.Response, error) {
	params := url.Values{}

	params.Add("account", tp.AccountUrl)
	params.Add("instrument", tp.InstrumentUrl)
	params.Add("price", fmt.Sprintf("%v", tp.Price))
	params.Add("quantity", strconv.Itoa(tp.Quantity))
	params.Add("side", tp.OrderType)
	params.Add("symbol", tp.Symbol)
	params.Add("time_in_force", "gfd")
	params.Add("trigger", "immediate")
	params.Add("type", "market")

	or := &OrderResponse{}
	resp, err := s.client.Post("orders/", params, or)

	if err != nil {
		return nil, resp, err
	}

	return or, resp, err
}
