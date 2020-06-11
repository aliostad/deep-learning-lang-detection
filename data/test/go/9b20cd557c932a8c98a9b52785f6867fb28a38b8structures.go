package oandago

import (
	"crypto/tls"
	"fmt"
	"net"
	"net/http"
	"net/http/httputil"
	"time"
)

// Environment type
type Environment string

// All the various Environment kinds
const (
	FxPracticeEnv Environment = "https://api-fxpractice.oanda.com"
	FxTradeEnv    Environment = "https://api-fxtrade.oanda.com"
)

func (e *Environment) String() string {
	return fmt.Sprintf("%s", string(*e))
}

// Client is the api client
type Client struct {
	httpClient *http.Client
	Config     struct {
		APIKey    string
		Username  string
		AccountID int64
	}
	environment Environment
}

// Account type
type Account struct {
	AccountID       int64   `json:"accountId"`
	AccountName     string  `json:"accountName"`
	AccountCurrency string  `json:"accountCurrency"`
	MarginRate      float32 `json:"marginRate"`
}

// AccountInfo type
type AccountInfo struct {
	AccountID       int64   `json:"accountId"`
	AccountName     string  `json:"accountName"`
	Balance         float64 `json:"balance"`
	UnrealizedPl    float64 `json:"unrealizedPl"`
	RealizedPl      float64 `json:"realizedPl"`
	MarginUsed      float64 `json:"marginUsed"`
	MarginAvail     float64 `json:"marginAvail"`
	OpenTrades      int64   `json:"openTrades"`
	OpenOrders      int64   `json:"openOrders"`
	MarginRate      float32 `json:"marginRate"`
	AccountCurrency string  `json:"accountCurrency"`
}

// APIError type
type APIError struct {
	Code     int    `json:"code"`
	Message  string `json:"message"`
	MoreInfo string `json:"moreInfo"`
}

// InstrumentInfo type
type InstrumentInfo struct {
	Instrument      Instrument `json:"instrument"`
	DisplayName     string     `json:"displayName,omitempty"`
	Pip             string     `json:"pip,omitempty"`
	MaxTradeUnits   int64      `json:"maxTradeUnits,omitempty"`
	Precision       string     `json:"precision,omitempty"`
	MaxTrailingStop int64      `json:"maxTrailingStop,omitempty"`
	MinTrailingStop int64      `json:"minTrailingStop,omitempty"`
	MarginRate      float64    `json:"marginRate,omitempty"`
	Halted          bool       `json:"halted,omitempty"`
	InterestRate    map[Instrument]struct {
		Bid float64 `json:"bid"`
		Ask float64 `json:"ask"`
	} `json:"interestRate,omitempty"`
}

/*
type InstrumentInfoField string

const (
	InstrumentField      InstrumentInfoField = "instrument"
	DisplayNameField     InstrumentInfoField = "displayName"
	PipField             InstrumentInfoField = "pip"
	MaxTradeUnitsField   InstrumentInfoField = "maxTradeUnits"
	PrecisionField       InstrumentInfoField = "precision"
	MaxTrailingStopField InstrumentInfoField = "maxTrailingStop"
	MinTrailingStopField InstrumentInfoField = "minTrailingStop"
	MarginRateField      InstrumentInfoField = "marginRate"
	HaltedField          InstrumentInfoField = "halted"
	InterestRateField    InstrumentInfoField = "interestRate"
)
*/

// Price type
type Price struct {
	Instrument Instrument `json:"instrument"`
	Time       time.Time  `json:"time"`
	Bid        float64    `json:"bid"`
	Ask        float64    `json:"ask"`
}

// Granularity type
type Granularity string

func (g *Granularity) String() string {
	return fmt.Sprintf("%s", string(*g))
}

// All the various granularity kinds
const (
	nullGranularity Granularity = ""
	S5              Granularity = "S5"
	S10             Granularity = "S10"
	S15             Granularity = "S15"
	S30             Granularity = "S30"
	M1              Granularity = "M1"
	M2              Granularity = "M2"
	M3              Granularity = "M3"
	M4              Granularity = "M4"
	M5              Granularity = "M5"
	M10             Granularity = "M10"
	M15             Granularity = "M15"
	M30             Granularity = "M30"
	H1              Granularity = "H1"
	H2              Granularity = "H2"
	H3              Granularity = "H3"
	H4              Granularity = "H4"
	H6              Granularity = "H6"
	H8              Granularity = "H8"
	H12             Granularity = "H12"
	D               Granularity = "D"
	W               Granularity = "W"
	M               Granularity = "M"
)

