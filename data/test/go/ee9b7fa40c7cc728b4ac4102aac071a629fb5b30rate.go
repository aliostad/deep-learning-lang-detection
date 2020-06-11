package data

import (
	"time"
)

type InstrumentsParam struct {
	AccountId   int64  `json:"accountId"`
	Fields      string `json:"fields"`
	Instruments string `json:"instruments"`
}

type Instruments struct {
	Instruments []Instrument `json:"instruments"`
}

type Instrument struct {
	Instrument      string  `json:"instrument"`
	DisplayName     string  `json:"displayName"`
	pip             float64 `json:"pip"`
	MaxTradeUnits   int64   `json:"maxTradeUnits"`
	Precision       float64 `json:"precision"`
	MaxTrailingStop int     `json:"maxTrailingStop"`
	MinTrailingStop int     `json:"minTrailingStop"`
	MarginRate      float64 `json:"marginRate"`
	Halted          bool    `json:"halted"`
	InterestRate    float64 `json:"interestRate"`
}

type PricesParam struct {
	Instruments string    `json:"instruments"`
	Since       time.Time `json:"since"`
}

type Prices struct {
	Prices []Price `json:"prices"`
}

type Price struct {
	Instrument string    `json:"instrument"`
	Time       time.Time `json:"time"`
	Bid        float64   `json:"bid"`
	Ask        float64   `json:"ask"`
	Status     string    `json:"status"`
}

type CandlesParam struct {
	Instrument        string    `json:"instrument"`
	Granularity       string    `json:"granularity"`
	Count             int       `json:"count"`
	Start             time.Time `json:"start"`
	End               time.Time `json:"end"`
	CandleFormat      string    `json:"candleFormat"`
	IncludeFirst      string    `json:"includeFirst"`
	DailyAlignment    int       `json:"dailyAlignment"`
	AlignmentTimezone string    `json:"alignmentTimezone"`
	WeeklyAlignment   string    `json:"weeklyAlignment"`
}

type Candles struct {
	Instrument  string   `json:"instrument"`
	Granularity string   `json:"granularity"`
	Candles     []Candle `json:"candles"`
}

type Candle struct {
	Time     time.Time `json:"time"`
	OpenBid  float64   `json:"openBid"`
	OpenMid  float64   `json:"openMid"`
	OpenAsk  float64   `json:"openAsk"`
	HighBid  float64   `json:"highBid"`
	HighMid  float64   `json:"highMid"`
	HighAsk  float64   `json:"highAsk"`
	LowBid   float64   `json:"lowBid"`
	LowMid   float64   `json:"lowMid"`
	LowAsk   float64   `json:"lowAsk"`
	CloseBid float64   `json:"closeBid"`
	CloseMid float64   `json:"closeMid"`
	CloseAsk float64   `json:"closeAsk"`
	Volume   float64   `json:"volume"`
	Complete bool      `json:"complete"`
}
