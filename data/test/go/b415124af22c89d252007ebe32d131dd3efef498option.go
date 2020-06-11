package bread

import (
	"math"
)

// Position is whether this is a call or put.
type Position int

const (
	Call Position = iota
	Put
)

// Exercise determines when the option can be exercised.
type Exercise int

const (
	American Exercise = iota
	European
)

// Instrument is the type of option being priced.
type Instrument struct {
	P  Position
	E  Exercise
	Pr float64 // equity price at purchase
	S  float64 // strike price
}

// BinSimParams are parameters use to price an option using the Binomial pricing model.
type BinSimParams struct {
	R float64 // interest rate
	U float64 // up step
	D float64 // down step
	N int     // number of time steps
}

// Price prices option using a Binomial tree.
func (params *BinSimParams) Price(inst Instrument) float64 {
	a := make([]float64, params.N)
	for i, _ := range a {
		t := float64(params.N - i)
		h := float64(i)
		a[i] = math.Pow(params.U, h) * math.Pow(params.D, t)
	}
	equityPrice := 2.0
	return math.Pow(equityPrice, 2)
}
