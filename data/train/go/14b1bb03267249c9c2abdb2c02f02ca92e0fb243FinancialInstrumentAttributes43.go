package iso20022

// Description of the financial instrument.
type FinancialInstrumentAttributes43 struct {

	// Identifies the financial instrument.
	FinancialInstrumentIdentification *SecurityIdentification14 `xml:"FinInstrmId"`

	// Place where the referenced financial instrument is listed.
	PlaceOfListing *MarketIdentification3Choice `xml:"PlcOfListg,omitempty"`

	// Specifies the computation method of (accrued) interest of the financial instrument.
	DayCountBasis *InterestComputationMethodFormat1Choice `xml:"DayCntBsis,omitempty"`

	// Classification type of the financial instrument, as per the ISO Classification of Financial Instrument (CFI).
	ClassificationType *ClassificationType2Choice `xml:"ClssfctnTp,omitempty"`

	// Specifies how an option can be exercised.
	OptionStyle *OptionStyle4Choice `xml:"OptnStyle,omitempty"`

	// Currency in which a financial instrument is currently denominated.
	DenominationCurrency *ActiveOrHistoricCurrencyCode `xml:"DnmtnCcy,omitempty"`

	// Next payment date of an interest bearing financial instrument.
	NextCouponDate *ISODate `xml:"NxtCpnDt,omitempty"`

	// Date on which an order expires or at which a privilege or offer terminates.
	ExpiryDate *ISODate `xml:"XpryDt,omitempty"`

	// Date on which the interest rate or redemption price will be/was calculated according to the terms of the issue.
	FloatingRateFixingDate *ISODate `xml:"FltgRateFxgDt,omitempty"`

	// Date on which a financial instrument becomes due and assets are to be repaid.
	MaturityDate *ISODate `xml:"MtrtyDt,omitempty"`

	// Date on which the financial instrument is issued.
	IssueDate *ISODate `xml:"IsseDt,omitempty"`

	// Date on which a financial instrument is called away/redeemed before its scheduled maturity.
	NextCallableDate *ISODate `xml:"NxtCllblDt,omitempty"`

	// Date on which a holder of a financial instrument has the right to request redemption of the principal amount prior to its scheduled maturity date.
	PutableDate *ISODate `xml:"PutblDt,omitempty"`

	// Date on which an interest bearing financial instrument begins to accrue interest.
	DatedDate *ISODate `xml:"DtdDt,omitempty"`

	// Deadline by which a convertible security must be converted, according to the terms of the issue.
	ConversionDate *ISODate `xml:"ConvsDt,omitempty"`

	// Annual rate of a financial instrument.
	InterestRate *RateFormat3Choice `xml:"IntrstRate,omitempty"`

	// Interest rate applicable to the next interest payment period in relation to variable rate instruments.
	NextInterestRate *RateFormat3Choice `xml:"NxtIntrstRate,omitempty"`

	// Percentage of the underlying assets of a fund that represents a debt, for example, in the context of the EU Savings directive.
	PercentageOfDebtClaim *RateFormat3Choice `xml:"PctgOfDebtClm,omitempty"`

	// Factor used to calculate the value of the outstanding principal of the financial instrument (for factored securities) until the next redemption (factor) date.
	PreviousFactor *RateFormat3Choice `xml:"PrvsFctr,omitempty"`

	// Factor used to calculate the value of the outstanding principal of the financial instrument (for factored securities) that will applicable after the redemption (factor) date.
	NextFactor *RateFormat3Choice `xml:"NxtFctr,omitempty"`

	// Provides the ratio between the quantity of warrants and the quantity of underlying securities.
	WarrantParity *QuantityToQuantityRatio1 `xml:"WarrtParity,omitempty"`

	// Also known as Minimum Nominal Value. Minimum nominal quantity of financial instrument that must be purchased/sold.
	MinimumNominalQuantity *FinancialInstrumentQuantity1Choice `xml:"MinNmnlQty,omitempty"`

	// Minimum quantity of financial instrument or lot of rights/warrants that must be exercised.
	MinimumExercisableQuantity *FinancialInstrumentQuantity1Choice `xml:"MinExrcblQty,omitempty"`

	// Minimum multiple quantity of financial instrument or lot of rights/warrants that must be exercised.
	MinimumExercisableMultipleQuantity *FinancialInstrumentQuantity1Choice `xml:"MinExrcblMltplQty,omitempty"`

	// Ratio or multiplying factor used to convert one contract into a financial instrument quantity.
	ContractSize *FinancialInstrumentQuantity1Choice `xml:"CtrctSz,omitempty"`
}

func (f *FinancialInstrumentAttributes43) AddFinancialInstrumentIdentification() *SecurityIdentification14 {
	f.FinancialInstrumentIdentification = new(SecurityIdentification14)
	return f.FinancialInstrumentIdentification
}