// CandleFormat type
type CandleFormat string

func (c *CandleFormat) String() string {
	return fmt.Sprintf("%s", string(*c))
}

// All the various CandleFormat kinds
const (
	nullCandleFormat CandleFormat = ""
	Midpoint         CandleFormat = "midpoint"
	Bidask           CandleFormat = "bidask"
)

// WeeklyAlignment type
type WeeklyAlignment string

func (wa *WeeklyAlignment) String() string {
	return fmt.Sprintf("%s", string(*wa))
}

// All the various WeeklyAlignment kinds
const (
	Monday    WeeklyAlignment = "Monday"
	Tuesday   WeeklyAlignment = "Tuesday"
	Wednesday WeeklyAlignment = "Wednesday"
	Thursday  WeeklyAlignment = "Thursday"
	Friday    WeeklyAlignment = "Friday"
	Saturday  WeeklyAlignment = "Saturday"
	Sunday    WeeklyAlignment = "Sunday"
)

// InstrumentHistory type
type InstrumentHistory struct {
	Instrument  Instrument  `json:"instrument"`
	Granularity Granularity `json:"granularity"`
	Candles     []Candle
}

// Candle type
type Candle struct {
	Time time.Time `json:"time"`

	// MidPoint
	OpenMid  float64 `json:"openMid,omitempty"`
	HighMid  float64 `json:"highMid,omitempty"`
	LowMid   float64 `json:"lowMid,omitempty"`
	CloseMid float64 `json:"closeMid,omitempty"`

	// BidAsk
	OpenBid  float64 `json:"openBid,omitempty"`
	OpenAsk  float64 `json:"openAsk,omitempty"`
	HighBid  float64 `json:"highBid,omitempty"`
	HighAsk  float64 `json:"highAsk,omitempty"`
	LowBid   float64 `json:"lowBid,omitempty"`
	LowAsk   float64 `json:"lowAsk,omitempty"`
	CloseBid float64 `json:"closeBid,omitempty"`
	CloseAsk float64 `json:"closeAsk,omitempty"`

	Volume   int64 `json:"volume"`
	Complete bool  `json:"complete"`
}

type instrumentHistoryConfig struct {
	Granularity       Granularity
	Count             int64
	Start             time.Time
	End               time.Time
	CandleFormat      CandleFormat
	IncludeFirst      bool
	DailyAlignment    int
	AlignmentTimezone string
	WeeklyAlignment   WeeklyAlignment
}

// InstrumentHistoryConfig function returns a new configuration that is used to obtain the history of an instrument;
// returns an unexported type because this function must set the default null values.
func InstrumentHistoryConfig() instrumentHistoryConfig {
	params := instrumentHistoryConfig{
		Granularity:       nullGranularity,
		Count:             -1,
		Start:             time.Time{},
		End:               time.Time{},
		CandleFormat:      nullCandleFormat,
		IncludeFirst:      true,
		DailyAlignment:    -1,
		AlignmentTimezone: "", // default is "America/New_York"
		WeeklyAlignment:   Friday,
	}
	return params
}

type listOrdersConfig struct {
	MaxID      int64
	Count      int64
	Instrument Instrument
	IDs        []string
}

// ListOrdersConfig returns a new configuration that is used to obtain a list of the open orders;
// returns an unexported type because this function must set the default null values.
func ListOrdersConfig() listOrdersConfig {
	params := listOrdersConfig{
		MaxID:      -1,
		Count:      -1,
		Instrument: nullInstrument,
		IDs:        []string{},
	}
	return params
}

// Order type
type Order struct {
	ID           int64      `json:"id"`
	Instrument   Instrument `json:"instrument"`
	Units        int        `json:"units"`
	Side         OrderSide  `json:"side"`
	Type         OrderType  `json:"type"`
	Time         time.Time  `json:"time"`
	Price        float64    `json:"price"`
	TakeProfit   float64    `json:"takeProfit"`
	StopLoss     float64    `json:"stopLoss"`
	Expiry       time.Time  `json:"expiry"`
	UpperBound   float64    `json:"upperBound"`
	LowerBound   float64    `json:"lowerBound"`
	TrailingStop float64    `json:"trailingStop"`
}

//

