package robinhood

type InstrumentsResponse struct {
	Previous interface{}  `json:"previous"`
	Results  []Instrument `json:"results"`
	Next     interface{}  `json:"next"`
}

type Instrument struct {
	Splits             string `json:"splits"`
	MarginInitialRatio string `json:"margin_initial_ratio"`
	URL                string `json:"url"`
	Quote              string `json:"quote"`
	Symbol             string `json:"symbol"`
	BloombergUnique    string `json:"bloomberg_unique"`
	ListDate           string `json:"list_date"`
	Fundamentals       string `json:"fundamentals"`
	State              string `json:"state"`
	DayTradeRatio      string `json:"day_trade_ratio"`
	Tradeable          bool   `json:"tradeable"`
	MaintenanceRatio   string `json:"maintenance_ratio"`
	ID                 string `json:"id"`
	Market             string `json:"market"`
	Name               string `json:"name"`
}
