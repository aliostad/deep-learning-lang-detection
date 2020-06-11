// Package models represents data returned by the API and in the private feed
package models

type SystemStatus struct {
	Timestamp     int64  `json:"timestamp"`
	ValidVersion  bool   `json:"valid_version"`
	SystemRunnnig bool   `json:"system_running"`
	Message       string `json:"message"`
}

type Account struct {
	Accno         int64  `json:"accno"`
	Type          string `json:"type"`
	Default       bool   `json:"default"`
	Alias         string `json:"alias"`
	Blocked       bool   `json:"blocked"`
	BlockedReason string `json:"blocked_reason"`
}

type AccountInfo struct {
	AccountCurrency            string `json:"account_currency"`
	AccountCredit              Amount `json:"account_credit"`
	AccountSum                 Amount `json:"account_sum"`
	Collateral                 Amount `json:"collateral"`
	CreditAccountSum           Amount `json:"credit_account_sum"`
	ForwardSum                 Amount `json:"forward_sum"`
	FutureSum                  Amount `json:"future_sum"`
	UnrealizedFutureProfitLoss Amount `json:"unrealized_future_profit_loss"`
	FullMarketvalue            Amount `json:"full_marketvalue"`
	Interest                   Amount `json:"interest"`
	IntradayCredit             Amount `json:"intraday_credit"`
	LoanLimit                  Amount `json:"loan_limit"`
	OwnCapital                 Amount `json:"own_capital"`
	OwnCapitalMorning          Amount `json:"own_capital_morning"`
	PawnValue                  Amount `json:"pawn_value"`
	TradingPower               Amount `json:"trading_power"`
}

type Amount struct {
	Value    float64 `json:"value"`
	Currency string  `json:"currency"`
}

type LedgerInformation struct {
	TotalAccIntDeb  Amount   `json:"total_acc_int_deb"`
	TotalAccIntCred Amount   `json:"total_acc_int_cred"`
	Total           Amount   `json:"total"`
	Ledgers         []Ledger `json:"ledgers"`
}

type Ledger struct {
	Currency      string `json:"currency"`
	AccountSum    Amount `json:"account_sum"`
	AccountSumAcc Amount `json:"account_sum_acc"`
	AccIntDeb     Amount `json:"acc_int_deb"`
	AccIntCred    Amount `json:"acc_int_cred"`
	ExchangeRate  Amount `json:"exchange_rate"`
}

type Order struct {
	Accno               int64               `json:"accno"`
	OrderId             int64               `json:"order_id"`
	Price               Amount              `json:"price"`
	Volume              float64             `json:"volume"`
	Tradable            TradableId          `json:"tradable"`
	OpenVolume          float64             `json:"open_volume"`
	TradedVolume        float64             `json:"traded_volume"`
	Side                string              `json:"side"`
	Modified            int64               `json:"modified"`
	Reference           string              `json:"reference"`
	ActivationCondition ActivationCondition `json:"activation_condition"`
	PriceCondition      string              `json:"price_condition"`
	VolumeCondition     string              `json:"volume_condition"`
	Validity            Validity            `json:"validity"`
	ActionState         string              `json:"action_state"`
	OrderState          string              `json:"order_state"`
}

type TradableId struct {
	Identifier string `json:"identifier"`
	MarketId   int64  `json:"market_id"`
}

type ActivationCondition struct {
	Type             string  `json:"type"`
	TrailingValue    float64 `json:"trailing_value"`
	TriggerValue     float64 `json:"trigger_value"`
	TriggerCondition string  `json:"trigger_condition"`
}

type Validity struct {
	Type       string `json:"type"`
	ValidUntil int64  `json:"valid_until"`
}

type OrderReply struct {
	OrderId     int64  `json:"order_id"`
	ResultCode  string `json:"result_code"`
	OrderState  string `json:"order_state"`
	ActionState string `json:"action_state"`
	Message     string `json:"message"`
}

type Position struct {
	Accno          int64      `json:"accno"`
	Instrument     Instrument `json:"instrument"`
	Qty            float64    `json:"qty"`
	PawnPercent    float64    `json:"pawn_percent"`
	MarketValueAcc Amount     `json:"market_value_acc"`
	MarketValue    Amount     `json:"market_value"`
	AcqPriceAcc    Amount     `json:"acq_price_acc"`
	AcqPrice       Amount     `json:"acq_price"`
	MorningPrice   Amount     `json:"morning_price"`
}

type Instrument struct {
	InstrumentId        int64            `json:"instrument_id"`
	Tradables           []Tradable       `json:"tradables"`
	Currency            string           `json:"currency"`
	InstrumentGroupType string           `json:"instrument_group_type"`
	InstrumentType      string           `json:"instrument_type"`
	Multiplier          float64          `json:"multiplier"`
	Symbol              string           `json:"symbol"`
	IsinCode            string           `json:"isin_code"`
	MarketView          string           `json:"market_view"`
	StrikePrice         float64          `json:"strike_price"`
	NumberOfSecurities  float64          `json:"number_of_securities"`
	ProspectusUrl       string           `json:"prospectus_url"`
	ExpirationDate      string           `json:"expiration_date"`
	Name                string           `json:"name"`
	Sector              string           `json:"sector"`
	SectorGroup         string           `json:"sector_group"`
	Underlyings         []UnderlyingInfo `json:"underlyings"`
}

type Tradable struct {
	TradableId
	TickSizeId   int64   `json:"tick_size_id"`
	LotSize      float64 `json:"lot_size"`
	DisplayOrder int64   `json:"display_order"`
}

type UnderlyingInfo struct {
	InstrumentId int64  `json:"instrument_id"`
	Symbol       string `json:"symbol"`
	IsinCode     string `json:"isin_code"`
}