func (f *FinancialInstrumentAttributes43) AddPlaceOfListing() *MarketIdentification3Choice {
	f.PlaceOfListing = new(MarketIdentification3Choice)
	return f.PlaceOfListing
}

func (f *FinancialInstrumentAttributes43) AddDayCountBasis() *InterestComputationMethodFormat1Choice {
	f.DayCountBasis = new(InterestComputationMethodFormat1Choice)
	return f.DayCountBasis
}

func (f *FinancialInstrumentAttributes43) AddClassificationType() *ClassificationType2Choice {
	f.ClassificationType = new(ClassificationType2Choice)
	return f.ClassificationType
}

func (f *FinancialInstrumentAttributes43) AddOptionStyle() *OptionStyle4Choice {
	f.OptionStyle = new(OptionStyle4Choice)
	return f.OptionStyle
}

func (f *FinancialInstrumentAttributes43) SetDenominationCurrency(value string) {
	f.DenominationCurrency = (*ActiveOrHistoricCurrencyCode)(&value)
}

func (f *FinancialInstrumentAttributes43) SetNextCouponDate(value string) {
	f.NextCouponDate = (*ISODate)(&value)
}

func (f *FinancialInstrumentAttributes43) SetExpiryDate(value string) {
	f.ExpiryDate = (*ISODate)(&value)
}

func (f *FinancialInstrumentAttributes43) SetFloatingRateFixingDate(value string) {
	f.FloatingRateFixingDate = (*ISODate)(&value)
}

func (f *FinancialInstrumentAttributes43) SetMaturityDate(value string) {
	f.MaturityDate = (*ISODate)(&value)
}

func (f *FinancialInstrumentAttributes43) SetIssueDate(value string) {
	f.IssueDate = (*ISODate)(&value)
}

func (f *FinancialInstrumentAttributes43) SetNextCallableDate(value string) {
	f.NextCallableDate = (*ISODate)(&value)
}

func (f *FinancialInstrumentAttributes43) SetPutableDate(value string) {
	f.PutableDate = (*ISODate)(&value)
}

func (f *FinancialInstrumentAttributes43) SetDatedDate(value string) {
	f.DatedDate = (*ISODate)(&value)
}

func (f *FinancialInstrumentAttributes43) SetConversionDate(value string) {
	f.ConversionDate = (*ISODate)(&value)
}

func (f *FinancialInstrumentAttributes43) AddInterestRate() *RateFormat3Choice {
	f.InterestRate = new(RateFormat3Choice)
	return f.InterestRate
}

func (f *FinancialInstrumentAttributes43) AddNextInterestRate() *RateFormat3Choice {
	f.NextInterestRate = new(RateFormat3Choice)
	return f.NextInterestRate
}

func (f *FinancialInstrumentAttributes43) AddPercentageOfDebtClaim() *RateFormat3Choice {
	f.PercentageOfDebtClaim = new(RateFormat3Choice)
	return f.PercentageOfDebtClaim
}

func (f *FinancialInstrumentAttributes43) AddPreviousFactor() *RateFormat3Choice {
	f.PreviousFactor = new(RateFormat3Choice)
	return f.PreviousFactor
}

func (f *FinancialInstrumentAttributes43) AddNextFactor() *RateFormat3Choice {
	f.NextFactor = new(RateFormat3Choice)
	return f.NextFactor
}

func (f *FinancialInstrumentAttributes43) AddWarrantParity() *QuantityToQuantityRatio1 {
	f.WarrantParity = new(QuantityToQuantityRatio1)
	return f.WarrantParity
}

func (f *FinancialInstrumentAttributes43) AddMinimumNominalQuantity() *FinancialInstrumentQuantity1Choice {
	f.MinimumNominalQuantity = new(FinancialInstrumentQuantity1Choice)
	return f.MinimumNominalQuantity
}

func (f *FinancialInstrumentAttributes43) AddMinimumExercisableQuantity() *FinancialInstrumentQuantity1Choice {
	f.MinimumExercisableQuantity = new(FinancialInstrumentQuantity1Choice)
	return f.MinimumExercisableQuantity
}

func (f *FinancialInstrumentAttributes43) AddMinimumExercisableMultipleQuantity() *FinancialInstrumentQuantity1Choice {
	f.MinimumExercisableMultipleQuantity = new(FinancialInstrumentQuantity1Choice)
	return f.MinimumExercisableMultipleQuantity
}

func (f *FinancialInstrumentAttributes43) AddContractSize() *FinancialInstrumentQuantity1Choice {
	f.ContractSize = new(FinancialInstrumentQuantity1Choice)
	return f.ContractSize
}
