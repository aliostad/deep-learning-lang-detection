package iso20022

// Choice between a turnaround and pair-off quantity for instructing a one to many and many to many (partial) pair-off or turnaround.
type PairedOrTurnedQuantity1Choice struct {

	// Quantity of financial instruments of the linked transaction to be paired-off.
	PairedOffQuantity *FinancialInstrumentQuantity1Choice `xml:"PairdOffQty,omitempty"`

	// Quantity of financial instruments of the linked transaction to be turned.
	TurnedQuantity *FinancialInstrumentQuantity1Choice `xml:"TrndQty,omitempty"`
}

func (p *PairedOrTurnedQuantity1Choice) AddPairedOffQuantity() *FinancialInstrumentQuantity1Choice {
	p.PairedOffQuantity = new(FinancialInstrumentQuantity1Choice)
	return p.PairedOffQuantity
}

func (p *PairedOrTurnedQuantity1Choice) AddTurnedQuantity() *FinancialInstrumentQuantity1Choice {
	p.TurnedQuantity = new(FinancialInstrumentQuantity1Choice)
	return p.TurnedQuantity
}
