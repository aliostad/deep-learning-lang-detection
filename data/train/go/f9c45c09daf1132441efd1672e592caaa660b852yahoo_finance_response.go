package models

type YahooFinanceResponse struct {
	Chart YahooFinanceChart `json:"chart"`
}

type YahooFinanceChart struct {
	Result []YahooFinanceResult `json:"result"`
	Error  interface{}          `json:"error"`
}

type YahooFinanceResult struct {
	Meta       YahooFinanceMeta       `json:"meta"`
	Timestamp  []int64                `json:"timestamp"`
	Indicators YahooFinanceIndicators `json:"indicators"`
}

type YahooFinanceMeta struct {
	Currency       string `json:"currency"`
	Symbol         string `json:"symbol"`
	InstrumentType string `json:"instrumentType"`
}

type YahooFinanceIndicators struct {
	Quote []YahooFinanceQuote `json:"quote"`
}

type YahooFinanceQuote struct {
	High   []float64 `json:"high"`
	Open   []float64 `json:"open"`
	Low    []float64 `json:"low"`
	Close  []float64 `json:"close"`
	Volume []float64 `json:"volume"`
}
