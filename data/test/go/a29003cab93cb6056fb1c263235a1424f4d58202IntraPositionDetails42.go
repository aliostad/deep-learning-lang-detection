package iso20022

// Details of the intra-position movement.
type IntraPositionDetails42 struct {

	// Collective reference identifying a set of messages.
	PoolIdentification *RestrictedFINXMax16Text `xml:"PoolId,omitempty"`

	// Party that legally owns the account.
	AccountOwner *PartyIdentification103Choice `xml:"AcctOwnr,omitempty"`

	// Account to or from which a securities entry is made.
	SafekeepingAccount *SecuritiesAccount30 `xml:"SfkpgAcct"`

	// Financial instruments representing a sum of rights of the investor vis-a-vis the issuer.
	FinancialInstrumentIdentification *SecurityIdentification20 `xml:"FinInstrmId"`

	// Total quantity of securities to be settled.
	SettlementQuantity *FinancialInstrumentQuantity1Choice `xml:"SttlmQty"`

	// Number identifying a lot constituting the financial instrument.
	LotNumber *GenericIdentification39 `xml:"LotNb,omitempty"`

	// Date and time at which the securities are to be moved.
	SettlementDate *DateAndDateTimeChoice `xml:"SttlmDt"`

	// Time stamp on when the transaction is acknowledged.
	AcknowledgedStatusTimeStamp *ISODateTime `xml:"AckdStsTmStmp,omitempty"`

	// Balance from which the securities are moving.
	BalanceFrom *SecuritiesBalanceType11Choice `xml:"BalFr,omitempty"`

	// Balance to which the securities are moving.
	BalanceTo *SecuritiesBalanceType11Choice `xml:"BalTo,omitempty"`
}

func (i *IntraPositionDetails42) SetPoolIdentification(value string) {
	i.PoolIdentification = (*RestrictedFINXMax16Text)(&value)
}

func (i *IntraPositionDetails42) AddAccountOwner() *PartyIdentification103Choice {
	i.AccountOwner = new(PartyIdentification103Choice)
	return i.AccountOwner
}

func (i *IntraPositionDetails42) AddSafekeepingAccount() *SecuritiesAccount30 {
	i.SafekeepingAccount = new(SecuritiesAccount30)
	return i.SafekeepingAccount
}

func (i *IntraPositionDetails42) AddFinancialInstrumentIdentification() *SecurityIdentification20 {
	i.FinancialInstrumentIdentification = new(SecurityIdentification20)
	return i.FinancialInstrumentIdentification
}

func (i *IntraPositionDetails42) AddSettlementQuantity() *FinancialInstrumentQuantity1Choice {
	i.SettlementQuantity = new(FinancialInstrumentQuantity1Choice)
	return i.SettlementQuantity
}

func (i *IntraPositionDetails42) AddLotNumber() *GenericIdentification39 {
	i.LotNumber = new(GenericIdentification39)
	return i.LotNumber
}

func (i *IntraPositionDetails42) AddSettlementDate() *DateAndDateTimeChoice {
	i.SettlementDate = new(DateAndDateTimeChoice)
	return i.SettlementDate
}

func (i *IntraPositionDetails42) SetAcknowledgedStatusTimeStamp(value string) {
	i.AcknowledgedStatusTimeStamp = (*ISODateTime)(&value)
}

func (i *IntraPositionDetails42) AddBalanceFrom() *SecuritiesBalanceType11Choice {
	i.BalanceFrom = new(SecuritiesBalanceType11Choice)
	return i.BalanceFrom
}

func (i *IntraPositionDetails42) AddBalanceTo() *SecuritiesBalanceType11Choice {
	i.BalanceTo = new(SecuritiesBalanceType11Choice)
	return i.BalanceTo
}