type createOrderConfig struct {
	Instrument   Instrument // Required Instrument to open the order on.
	Units        int        // Required The number of units to open order for.
	Side         OrderSide  // Required Direction of the order, either ‘buy’ or ‘sell’.
	Type         OrderType  // Required The type of the order ‘limit’, ‘stop’, ‘marketIfTouched’ or ‘market’.
	Expiry       time.Time  // Required If order type is ‘limit’, ‘stop’, or ‘marketIfTouched’. The order expiration time in UTC. The value specified must be in a valid datetime format.
	Price        float64    // Required If order type is ‘limit’, ‘stop’, or ‘marketIfTouched’. The price where the order is set to trigger at.
	LowerBound   float64    // Optional The minimum execution price.
	UpperBound   float64    // Optional The maximum execution price.
	StopLoss     float64    // Optional The stop loss price.
	TakeProfit   float64    // Optional The take profit price.
	TrailingStop float64    // Optional The trailing stop distance in pips, up to one decimal place.
}

// CreateOrderConfig returns the config struct to use with CreateOrder
func CreateOrderConfig() createOrderConfig {
	params := createOrderConfig{
		Instrument:   nullInstrument,
		Units:        -1,
		Side:         nullOrderSide,
		Type:         nullOrderType,
		Expiry:       time.Time{},
		Price:        -1,
		LowerBound:   -1,
		UpperBound:   -1,
		StopLoss:     -1,
		TakeProfit:   -1,
		TrailingStop: -1,
	}
	return params
}

//

// OrderSide type
type OrderSide string

// All the kinds of OrderSide
const (
	nullOrderSide OrderSide = ""
	Buy           OrderSide = "buy"
	Sell          OrderSide = "sell"
)

func (os *OrderSide) String() string {
	return fmt.Sprintf("%s", string(*os))
}

//

// OrderType type
type OrderType string

// All the kinds of OrderType
const (
	nullOrderType   OrderType = ""
	Limit           OrderType = "limit"
	Stop            OrderType = "stop"
	MarketIfTouched OrderType = "marketIfTouched"
	Market          OrderType = "market"
)

func (ot *OrderType) String() string {
	return fmt.Sprintf("%s", string(*ot))
}

//

// OrderOpenedResponse type
type OrderOpenedResponse struct {
	Instrument  Instrument `json:"instrument"`
	Time        time.Time  `json:"time"`
	Price       float64    `json:"price"`
	OrderOpened struct {
		ID           int64     `json:"id"`
		Units        int64     `json:"units"`
		Side         OrderSide `json:"side"`
		TakeProfit   float64   `json:"takeProfit"`
		StopLoss     float64   `json:"stopLoss"`
		Expiry       time.Time `json:"expiry"`
		UpperBound   float64   `json:"upperBound"`
		LowerBound   float64   `json:"lowerBound"`
		TrailingStop float64   `json:"trailingStop"`
	} `json:"orderOpened,omitempty"`

	TradeOpened struct {
		ID           int64     `json:"id"`
		Units        int64     `json:"units"`
		Side         OrderSide `json:"side"`
		TakeProfit   float64   `json:"takeProfit"`
		StopLoss     float64   `json:"stopLoss"`
		TrailingStop float64   `json:"trailingStop"`
	} `json:"tradeOpened,omitempty"`

	TradesClosed []struct {
		ID    int64     `json:"id"`
		Units int64     `json:"units"`
		Side  OrderSide `json:"side"`
	} `json:"tradesClosed"`
	TradeReduced struct {
		ID       int64   `json:"id,omitempty"`
		Units    int     `json:"units,omitempty"`
		Pl       float64 `json:"pl,omitempty"`
		Interest float64 `json:"interest,omitempty"`
	} `json:"tradeReduced,omitempty"`
}

type modifyOrderConfig struct {
	Units        int
	Price        float64
	Expiry       time.Time
	LowerBound   float64
	UpperBound   float64
	StopLoss     float64
	TakeProfit   float64
	TrailingStop float64
}

// ModifyOrderConfig returns the config struct to use with ModifyOrder
func ModifyOrderConfig() modifyOrderConfig {
	params := modifyOrderConfig{
		Units:        -1,
		Price:        -1,
		Expiry:       time.Time{},
		LowerBound:   -1,
		UpperBound:   -1,
		StopLoss:     -1,
		TakeProfit:   -1,
		TrailingStop: -1,
	}
	return params
}

//

// ClosedOrder is the resulting info about a closed order with CloseOrder
type ClosedOrder struct {
	ID         int64      `json:"id"`         // The ID of the close order transaction
	Instrument Instrument `json:"instrument"` // The symbol of the instrument of the order
	Units      int        `json:"units"`
	Side       OrderSide  `json:"side"`
	Price      float64    `json:"price"` // The price at which the order executed
	Time       time.Time  `json:"time"`  // The time at which the order executed
}

//

