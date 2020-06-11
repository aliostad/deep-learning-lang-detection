package swagger

type Instrument struct {
	InstrumentId        int64            `json:"instrument_id,omitempty"`
	Tradables           []Tradable       `json:"tradables,omitempty"`
	Currency            string           `json:"currency,omitempty"`
	InstrumentGroupType string           `json:"instrument_group_type,omitempty"`
	InstrumentType      string           `json:"instrument_type,omitempty"`
	Multiplier          float64          `json:"multiplier,omitempty"`
	Symbol              string           `json:"symbol,omitempty"`
	IsinCode            string           `json:"isin_code,omitempty"`
	MarketView          string           `json:"market_view,omitempty"`
	StrikePrice         float64          `json:"strike_price,omitempty"`
	PawnPercentage      float64          `json:"pawn_percentage,omitempty"`
	NumberOfSecurities  float64          `json:"number_of_securities,omitempty"`
	ProspectusUrl       string           `json:"prospectus_url,omitempty"`
	ExpirationDate      Date             `json:"expiration_date,omitempty"`
	Name                string           `json:"name,omitempty"`
	Sector              string           `json:"sector,omitempty"`
	SectorGroup         string           `json:"sector_group,omitempty"`
	Underlyings         []UnderlyingInfo `json:"underlyings,omitempty"`
}