type Trade struct {
	Accno        int64      `json:"accno"`
	OrderId      int64      `json:"order_id"`
	TradeId      string     `json:"trade_id"`
	Tradable     TradableId `json:"tradable"`
	Price        Amount     `json:"price"`
	Volume       float64    `json:"volume"`
	Side         string     `json:"side"`
	Counterparty string     `json:"counterparty"`
	Tradetime    int64      `json:"tradetime"`
}

type Country struct {
	Country string `json:"country"`
	Name    string `json:"name"`
}

type Indicator struct {
	Name         string `json:"name"`
	Src          string `json:"src"`
	Identifier   string `json:"identifier"`
	Delayed      int64  `json:"delayed"`
	OnlyEod      bool   `json:"only_eod"`
	Open         string `json:"open"`
	Close        string `json:"close"`
	Country      string `json:"country"`
	Type         string `json:"type"`
	Region       string `json:"region"`
	InstrumentId int64  `json:"instrument_id"`
}

type LeverageFilter struct {
	Issuers              []Issuer `json:"issuers"`
	MarketView           []string `json:"market_view"`
	ExpirationDates      []string `json:"expiration_dates"`
	InstrumentTypes      []string `json:"instrument_types"`
	InstrumentGroupTypes []string `json:"instrument_group_types"`
	Currencies           []string `json:"currencies"`
	NoOfInstruments      int64    `json:"no_of_instruments"`
}

type Issuer struct {
	Name     string `json:"name"`
	IssuerId int64  `json:"issuer_id"`
}

type OptionPair struct {
	StrikePrice    float64    `json:"strike_price"`
	ExpirationDate string     `json:"expiration_date"`
	Call           Instrument `json:"call"`
	Put            Instrument `json:"put"`
}

type OptionPairFilter struct {
	ExpirationDates []string `json:"expiration_dates"`
}

type Sector struct {
	Sector string `json:"sector"`
	Group  string `json:"group"`
	Name   string `json:"name"`
}

type InstrumentType struct {
	InstrumentType string `json:"instrument_type"`
	Name           string `json:"name"`
}

type List struct {
	Symbol       string `json:"symbol"`
	DisplayOrder int64  `json:"display_order"`
	ListId       int64  `json:"list_id"`
	Name         string `json:"name"`
	Country      string `json:"country"`
	Region       string `json:"region"`
}

type Feed struct {
	Hostname  string `json:"hostname"`
	Port      int64  `json:"port"`
	Encrypted bool   `json:"encrypted"`
}

type LoggedInStatus struct {
	LoggedIn bool `json:"logged_in"`
}

type Login struct {
	Environment string `json:"environment"`
	SessionKey  string `json:"session_key"`
	ExpiresIn   int64  `json:"expires_in"`
	PrivateFeed Feed   `json:"private_feed"`
	PublicFeed  Feed   `json:"public_feed"`
}

type Market struct {
	MarketId int64  `json:"market_id"`
	Country  string `json:"country"`
	Name     string `json:"name"`
}

type NewsPreview struct {
	NewsId      int64   `json:"news_id"`
	SourceId    int64   `json:"source_id"`
	Headline    string  `json:"headline"`
	Instruments []int64 `json:"instruments"`
	Lang        string  `json:"lang"`
	Type        string  `json:"type"`
	Timestamp   int64   `json:"timestamp"`
}

type NewsItem struct {
	NewsId      int64   `json:"news_id"`
	SourceId    int64   `json:"source_id"`
	Headline    string  `json:"headline"`
	Body        string  `json:"body"`
	Instruments []int64 `json:"instruments"`
	Lang        string  `json:"lang"`
	Type        string  `json:"type"`
	Timestamp   int64   `json:"timestamp"`
}

type NewsSource struct {
	Name      string   `json:"name"`
	SourceId  int64    `json:"source_id"`
	Level     string   `json:"level"`
	Countries []string `json:"countries"`
}

type RealtimeAccess struct {
	MarketId int64 `json:"market_id"`
	Level    int64 `json:"level"`
}

type TicksizeTable struct {
	TickSizeId int64              `json:"tick_size_id"`
	Ticks      []TickSizeInterval `json:"ticks"`
}

type TickSizeInterval struct {
	Decimals  int64   `json:"decimals"`
	FromPrice float64 `json:"from_price"`
	ToPrice   float64 `json:"to_price"`
	Tick      float64 `json:"tick"`
}

type TradableInfo struct {
	MarketId   int64         `json:"market_id"`
	Iceberg    bool          `json:"iceberg"`
	Calendar   []CalendarDay `json:"calendar"`
	OrderTypes []OrderType   `json:"order_types"`
}

type CalendarDay struct {
	Date  string `json:"date"`
	Open  int64  `json:"open"`
	Close int64  `json:"close"`
}

type OrderType struct {
	Type string `json:"type"`
	Name string `json:"name"`
}

type IntradayGraph struct {
	TradableId
	Ticks []IntradayTick `json:"ticks"`
}

type IntradayTick struct {
	Timestamp  int64   `json:"timestamp"`
	Last       float64 `json:"last"`
	Low        float64 `json:"low"`
	High       float64 `json:"high"`
	Volume     float64 `json:"volume"`
	NoOfTrades int64   `json:"no_of_trades"`
}

type PublicTrades struct {
	TradableId
	Trades []PublicTrade `json:"trades"`
}

type PublicTrade struct {
	BrokerBuying   string  `json:"broker_buying"`
	BrokerSelling  string  `json:"broker_selling"`
	Volume         int64   `json:"volume"`
	Price          float64 `json:"price"`
	TradeId        string  `json:"trade_id"`
	TradeType      string  `json:"trade_type"`
	TradeTimestamp int64   `json:"trade_timestamp"`
}
