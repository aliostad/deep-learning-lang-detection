package iso20022

// Information about hold back and gating.
type HoldBackInformation3 struct {

	// Type of gating or a hold back.
	Type *GateHoldBack1Code `xml:"Tp"`

	// Value of the redemption amount subject to gating or a hold back.
	Amount *ActiveCurrencyAndAmount `xml:"Amt,omitempty"`

	// Date on which the gated amount or hold back amount is expected to be released.
	ExpectedReleaseDate *ISODate `xml:"XpctdRlsDt,omitempty"`

	// New identification of the security.
	FinancialInstrumentIdentification *SecurityIdentification25Choice `xml:"FinInstrmId,omitempty"`

	// New name of the security.
	FinancialInstrumentName *Max350Text `xml:"FinInstrmNm,omitempty"`

	// Specifies whether or not additional redemption order instructions are required in order for the redemption to be completed.
	RedemptionCompletion *RedemptionCompletion1Code `xml:"RedCmpltn,omitempty"`
}

func (h *HoldBackInformation3) SetType(value string) {
	h.Type = (*GateHoldBack1Code)(&value)
}

func (h *HoldBackInformation3) SetAmount(value, currency string) {
	h.Amount = NewActiveCurrencyAndAmount(value, currency)
}

func (h *HoldBackInformation3) SetExpectedReleaseDate(value string) {
	h.ExpectedReleaseDate = (*ISODate)(&value)
}

func (h *HoldBackInformation3) AddFinancialInstrumentIdentification() *SecurityIdentification25Choice {
	h.FinancialInstrumentIdentification = new(SecurityIdentification25Choice)
	return h.FinancialInstrumentIdentification
}

func (h *HoldBackInformation3) SetFinancialInstrumentName(value string) {
	h.FinancialInstrumentName = (*Max350Text)(&value)
}

func (h *HoldBackInformation3) SetRedemptionCompletion(value string) {
	h.RedemptionCompletion = (*RedemptionCompletion1Code)(&value)
}
