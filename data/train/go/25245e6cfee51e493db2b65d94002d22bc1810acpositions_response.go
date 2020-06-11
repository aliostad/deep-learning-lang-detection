package robinhood

import (
	"time"
)

type Position struct {
	Account            string    `json:"account"`
	IntradayQuantity   string    `json:"intraday_quantity"`
	SharesHeldForSells string    `json:"shares_held_for_sells"`
	URL                string    `json:"url"`
	CreatedAt          time.Time `json:"created_at"`
	UpdatedAt          time.Time `json:"updated_at"`
	SharesHeldForBuys  string    `json:"shares_held_for_buys"`
	AverageBuyPrice    string    `json:"average_buy_price"`
	Instrument         string    `json:"instrument"`
	Quantity           string    `json:"quantity"`
}

type PositionsResponse struct {
	Previous interface{} `json:"previous"`
	Results  []Position  `json:"results"`
	Next     interface{} `json:"next"`
}
