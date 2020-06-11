package main

import (
    "time"
)

var resolutions = map[string]time.Duration{
    "SECOND": time.Second,
    "MINUTE": time.Minute,
    "MINUTE_2": 2*time.Minute,
    "MINUTE_5": 5*time.Minute,
    "MINUTE_10": 10*time.Minute,
    "MINUTE_15": 15*time.Minute,
    "MINUTE_30": 30*time.Minute,
    "HOUR": time.Hour,
    "HOUR_2": 2*time.Hour,
    "HOUR_3": 3*time.Hour,
    "HOUR_4": 4*time.Hour,
    "DAY": 24*time.Hour,
}

type Instrument struct {
    Id    string `json:"id"`
    Links Links  `json:"links"`
}

type Instruments []Instrument

type Candle struct {
	Time       time.Time `json:"time"`
	OpenPrice  Quote     `json:"openPrice"`
	ClosePrice Quote     `json:"closePrice"`
	LowPrice   Quote     `json:"lowPrice"`
	HighPrice  Quote     `json:"highPrice"`
}

type Candles []Candle

type Quote struct {
	Ask float32	`json:"ask"`
	Bid float32	`json:"bid"`
}

type CandlesResponse struct {
	Instrument Instrument `json:"instrument"`
	Resolution string     `json:"resolution"`
	StartDate  time.Time  `json:"startDate"`
	EndDate    time.Time  `json:"endDate"`
	Candles    Candles    `json:"candles"`
}