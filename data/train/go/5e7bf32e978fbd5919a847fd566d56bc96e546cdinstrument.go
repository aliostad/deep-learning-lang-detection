package orderbook

import (
	"time"
)

type TickSize float64

func (t TickSize) Value() float64 {
	return float64(t)
}

type InstrumentId int64

type Instrument struct {
	instrumentId InstrumentId
	creationTime time.Time
	version      int32
	name         string
	tickSize     TickSize
}

func NewInstrument(creationTime time.Time, name string, tickSize TickSize) Instrument {
	return Instrument{
		instrumentId: InstrumentId(creationTime.UnixNano()), //TODO: Create unique id
		creationTime: creationTime,
		version:      1,
		name:         name,
		tickSize:     tickSize,
	}
}

func (i Instrument) GetName() string {
	return i.name
}

func (i Instrument) GetTickSize() TickSize {
	return i.tickSize
}
