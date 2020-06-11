package invt

import (
	"strconv"

	"time"

	"github.com/apourchet/investment/lib/utils"
	"github.com/apourchet/investment/protos"
)

type Candle struct {
	InstrumentId string
	Timestamp    time.Time
	Open         float64
	High         float64
	Low          float64
	Close        float64
}

type OandaCandle struct {
	InstrumentId string
	Timestamp    time.Time
	OpenBid      float64
	OpenAsk      float64
	HighBid      float64
	LowBid       float64
	HighAsk      float64
	LowAsk       float64
	CloseBid     float64
	CloseAsk     float64
}

type Quote struct {
	InstrumentId string
	Timestamp    time.Time
	Ask          float64
	Bid          float64
}

type QuoteContext map[string]*Quote

func (qc *QuoteContext) Get(instrumentId string) *Quote {
	return (*qc)[instrumentId]
}

func (q *Quote) Proto() *protos.Quote {
	q1 := &protos.Quote{}
	q1.InstrumentId = q.InstrumentId
	q1.Ask = q.Ask
	q1.Bid = q.Bid
	q1.Time = q.Timestamp.Format(time.RFC3339)
	return q1
}

func (c *Candle) Proto() *protos.Candle {
	c1 := &protos.Candle{}
	c1.InstrumentId = c.InstrumentId
	c1.Close = c.Close
	c1.High = c.High
	c1.Low = c.Low
	c1.Open = c.Open
	c1.Time = c.Timestamp.Format(time.RFC3339)
	return c1
}

func CandleFromProto(c *protos.Candle) *Candle {
	c1 := &Candle{}
	c1.High = c.High
	c1.Low = c.Low
	c1.Open = c.Open
	c1.Close = c.Close
	c1.InstrumentId = c.InstrumentId
	c1.Timestamp, _ = time.Parse(time.RFC3339, c.Time)
	return c1
}

func QuoteFromProto(q *protos.Quote) *Quote {
	q1 := &Quote{}
	q1.Ask = q.Ask
	q1.Bid = q.Bid
	q1.InstrumentId = q.InstrumentId
	q1.Timestamp, _ = time.Parse(time.RFC3339, q.Time)
	return q1
}

func (q *Quote) Price(side string) float64 {
	if side == SIDE_BUY_STR {
		return q.Ask
	}
	return q.Bid
}

func ParseCandleFromRecord(instrumentId string, record []string) *Candle {
	c := &Candle{}
	v1, err1 := strconv.ParseFloat(record[2], 64)
	v2, err2 := strconv.ParseFloat(record[3], 64)
	v3, err3 := strconv.ParseFloat(record[4], 64)
	v4, err4 := strconv.ParseFloat(record[5], 64)

	if err1 != nil || err2 != nil || err3 != nil || err4 != nil {
		return nil
	}

	c.InstrumentId = instrumentId
	c.Timestamp, _ = utils.ParseDate(record)
	c.Open = v1
	c.High = v2
	c.Low = v3
	c.Close = v4
	return c
}

// TODO Add volume information to candle?
func ParseCandleFromOandaRecord(instrumentId string, record []string) *OandaCandle {
	c := &OandaCandle{}
	v1, err1 := strconv.ParseFloat(record[2], 64)
	v2, err2 := strconv.ParseFloat(record[3], 64)
	v3, err3 := strconv.ParseFloat(record[4], 64)
	v4, err4 := strconv.ParseFloat(record[5], 64)
	v5, err3 := strconv.ParseFloat(record[6], 64)
	v6, err4 := strconv.ParseFloat(record[7], 64)
	v7, err3 := strconv.ParseFloat(record[8], 64)
	v8, err4 := strconv.ParseFloat(record[9], 64)

	if err1 != nil || err2 != nil || err3 != nil || err4 != nil {
		return nil
	}

	c.InstrumentId = instrumentId
	c.Timestamp, _ = utils.ParseDate(record)
	c.OpenBid = v1
	c.OpenAsk = v2
	c.HighBid = v3
	c.HighAsk = v4
	c.LowBid = v5
	c.LowAsk = v6
	c.CloseBid = v7
	c.CloseAsk = v8
	return c
}

func ParseQuoteFromOandaRecord(instrumentId string, record []string) *Quote {
	q := &Quote{}
	q.InstrumentId = instrumentId
	v, err := strconv.ParseFloat(record[2], 64)
	q.Bid = v
	if err != nil {
		return nil
	}
	v, err = strconv.ParseFloat(record[3], 64)
	q.Ask = v
	if err != nil {
		return nil
	}
	q.Timestamp, _ = utils.ParseDate(record)
	return q
}

func ParseQuoteFromRecord(instrumentId string, record []string) *Quote {
	q := &Quote{}
	q.InstrumentId = instrumentId
	v, err := strconv.ParseFloat(record[2], 64)
	q.Bid = v
	if err != nil {
		return nil
	}

	q.Ask, err = strconv.ParseFloat(record[2], 64)
	// TODO fix this
	q.Ask += 0.00025 // Adjust for arbitrary spread
	if err != nil {
		return nil
	}
	q.Timestamp, _ = utils.ParseDate(record)
	return q
}
