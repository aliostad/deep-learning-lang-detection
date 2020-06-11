//Tuning to serve as library
package Tuning

type Instrument struct {
	InstrumentName string
	Strings        []string
	Tunes          []int
}

func (i *Instrument) TuneUp() {
	i.Tunes = []int{82, 110, 147, 196, 247, 330}
}

func (i *Instrument) TuneDown() {
	i.Tunes = []int{0, 0, 0, 0, 0, 0}
}

type TuningInterface interface {
	TuneUp() //method signatures
	TuneDown()
}

//returns an Instrument type, which satisfies the interface
func CreateInstrument() (*Instrument, error) {
	return new(Instrument), nil
}

func Tune(t TuningInterface) {
	t.TuneUp()
	//t.TuneDown()
}
