package goavanza

import (
	"strings"
	"testing"
)

var avanza *Client

func init() {
	avanza = New()
	err := avanza.Authenticate("{username}", "{password}")
	if err != nil {
		panic(err.Error())
	}
}

func TestGetPositions(t *testing.T) {
	portfolio, err := avanza.GetPositions()
	if err != nil {
		t.Error(err.Error())
	}
	for index, elem := range portfolio.InstrumentPositions {
		t.Log(index, elem.InstrumentType)
	}
}

func TestGetOverview(t *testing.T) {
	portfolio, err := avanza.GetOverview()
	if err != nil {
		t.Error("Failed retrieving overview ", err)
	}
	if portfolio.Accounts == nil {
		t.Error("Failed retrieving overview")
	}
}

func TestGetAccountOverview(t *testing.T) {
	portfolio, err := avanza.GetOverview()
	if portfolio.Accounts == nil || err != nil {
		t.Error("No accounts available")
	}

	for _, acc := range portfolio.Accounts {
		_, err := avanza.GetAccountOverview(acc.AccountID)
		if err != nil {
			t.Error("Failed retrieving account overview for account ", acc.AccountID)
		}
	}
}

func TestGetStock(t *testing.T) {
	portfolio, err := avanza.GetPositions()
	if err != nil {
		t.Error(err.Error())
	}

	for _, instrumentPosition := range portfolio.InstrumentPositions {
		if instrumentPosition.InstrumentType == strings.ToUpper(StockType) {
			for _, position := range instrumentPosition.Positions {
				stock, err := avanza.GetStock(position.OrderbookID)
				if err != nil {
					t.Error(err.Error())
				}
				t.Log(stock.Name, ": ", stock.LastPrice)
			}
		}
	}
}

func TestGetFund(t *testing.T) {
	portfolio, err := avanza.GetPositions()
	if err != nil {
		t.Error(err.Error())
	}

	for _, instrumentPosition := range portfolio.InstrumentPositions {
		if instrumentPosition.InstrumentType == strings.ToUpper(FundType) {
			for _, position := range instrumentPosition.Positions {
				fund, err := avanza.GetFund(position.OrderbookID)
				if err != nil {
					t.Error(err.Error())
				}
				t.Log(fund.Name)
			}
		}
	}
}

func TestGetOrderbook(t *testing.T) {
	portfolio, err := avanza.GetPositions()
	if err != nil {
		t.Error(err.Error())
	}

	for _, instrumentPosition := range portfolio.InstrumentPositions {
		for _, position := range instrumentPosition.Positions {
			orderbook, err := avanza.GetOrderbook(position.OrderbookID, instrumentPosition.InstrumentType)
			if err != nil {
				t.Error(err.Error())
			}
			switch instrumentPosition.InstrumentType {
			case "FUND":
				t.Log(orderbook.(OrderbookFund).Fund.Name)
			case "STOCK":
				t.Log(orderbook.(OrderbookStock).Orderbook.Name)
			}

		}
	}

}