// same as orders
type listOpenTradesConfig struct {
	MaxID      int64
	Count      int64
	Instrument Instrument
	IDs        []string
}

// ListOpenTradesConfig returns the config struct to use with ListOpenTrades
func ListOpenTradesConfig() listOpenTradesConfig {
	params := listOpenTradesConfig{
		MaxID:      -1,
		Count:      -1,
		Instrument: nullInstrument,
		IDs:        []string{},
	}
	return params
}

// Trade type
type Trade struct {
	ID             int64      `json:"id"`
	Units          int        `json:"units"`
	Side           OrderSide  `json:"side"`
	Instrument     Instrument `json:"instrument"`
	Time           time.Time  `json:"time"`
	Price          float64    `json:"price"`
	TakeProfit     float64    `json:"takeProfit"`
	StopLoss       float64    `json:"stopLoss"`
	TrailingStop   float64    `json:"trailingStop"`
	TrailingAmount float64    `json:"trailingAmount"`
}

//

type modifyTradeConfig struct {
	StopLoss     float64
	TakeProfit   float64
	TrailingStop float64
}

// ModifyTradeConfig returns the config struct to use with ModifyTrade
func ModifyTradeConfig() modifyTradeConfig {
	params := modifyTradeConfig{
		StopLoss:     -1,
		TakeProfit:   -1,
		TrailingStop: -1,
	}
	return params
}

//

// ClosedTrade is the resulting info about a closed trade with CloseTrade
type ClosedTrade struct {
	ID         int64      `json:"id"`         // The ID of the close trade transaction
	Price      float64    `json:"price"`      // The price the trade was closed at
	Instrument Instrument `json:"instrument"` // The symbol of the instrument of the trade
	Profit     float64    `json:"profit"`     // The realized profit of the trade in units of base currency
	Side       OrderSide  `json:"side"`       // The direction the trade was in
	Time       time.Time  `json:"time"`       // The time at which the trade was closed (in RFC3339 format)
}

//

// Position type
type Position struct {
	Instrument Instrument `json:"instrument"`
	Units      int        `json:"units"`
	Side       OrderSide  `json:"side"`
	AvgPrice   float64    `json:"avgPrice"`
}

//

// ClosedPosition is the resulting info about a closed position with ClosePosition
type ClosedPosition struct {
	IDs        []int64    `json:"ids"` // Contains a list of transaction ids created as a result of the close position, including the id of the trades that were closed
	Instrument Instrument `json:"instrument"`
	TotalUnits int64      `json:"totalUnits"`
	Price      float64    `json:"price"`
}

//

type transactionHistoryConfig struct {
	MaxID      int64
	MinID      int64
	Count      int64
	Instrument Instrument
	IDs        []string
}

// TransactionHistoryConfig returns the config struct to use with TransactionHistory
func TransactionHistoryConfig() transactionHistoryConfig {
	params := transactionHistoryConfig{
		MaxID:      -1,
		MinID:      -1,
		Count:      -1,
		Instrument: nullInstrument,
		IDs:        []string{},
	}
	return params
}

// Transaction type
type Transaction struct {
	ID                       int64           `json:"id,omitempty"`
	AccountID                int64           `json:"accountId,omitempty"`
	Time                     time.Time       `json:"time,omitempty"`
	Type                     TransactionType `json:"type,omitempty"`
	Instrument               Instrument      `json:"instrument,omitempty"`
	Side                     OrderSide       `json:"side,omitempty"`
	Units                    int             `json:"units,omitempty"`
	Price                    float64         `json:"price,omitempty"`
	LowerBound               float64         `json:"lowerBound,omitempty"`
	UpperBound               float64         `json:"upperBound,omitempty"`
	TakeProfitPrice          float64         `json:"takeProfitPrice,omitempty"`
	StopLossPrice            float64         `json:"stopLossPrice,omitempty"`
	TrailingStopLossDistance float64         `json:"trailingStopLossDistance,omitempty"`
	Pl                       float64         `json:"pl,omitempty"`
	Interest                 float64         `json:"interest,omitempty"`
	AccountBalance           float64         `json:"accountBalance,omitempty"`
	Amount                   float64         `json:"amount,omitempty"`

	TradeOpened struct {
		ID    int64 `json:"id,omitempty"`
		Units int   `json:"units,omitempty"`
	} `json:"tradeOpened,omitempty"`
	TradeReduced struct {
		ID       int64   `json:"id,omitempty"`
		Units    int     `json:"units,omitempty"`
		Pl       float64 `json:"pl,omitempty"`
		Interest float64 `json:"interest,omitempty"`
	} `json:"tradeReduced,omitempty"`

	Expiry     time.Time `json:"expiry,omitempty"`
	Reason     string    `json:"reason,omitempty"` // CLIENT_REQUEST, MIGRATION;  CLIENT_REQUEST, TIME_IN_FORCE_EXPIRED, ORDER_FILLED, MIGRATION. Order fill may result in a failure due to the following reasons: INSUFFICIENT_MARGIN, BOUNDS_VIOLATION, UNITS_VIOLATION, STOP_LOSS_VIOLATION, TAKE_PROFIT_VIOLATION, TRAILING_STOP_VIOLATION, MARKET_HALTED, ACCOUNT_NON_TRADABLE, NO_NEW_POSITION_ALLOWED, INSUFFICIENT_LIQUIDITY; FUNDS, CURRENSEE_MONTHLY, CURRENSEE_PERFORMANCE, SDR_REPORTING
	OrderID    int64     `json:"orderId,omitempty"`
	TradeID    int64     `json:"tradeId,omitempty"`
	MarginRate float64   `json:"marginRate,omitempty"`
}

