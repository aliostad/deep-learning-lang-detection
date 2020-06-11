package main

import (
	"Tuning"
	"fmt"
)

//this is an additional type that satisfies and therefore implements the TuningInterface
type Guitar struct {
	InstrumentName string
	Strings        []string
	Tunes          []int
	//*Tuning.Instrument
}

func (g *Guitar) TuneUp() {
	//own implementation, normally we must return the same as methods in Tuning return
	fmt.Println("keyboard sucks")
}

func (g *Guitar) TuneDown() {
	fmt.Println("drums sucks as well")
}

func main() {
	//Object of type Instrument
	g1, _ := Tuning.CreateInstrument()
	fmt.Println(g1)
	fmt.Println(fmt.Sprintf("%T", g1)) //Tuning.Instrument

	//Object initialisation
	g1.InstrumentName = "electric guitar"
	g1.Strings = []string{"a", "e", "d", "g", "b", "e"}
	g1.Tunes = []int{80, 100, 100, 190, 200, 300}
	fmt.Println(g1)

	g1.TuneUp()
	fmt.Println(g1)

	Tuning.Tune(g1)
	fmt.Println(g1)

	//
	satisfyInterface()
}

//creates it's own type (and methods) that satisfies TuningInterface used by Tuning.Tune()
func satisfyInterface() {

	g2 := Guitar{}
	g2.InstrumentName = "acoustic guitar"
	g2.Strings = []string{"a", "e", "d", "g", "b", "e"}
	g2.Tunes = []int{70, 777, 888, 777, 666, 333}
	fmt.Println(g2)
	Tuning.Tune(&g2) // note1 // so we can use Tuning.Tune on this Object as well!
	fmt.Println(g2)

	/*
		 note1
		udemy-master/structs/instrument.go:52: cannot use g2 (type Guitar) as type
		Tuning.TuningInterface in argument to Tuning.Tune:
		Guitar does not implement Tuning.TuningInterface (TuneDown method has pointer receiver)
	*/

}
