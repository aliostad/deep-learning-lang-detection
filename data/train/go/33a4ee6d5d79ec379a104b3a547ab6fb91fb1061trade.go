package data

import (
	"time"
)

type GetTradesParam struct {
	MaxId      int64  `json:"maxId"`
	Count      int    `json:"count"`
	Instrument string `json:"instrument"`
	Ids        string `json:"ids"`
}

type GetTrades struct {
	Trades []Trade `json:"trades"`
}

type Trade struct {
	Id             int64     `json:"id"`
	Units          int       `json:"units"`
	Side           string    `json:"side"`
	Instrument     string    `json:"instrument"`
	Time           time.Time `json:"time"`
	Price          float64   `json:"price"`
	TakeProfit     float64   `json:"takeProfit"`
	StopLoss       float64   `json:"stopLoss"`
	TrailingStop   int       `json:"trailingStop"`
	TrailingAmount float64   `json:"trailingAmount"`
}

type PatchTradeParam struct {
	StopLoss     float64 `json:"stopLoss"`
	TakeProfit   float64 `json:"takeProfit"`
	TrailingStop int     `json:"trailingStop"`
}

type CloseTradeResult struct {
	Id         int64     `json:"id"`
	Price      float64   `json:"price"`
	Instrument string    `json:"instrument"`
	Profit     float64   `json:"profit"`
	Side       string    `json:"side"`
	Time       time.Time `json:"time"`
}
