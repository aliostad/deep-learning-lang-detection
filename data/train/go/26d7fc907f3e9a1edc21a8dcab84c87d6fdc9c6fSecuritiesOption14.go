package iso20022

// Provides information about the corporate action security option.
type SecuritiesOption14 struct {

	// Provides description of the financial instrument related to securities movement.
	SecurityDetails *FinancialInstrumentAttributes16 `xml:"SctyDtls"`

	// Specifies whether the value is a debit or credit.
	CreditDebitIndicator *CreditDebitCode `xml:"CdtDbtInd"`

	// Specifies that the security identified  is a temporary security identification used for processing reasons, for example, contra security used in the US.
	TemporaryFinancialInstrumentIndicator *TemporaryFinancialInstrumentIndicator1Choice `xml:"TempFinInstrmInd,omitempty"`

	// Specifies information regarding outturn resources that cannot be processed by the Central Securities Depository (CSD). Special delivery instruction is required from the account owner for the corporate action outcome to be credited.
	NonEligibleProceedsIndicator *NonEligibleProceedsIndicator1Choice `xml:"NonElgblPrcdsInd,omitempty"`

	// Quantity of securities based on the terms of the corporate action event and balance of underlying securities entitled to the account owner. (This quantity can be positive or negative).
	EntitledQuantity *Quantity6Choice `xml:"EntitldQty,omitempty"`

	// Specifies how fractions resulting from derived securities will be processed or how prorated decisions will be rounding, if provided with a pro ration rate.
	FractionDisposition *FractionDispositionType1Choice `xml:"FrctnDspstn,omitempty"`

	// Currency in which the cash disbursed from an interest or dividend payment is offered.
	CurrencyOption *ActiveCurrencyCode `xml:"CcyOptn,omitempty"`

	// Period during which intermediate or outturn securities are tradable in a secondary market.
	TradingPeriod *Period3Choice `xml:"TradgPrd,omitempty"`

	// Provides information about the dates related to securities movement.
	DateDetails *SecurityDate5 `xml:"DtDtls"`

	// Provides information about the rates related to securities movement.
	RateDetails *CorporateActionRate17 `xml:"RateDtls,omitempty"`

	// Provides information about the prices related to securities movement.
	PriceDetails *CorporateActionPrice18 `xml:"PricDtls,omitempty"`
}

func (s *SecuritiesOption14) AddSecurityDetails() *FinancialInstrumentAttributes16 {
	s.SecurityDetails = new(FinancialInstrumentAttributes16)
	return s.SecurityDetails
}

func (s *SecuritiesOption14) SetCreditDebitIndicator(value string) {
	s.CreditDebitIndicator = (*CreditDebitCode)(&value)
}

func (s *SecuritiesOption14) AddTemporaryFinancialInstrumentIndicator() *TemporaryFinancialInstrumentIndicator1Choice {
	s.TemporaryFinancialInstrumentIndicator = new(TemporaryFinancialInstrumentIndicator1Choice)
	return s.TemporaryFinancialInstrumentIndicator
}

func (s *SecuritiesOption14) AddNonEligibleProceedsIndicator() *NonEligibleProceedsIndicator1Choice {
	s.NonEligibleProceedsIndicator = new(NonEligibleProceedsIndicator1Choice)
	return s.NonEligibleProceedsIndicator
}

func (s *SecuritiesOption14) AddEntitledQuantity() *Quantity6Choice {
	s.EntitledQuantity = new(Quantity6Choice)
	return s.EntitledQuantity
}

func (s *SecuritiesOption14) AddFractionDisposition() *FractionDispositionType1Choice {
	s.FractionDisposition = new(FractionDispositionType1Choice)
	return s.FractionDisposition
}

func (s *SecuritiesOption14) SetCurrencyOption(value string) {
	s.CurrencyOption = (*ActiveCurrencyCode)(&value)
}

func (s *SecuritiesOption14) AddTradingPeriod() *Period3Choice {
	s.TradingPeriod = new(Period3Choice)
	return s.TradingPeriod
}

func (s *SecuritiesOption14) AddDateDetails() *SecurityDate5 {
	s.DateDetails = new(SecurityDate5)
	return s.DateDetails
}

func (s *SecuritiesOption14) AddRateDetails() *CorporateActionRate17 {
	s.RateDetails = new(CorporateActionRate17)
	return s.RateDetails
}

func (s *SecuritiesOption14) AddPriceDetails() *CorporateActionPrice18 {
	s.PriceDetails = new(CorporateActionPrice18)
	return s.PriceDetails
}
