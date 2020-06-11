package iso20022

// Set of elements used to provide further details of the type of payment.
type PaymentTypeInformation21 struct {

	// Indicator of the urgency or order of importance that the instructing party would like the instructed party to apply to the processing of the instruction.
	InstructionPriority *Priority2Code `xml:"InstrPrty,omitempty"`

	// Specifies the clearing channel to be used to process the payment instruction.
	ClearingChannel *ClearingChannel2Code `xml:"ClrChanl,omitempty"`

	// Agreement under which or rules under which the transaction should be processed.
	ServiceLevel *ServiceLevel8Choice `xml:"SvcLvl,omitempty"`

	// User community specific instrument.
	//
	// Usage: This element is used to specify a local instrument, local clearing option and/or further qualify the service or service level.
	LocalInstrument *LocalInstrument2Choice `xml:"LclInstrm,omitempty"`

	// Specifies the high level purpose of the instruction based on a set of pre-defined categories.
	// Usage: This is used by the initiating party to provide information concerning the processing of the payment. It is likely to trigger special processing by any of the agents involved in the payment chain.
	CategoryPurpose *CategoryPurpose1Choice `xml:"CtgyPurp,omitempty"`
}

func (p *PaymentTypeInformation21) SetInstructionPriority(value string) {
	p.InstructionPriority = (*Priority2Code)(&value)
}

func (p *PaymentTypeInformation21) SetClearingChannel(value string) {
	p.ClearingChannel = (*ClearingChannel2Code)(&value)
}

func (p *PaymentTypeInformation21) AddServiceLevel() *ServiceLevel8Choice {
	p.ServiceLevel = new(ServiceLevel8Choice)
	return p.ServiceLevel
}

func (p *PaymentTypeInformation21) AddLocalInstrument() *LocalInstrument2Choice {
	p.LocalInstrument = new(LocalInstrument2Choice)
	return p.LocalInstrument
}

func (p *PaymentTypeInformation21) AddCategoryPurpose() *CategoryPurpose1Choice {
	p.CategoryPurpose = new(CategoryPurpose1Choice)
	return p.CategoryPurpose
}