//

// TransactionType type
type TransactionType string

// All the various kinds of TransactionType
const (
	MARKET_ORDER_CREATE            TransactionType = "MARKET_ORDER_CREATE"
	STOP_ORDER_CREATE              TransactionType = "STOP_ORDER_CREATE"
	LIMIT_ORDER_CREATE             TransactionType = "LIMIT_ORDER_CREATE"
	MARKET_IF_TOUCHED_ORDER_CREATE TransactionType = "MARKET_IF_TOUCHED_ORDER_CREATE"
	ORDER_UPDATE                   TransactionType = "ORDER_UPDATE"
	ORDER_CANCEL                   TransactionType = "ORDER_CANCEL"
	ORDER_FILLED                   TransactionType = "ORDER_FILLED"
	TRADE_UPDATE                   TransactionType = "TRADE_UPDATE"
	TRADE_CLOSE                    TransactionType = "TRADE_CLOSE"
	MIGRATE_TRADE_OPEN             TransactionType = "MIGRATE_TRADE_OPEN"
	MIGRATE_TRADE_CLOSE            TransactionType = "MIGRATE_TRADE_CLOSE"
	STOP_LOSS_FILLED               TransactionType = "STOP_LOSS_FILLED"
	TAKE_PROFIT_FILLED             TransactionType = "TAKE_PROFIT_FILLED"
	TRAILING_STOP_FILLED           TransactionType = "TRAILING_STOP_FILLED"
	MARGIN_CALL_ENTER              TransactionType = "MARGIN_CALL_ENTER"
	MARGIN_CALL_EXIT               TransactionType = "MARGIN_CALL_EXIT"
	MARGIN_CLOSEOUT                TransactionType = "MARGIN_CLOSEOUT"
	SET_MARGIN_RATE                TransactionType = "SET_MARGIN_RATE"
	TRANSFER_FUNDS                 TransactionType = "TRANSFER_FUNDS"
	DAILY_INTEREST                 TransactionType = "DAILY_INTEREST"
	FEE                            TransactionType = "FEE"
)

// RateStreamMessage is a message received from RateStream
type RateStreamMessage struct {
	Tick struct {
		Instrument Instrument `json:"instrument,omitempty"`
		Time       time.Time  `json:"time,omitempty"`
		Bid        float64    `json:"bid,omitempty"`
		Ask        float64    `json:"ask,omitempty"`
	} `json:"tick,omitempty"`

	Heartbeat struct {
		Time time.Time `json:"time,omitempty"`
	} `json:"heartbeat,omitempty"`

	Disconnect APIError `json:"disconnect,omitempty"`
}

// RateStreamCursor type
type RateStreamCursor struct {
	response        *http.Response
	clientConn      *httputil.ClientConn
	clientTLSconfig *tls.Config
	tcpConn         net.Conn
	tlsConn         *tls.Conn
}

//

// EventStreamMessage is a message received from EventStream
type EventStreamMessage struct {
	Transaction Transaction `json:"transaction,omitempty"`

	Heartbeat struct {
		Time time.Time `json:"time,omitempty"`
	} `json:"heartbeat,omitempty"`

	Disconnect APIError `json:"disconnect,omitempty"`
}

// EventStreamCursor type
type EventStreamCursor struct {
	response        *http.Response
	clientConn      *httputil.ClientConn
	clientTLSconfig *tls.Config
	tcpConn         net.Conn
	tlsConn         *tls.Conn
}
