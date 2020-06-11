package iso20022

// Provides information about the corporate action security option.
type SecuritiesOption4 struct {

	// Provides description of the financial instrument related to securities movement.
	SecurityDetails *FinancialInstrumentAttributes5 `xml:"SctyDtls"`

	// Specifies whether the value is a debit or credit.
	CreditDebitIndicator *CreditDebitCode `xml:"CdtDbtInd"`

	// Specifies that the security identified  is a temporary security identification used for processing reasons, for example, contra security used in the US.
	TemporaryFinancialInstrumentIndicator *TemporaryFinancialInstrumentIndicator1Choice `xml:"TempFinInstrmInd,omitempty"`

	// Specifies information regarding outturn resources that cannot be processed by the Central Securities Depository (CSD). Special delivery instruction is required from the account owner for the corporate action outcome to be credited.
	NonEligibleProceedsIndicator *NonEligibleProceedsIndicator1Choice `xml:"NonElgblPrcdsInd,omitempty"`

	// Quantity of securities based on the terms of the corporate action event and balance of underlying securities entitled to the account owner. (This quantity can be positive or negative).
	EntitledQuantity *Quantity6Choice `xml:"EntitldQty,omitempty"`

	// Place where the securities are safe-kept, physically or notionally.  This place can be, for example, a local custodian, a Central Securities Depository (CSD) or an International Central Securities Depository (ICSD).
	SafekeepingPlace *SafekeepingPlaceFormat2Choice `xml:"SfkpgPlc,omitempty"`

	// Specifies how fractions resulting from derived securities will be processed or how prorated decisions will be rounding, if provided with a pro ration rate.
	FractionDisposition *FractionDispositionType1Choice `xml:"FrctnDspstn,omitempty"`

	// Currency in which the cash disbursed from an interest or dividend payment is offered.
	CurrencyOption *ActiveCurrencyCode `xml:"CcyOptn,omitempty"`

	// Period during which intermediate or outturn securities are tradable in a secondary market.
	TradingPeriod *Period1Choice `xml:"TradgPrd,omitempty"`

	// Provides information about the dates related to securities movement.
	DateDetails *SecurityDate2 `xml:"DtDtls"`

	// Provides information about the rates related to securities movement.
	RateDetails *CorporateActionRate7 `xml:"RateDtls,omitempty"`

	// Provides information about the prices related to securities movement.
	PriceDetails *CorporateActionPrice10 `xml:"PricDtls,omitempty"`
}

func (s *SecuritiesOption4) AddSecurityDetails() *FinancialInstrumentAttributes5 {
	s.SecurityDetails = new(FinancialInstrumentAttributes5)
	return s.SecurityDetails
}

func (s *SecuritiesOption4) SetCreditDebitIndicator(value string) {
	s.CreditDebitIndicator = (*CreditDebitCode)(&value)
}

func (s *SecuritiesOption4) AddTemporaryFinancialInstrumentIndicator() *TemporaryFinancialInstrumentIndicator1Choice {
	s.TemporaryFinancialInstrumentIndicator = new(TemporaryFinancialInstrumentIndicator1Choice)
	return s.TemporaryFinancialInstrumentIndicator
}

func (s *SecuritiesOption4) AddNonEligibleProceedsIndicator() *NonEligibleProceedsIndicator1Choice {
	s.NonEligibleProceedsIndicator = new(NonEligibleProceedsIndicator1Choice)
	return s.NonEligibleProceedsIndicator
}

func (s *SecuritiesOption4) AddEntitledQuantity() *Quantity6Choice {
	s.EntitledQuantity = new(Quantity6Choice)
	return s.EntitledQuantity
}

func (s *SecuritiesOption4) AddSafekeepingPlace() *SafekeepingPlaceFormat2Choice {
	s.SafekeepingPlace = new(SafekeepingPlaceFormat2Choice)
	return s.SafekeepingPlace
}

func (s *SecuritiesOption4) AddFractionDisposition() *FractionDispositionType1Choice {
	s.FractionDisposition = new(FractionDispositionType1Choice)
	return s.FractionDisposition
}

func (s *SecuritiesOption4) SetCurrencyOption(value string) {
	s.CurrencyOption = (*ActiveCurrencyCode)(&value)
}

func (s *SecuritiesOption4) AddTradingPeriod() *Period1Choice {
	s.TradingPeriod = new(Period1Choice)
	return s.TradingPeriod
}

func (s *SecuritiesOption4) AddDateDetails() *SecurityDate2 {
	s.DateDetails = new(SecurityDate2)
	return s.DateDetails
}

func (s *SecuritiesOption4) AddRateDetails() *CorporateActionRate7 {
	s.RateDetails = new(CorporateActionRate7)
	return s.RateDetails
}

func (s *SecuritiesOption4) AddPriceDetails() *CorporateActionPrice10 {
	s.PriceDetails = new(CorporateActionPrice10)
	return s.PriceDetails
}
