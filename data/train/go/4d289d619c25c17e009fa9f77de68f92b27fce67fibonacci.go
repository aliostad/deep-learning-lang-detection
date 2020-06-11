package oanda

import "fmt"

func (c *Client) HighAskCandles(instrument string, granularity Granularity,
args ...CandlesArg) (*HighAskCandles, error) {

	u, err := c.newCandlesURL(instrument, granularity, "bidask", args...)
	if err != nil {
		return nil, err
	}
	candles := HighAskCandles{}
	if err = getAndDecode(c, u.String(), &candles); err != nil {
		return nil, err
	}
	return &candles, nil
}

type HighAskCandle struct {
	HighAsk  float64 `json:"highAsk"`
}

type HighAskCandles struct {
	Candles     []HighAskCandle `json:"candles"`
}

func (c HighAskCandles) String() string {
	return fmt.Sprintf("HighAskCandles{Candles: %v}", c.Candles)
}