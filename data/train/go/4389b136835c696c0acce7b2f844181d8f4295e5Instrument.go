package lib

import (
	_ "time"
)

type Instrument struct {
	Currency   string `json: "Currency"`
	MarketID   string `json: "MarketID"`
	Identifier string `json: "Identifier"`
}

type Option struct {
	Instrument
	Underlier      int     `json: "Underlier"`
	PutorCall      rune    `json: "PutorCall"`
	ExcerciseStyle rune    `json: "ExcerciseStyle"`
	Strike         float64 `json: "Strike"`
	Units          int     `json: "Units"`
	StartDate      string  `json: "StartDate"`
	EndDate        string  `json: "EndDate"`
	Multiplier     float64 `json: "Multiplier"`
	DeliveryType   rune    `json: "DeliveryType"`
}

type Futures struct {
	Instrument
	CurrentRootSymbol       string  `json: "CurrentRootSymbol"`
	ExpirationDate          string  `json: "ExpirationDate"`
	Underlier               int     `json: "Underlier"`
	SpreadTicketSize        float64 `json: "SpreadTicketSize"`
	DeliveryType            rune    `json: "DeliveryType"`
	InitialMargin           float64 `json: "InitialMargin"`
	MaintenanceMargin       float64 `json: "MaintenanceMargin"`
	MemberInitialMargin     float64 `json: "MemberInitialMargin"`
	MemberMaintenanceMargin float64 `json: "MemberMaintenanceMargin"`
}
