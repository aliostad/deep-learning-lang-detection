package swagger

type Indicator struct {
	Name         string `json:"name,omitempty"`
	Src          string `json:"src,omitempty"`
	Identifier   string `json:"identifier,omitempty"`
	Delayed      int64  `json:"delayed,omitempty"`
	OnlyEod      bool   `json:"only_eod,omitempty"`
	Open         string `json:"open,omitempty"`
	Close        string `json:"close,omitempty"`
	Country      string `json:"country,omitempty"`
	Typ          string `json:"type,omitempty"`
	Region       string `json:"region,omitempty"`
	InstrumentId int64  `json:"instrument_id,omitempty"`
}
