package iso20022

// Intention to transfer an ownership of a financial instrument.
type PartialFill1 struct {

	// Quantity of financial instrument to be ordered.
	ConfirmationQuantity *Quantity6Choice `xml:"ConfQty"`

	// Amount of money for which goods or services are offered, sold, or bought.
	DealPrice *Price4 `xml:"DealPric"`

	// Specifies the date/time on which the trade was executed.
	TradeDate *TradeDate4Choice `xml:"TradDt,omitempty"`

	// Market in which a trade transaction is to be or has been executed.
	PlaceOfTrade *MarketIdentification13 `xml:"PlcOfTrad,omitempty"`

	// Quantity of financial instrument ordered.
	OriginalOrderedQuantity *QuantityOrAmount1Choice `xml:"OrgnlOrdrdQty"`

	// Quantity of financial instrument that has been previously executed.
	PreviouslyExecutedQuantity *QuantityOrAmount1Choice `xml:"PrevslyExctdQty"`

	// Quantity of financial instrument that is remaining in order.
	RemainingQuantity *QuantityOrAmount1Choice `xml:"RmngQty"`

	// Minimum quantity that applies to every execution. The order may still fill against smaller orders, but the cumulative quantity of the execution must be in multiples of the Match Increment.
	MatchIncrementQuantity *QuantityOrAmount1Choice `xml:"MtchIncrmtQty,omitempty"`
}

func (p *PartialFill1) AddConfirmationQuantity() *Quantity6Choice {
	p.ConfirmationQuantity = new(Quantity6Choice)
	return p.ConfirmationQuantity
}

func (p *PartialFill1) AddDealPrice() *Price4 {
	p.DealPrice = new(Price4)
	return p.DealPrice
}

func (p *PartialFill1) AddTradeDate() *TradeDate4Choice {
	p.TradeDate = new(TradeDate4Choice)
	return p.TradeDate
}

func (p *PartialFill1) AddPlaceOfTrade() *MarketIdentification13 {
	p.PlaceOfTrade = new(MarketIdentification13)
	return p.PlaceOfTrade
}

func (p *PartialFill1) AddOriginalOrderedQuantity() *QuantityOrAmount1Choice {
	p.OriginalOrderedQuantity = new(QuantityOrAmount1Choice)
	return p.OriginalOrderedQuantity
}

func (p *PartialFill1) AddPreviouslyExecutedQuantity() *QuantityOrAmount1Choice {
	p.PreviouslyExecutedQuantity = new(QuantityOrAmount1Choice)
	return p.PreviouslyExecutedQuantity
}

func (p *PartialFill1) AddRemainingQuantity() *QuantityOrAmount1Choice {
	p.RemainingQuantity = new(QuantityOrAmount1Choice)
	return p.RemainingQuantity
}

func (p *PartialFill1) AddMatchIncrementQuantity() *QuantityOrAmount1Choice {
	p.MatchIncrementQuantity = new(QuantityOrAmount1Choice)
	return p.MatchIncrementQuantity
}
