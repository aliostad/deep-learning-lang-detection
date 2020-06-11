package models

type StockInfo struct {
	AskPrice                    string `json:"ask_price"`
	AskSize                     int    `json:"ask_size"`
	BidPrice                    string `json:"bid_price"`
	BidSize                     int    `json:"bid_size"`
	LastTradePrice              string `json:"last_trade_price"`
	LastExtentedHoursTradePrice string `json:"last_extented_hours_trade_price"`
	PreviousClose               string `json:"previous_close"`
	AdjustedPreviousClose       string `json:"adjusted_previous_close"`
	PreviousCloseDate           string `json:"previous_close_date"`
	Symbol                      string `json:"symbol"`
	TradingHalted               bool   `json:"trading_halted"`
	LastTradePriceSource        string `json:"last_trade_price_source"`
	UpdatedAt                   string `json:"updated_at"`
	Instrument                  string `json:"instrument"`
}

func (s StockInfo) String() string {
  return s.Symbol + ", " + s.LastTradePrice
}
