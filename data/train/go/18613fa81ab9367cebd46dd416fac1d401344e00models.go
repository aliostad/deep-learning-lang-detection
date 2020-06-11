package candles

type CandleResponse struct {
	Instrument  string   `json:"instrument"`
	Granularity string   `json:"granularity"`
	Candles     []Candle `json:"candles"`
}

type Candle struct {
	Complete bool             `json:"complete"`
	Volume   int64            `json:"volume"`
	Time     string           `json:"time"`
	Bid      *CandleStickData `json:"bid"`
	Ask      *CandleStickData `json:"ask"`
	Mid      *CandleStickData `json:"mid"`
}

type CandleStickData struct {
	Open  string `json:"o"`
	High  string `json:"h"`
	Low   string `json:"l"`
	Close string `json:"c"`
}
