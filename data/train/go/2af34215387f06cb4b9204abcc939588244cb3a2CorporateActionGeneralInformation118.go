package iso20022

// General information about the corporate action event.
type CorporateActionGeneralInformation118 struct {

	// Reference assigned by the account servicer to unambiguously identify a corporate action event.
	CorporateActionEventIdentification *RestrictedFINXMax16Text `xml:"CorpActnEvtId"`

	// Official and unique reference assigned by the official central body/entity within each market at the beginning of a corporate action event.
	OfficialCorporateActionEventIdentification *RestrictedFINXMax16Text `xml:"OffclCorpActnEvtId,omitempty"`

	// Reference assigned by a court to a class action.
	ClassActionNumber *RestrictedFINXMax16Text `xml:"ClssActnNb,omitempty"`

	// Type of corporate action event.
	EventType *CorporateActionEventType62Choice `xml:"EvtTp"`

	// Identification of the security concerned by the corporate action.
	FinancialInstrumentIdentification *SecurityIdentification20 `xml:"FinInstrmId"`

	// Type of intermediates securities distribution.
	IntermediateSecuritiesDistributionType *IntermediateSecuritiesDistributionTypeFormat17Choice `xml:"IntrmdtSctiesDstrbtnTp,omitempty"`

	// Fractional quantity resulting from an event which will be paid with cash in lieu.
	FractionalQuantity *FinancialInstrumentQuantity15Choice `xml:"FrctnlQty,omitempty"`
}

func (c *CorporateActionGeneralInformation118) SetCorporateActionEventIdentification(value string) {
	c.CorporateActionEventIdentification = (*RestrictedFINXMax16Text)(&value)
}

func (c *CorporateActionGeneralInformation118) SetOfficialCorporateActionEventIdentification(value string) {
	c.OfficialCorporateActionEventIdentification = (*RestrictedFINXMax16Text)(&value)
}

func (c *CorporateActionGeneralInformation118) SetClassActionNumber(value string) {
	c.ClassActionNumber = (*RestrictedFINXMax16Text)(&value)
}

func (c *CorporateActionGeneralInformation118) AddEventType() *CorporateActionEventType62Choice {
	c.EventType = new(CorporateActionEventType62Choice)
	return c.EventType
}

func (c *CorporateActionGeneralInformation118) AddFinancialInstrumentIdentification() *SecurityIdentification20 {
	c.FinancialInstrumentIdentification = new(SecurityIdentification20)
	return c.FinancialInstrumentIdentification
}

func (c *CorporateActionGeneralInformation118) AddIntermediateSecuritiesDistributionType() *IntermediateSecuritiesDistributionTypeFormat17Choice {
	c.IntermediateSecuritiesDistributionType = new(IntermediateSecuritiesDistributionTypeFormat17Choice)
	return c.IntermediateSecuritiesDistributionType
}

func (c *CorporateActionGeneralInformation118) AddFractionalQuantity() *FinancialInstrumentQuantity15Choice {
	c.FractionalQuantity = new(FinancialInstrumentQuantity15Choice)
	return c.FractionalQuantity
}
