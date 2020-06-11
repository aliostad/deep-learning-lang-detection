package main

import . "github.com/sunwangme/bfgo/api/bfgateway"
import . "github.com/sunwangme/bfgo/api/bfdatafeed"
import . "github.com/oneywang/bfgo/qite"

type MyScenario struct {
	*Strategy
	barSize int
}

func NewScenario() *MyScenario {
	return &MyScenario{Strategy: NewStrategy(), barSize: 300}
}

var barSize = 300

func RunScenario() {
	instrument1 := Instrument{Symbol: "rb1610", Exchange: "SHFE"}
	instrument2 := Instrument{Symbol: "rb1710", Exchange: "SHFE"}

	strategy := Strategy{}
	strategy.AddInstrument(instrument1)
	strategy.AddInstrument(instrument2)

	StartStrategy(strategy)
}
