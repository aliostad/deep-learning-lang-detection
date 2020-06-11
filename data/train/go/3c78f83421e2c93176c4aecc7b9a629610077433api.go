// Copyright (c) 2016 Forau @ github.com. MIT License.

// Package api contains definitions for the client and transports
package api

import (
	"encoding/json"
	"github.com/Forau/yanngo/nnutils"
	"github.com/Forau/yanngo/swagger"

	"fmt"
	"strings"
)

type RequestBuilder struct {
	req *Request
	err error
	ph  TransportHandler
}

func (rb *RequestBuilder) Exec(res interface{}) error {
	if rb.err != nil {
		return rb.err
	}
	resp := rb.ph.Preform(rb.req)
	if resp.Error != nil {
		return resp.Error
	} else {
		return json.Unmarshal(resp.Payload, res)
	}
}

func (rb *RequestBuilder) S(key, val string) *RequestBuilder {
	if val != "" {
		rb.req.Args[key] = val
	}
	return rb
}
func (rb *RequestBuilder) I(key string, val int64) *RequestBuilder {
	return rb.S(key, fmt.Sprintf("%d", val))
}
func (rb *RequestBuilder) IA(key string, val []int64) *RequestBuilder {
	valArr := []string{}
	for _, v := range val {
		valArr = append(valArr, fmt.Sprintf("%d", v))
	}
	return rb.S(key, strings.Join(valArr, ","))
}
func (rb *RequestBuilder) F(key string, val float64) *RequestBuilder {
	return rb.S(key, fmt.Sprintf("%f", val))
}
func (rb *RequestBuilder) Price(key string, val float64) *RequestBuilder {
	return rb.S(key, nnutils.NewDefaultTickTableUtil().ToString(val))
}
func (rb *RequestBuilder) FA(key string, val []float64) *RequestBuilder {
	valArr := []string{}
	for _, v := range val {
		valArr = append(valArr, fmt.Sprintf("%f", v))
	}
	return rb.S(key, strings.Join(valArr, ","))
}

func (rb *RequestBuilder) V(key string, val interface{}) *RequestBuilder {
	return rb.S(key, fmt.Sprintf("%v", val))
}

type ApiClient struct {
	ph TransportHandler
}

func NewApiClient(ph TransportHandler) *ApiClient {
	return &ApiClient{ph: ph}
}

func (ac *ApiClient) build(command RequestCommand) *RequestBuilder {
	return &RequestBuilder{
		req: &Request{Command: command, Args: Params{}},
		ph:  ac.ph,
	}
}

func (ac *ApiClient) GetTransport() TransportHandler {
	return ac.ph
}

type accountQuery struct {
	Accno   int64 `json:"accno,omitempty"`
	OrderId int64 `json:"orderid,omitempty"`
}

type OrderSide string

func (os OrderSide) Buy() OrderSide  { return "BUY" }
func (os OrderSide) Sell() OrderSide { return "SELL" }

type OrderType string

const (
	FAK           OrderType = "FAK"
	FOK                     = "FOK"
	LIMIT                   = "LIMIT"
	STOP_LIMIT              = "STOP_LIMIT"
	STOP_TRAILING           = "STOP_TRAILING"
	OCO                     = "OCO"
)

type OrderCondition string
type OrderTriggerDir string

type AccountOrder struct {
	Accno   int64 `json:"accno"`
	OrderId int64 `json:"orderid,omitempty"` // Only when modifying existing

	// Mandatory
	Identifier string    `json:"identifier"`
	MarketId   int64     `json:"market_id"`
	Price      float64   `json:"price"`
	Volume     int64     `json:"volume,omitempty"`
	Side       OrderSide `json:"side"`

	// Omited == LIMIT
	OrderType OrderType `json:"order_type,omitempty"`

	// Special
	Currency            string          `json:"currency,omitempty"`
	ValidUntil          string          `json:"valid_until,omitempty"`
	OpenVolume          int64           `json:"open_volume,omitempty"`
	Reference           string          `json:"reference,omitempty"`
	ActivationCondition OrderCondition  `json:"activation_condition,omitempty"`
	TriggerCondition    OrderTriggerDir `json:"trigger_condition,omitempty"`
	TriggerValue        float64         `json:"trigger_value,omitempty"`
	//  	TriggerValue         float64         `json:"trigger_value,omitempty"`
}

func (ao AccountOrder) Apply(b *RequestBuilder) (ret *RequestBuilder) {
	ret = b.I("accno", ao.Accno).
		S("identifier", ao.Identifier).
		I("market_id", ao.MarketId).
		Price("price", ao.Price).
		I("volume", ao.Volume).
		S("side", string(ao.Side)).
		S("currency", "SEK").
		S("order_type", string(ao.OrderType))

	if ao.OrderType == STOP_LIMIT || ao.OrderType == STOP_TRAILING || ao.OrderType == OCO {
		ret = ret.S("activation_condition", string(ao.ActivationCondition)).
			S("trigger_condition", string(ao.TriggerCondition)).
			Price("trigger_value", ao.TriggerValue)
	}
	return
}

func (ac *ApiClient) Session() (res swagger.Login, err error) {
	err = ac.build(SessionCmd).Exec(&res)
	return
}
func (ac *ApiClient) Accounts() (res []swagger.Account, err error) {
	err = ac.build(AccountsCmd).Exec(&res)
	return
}
func (ac *ApiClient) Account(accno int64) (res swagger.AccountInfo, err error) {
	err = ac.build(AccountCmd).I("accno", accno).Exec(&res)
	return
}
func (ac *ApiClient) AccountLedgers(accno int64) (res swagger.LedgerInformation, err error) {
	err = ac.build(AccountLedgersCmd).I("accno", accno).Exec(&res)
	return
}
func (ac *ApiClient) AccountOrders(accno int64) (res []swagger.Order, err error) {
	err = ac.build(AccountOrdersCmd).I("accno", accno).Exec(&res)
	return
}
func (ac *ApiClient) CreateSimpleOrder(accno int64, identifier string, market int64,
	price float64, vol int64, side string) (res swagger.OrderReply, err error) {
	err = ac.build(CreateOrderCmd).I("accno", accno).S("identifier", identifier).I("market_id", market).
		F("price", price).I("volume", vol).S("side", side).
		S("currency", "SEK").Exec(&res)
	return
}
func (ac *ApiClient) CreateOrder(order *AccountOrder) (res swagger.OrderReply, err error) {
	builder := ac.build(CreateOrderCmd)
	err = order.Apply(builder).Exec(&res)
	return
}

func (ac *ApiClient) ActivateOrder(accno, id int64) (res swagger.OrderReply, err error) {
	err = ac.build(ActivateOrderCmd).I("accno", accno).I("order_id", id).Exec(&res)
	return
}
func (ac *ApiClient) UpdateOrder(accno, id int64) (res swagger.OrderReply, err error) {
	err = ac.build(UpdateOrderCmd).I("accno", accno).I("order_id", id).Exec(&res)
	return
}
func (ac *ApiClient) DeleteOrder(accno, id int64) (res swagger.OrderReply, err error) {
	err = ac.build(DeleteOrderCmd).I("accno", accno).I("order_id", id).Exec(&res)
	return
}
func (ac *ApiClient) AccountPositions(accno int64) (res []swagger.Position, err error) {
	err = ac.build(AccountPositionsCmd).I("accno", accno).Exec(&res)
	return
}
func (ac *ApiClient) AccountTrades(accno int64) (res []swagger.Trade, err error) {
	err = ac.build(AccountTradesCmd).I("accno", accno).Exec(&res)
	return
}
func (ac *ApiClient) Countries(countries ...string) (res []swagger.Country, err error) {
	err = ac.build(CountriesCmd).S("countries", strings.Join(countries, ",")).Exec(&res)
	return
}
func (ac *ApiClient) Indicators(indicators ...string) (res []swagger.Indicator, err error) {
	err = ac.build(IndicatorsCmd).S("indicators", strings.Join(indicators, ",")).Exec(&res)
	return
}
func (ac *ApiClient) InstrumentSearch(query string) (res []swagger.Instrument, err error) {
	err = ac.build(InstrumentSearchCmd).S("query", query).Exec(&res)
	return
}

// The advanced instrument search will page, and return the results in a chan. Ignoring error for now
func (ac *ApiClient) InstrumentSearchStream(query, types string, fuzzy bool) (ret chan swagger.Instrument) {
	ret = make(chan swagger.Instrument, 1)
	//  err = make(chan error,1)

	go func(size, page int64) {
		defer close(ret)
		//    defer close(err)

		for {
			var r []swagger.Instrument
			if e := ac.build(InstrumentSearchCmd).S("query", query).S("instrument_group_type", types).
				I("limit", size).I("offset", page).V("fuzzy", fuzzy).Exec(&r); e != nil {
				fmt.Printf("UNCAUGHT ERROR: %+v\n", e)
				return
			} else {
				for _, instr := range r {
					ret <- instr
				}
				if l := int64(len(r)); l < size {
					return
				}
				page += size
			}

		}
	}(100, 0)
	return ret
}

func (ac *ApiClient) Instruments(ids ...int64) (res []swagger.Instrument, err error) {
	err = ac.build(InstrumentsCmd).IA("ids", ids).Exec(&res)
	return
}

func (ac *ApiClient) InstrumentLeverages(id int64, instrument_type, instrument_group_type string) (res []swagger.Instrument, err error) {
	err = ac.build(InstrumentLeveragesCmd).I("instrument", id).S("instrument_type", instrument_type).
		S("instrument_group_type", instrument_group_type).S("currency", "SEK").Exec(&res)
	return
}

/*
func (ac *ApiClient) InstrumentLeverageFilters(pathMap{id int64})(res swagger.,err error) {
  err = ac.build(InstrumentLeverageFiltersCmd). &)
  return
}
func (ac *ApiClient) InstrumentOptionPairs(pathMap{id int64})(res swagger.,err error) {
  err = ac.build(InstrumentOptionPairsCmd). &)
  return
}
func (ac *ApiClient) InstrumentOptionPairFilters(pathMap{id int64})(res swagger.,err error) {
  err = ac.build(InstrumentOptionPairFiltersCmd). &)
  return
}
*/
// The lookup_type is isin_code_currency_market_id or market_id_identifier
func (ac *ApiClient) InstrumentLookup(typ, instrument string) (res []swagger.Instrument, err error) {
	err = ac.build(InstrumentLookupCmd).S("lookup", instrument).S("type", typ).Exec(&res)
	return
}

/*
func (ac *ApiClient) InstrumentSectors()(res swagger.,err error) {
  err = ac.build(InstrumentSectorsCmd). &)
  return
}
func (ac *ApiClient) InstrumentSector(pathMap{pathMap{"Sectors",fmtInt}})(res swagger.,err error) {
  err = ac.build(InstrumentSectorCmd). &)
  return
}
*/

func (ac *ApiClient) InstrumentTypes() (res []swagger.InstrumentType, err error) {
	err = ac.build(InstrumentTypesCmd).Exec(&res)
	return
}

/*
func (ac *ApiClient) InstrumentType(pathMap{pathMap{"Type",fmtInt}})(res swagger.,err error) {
  err = ac.build(InstrumentTypeCmd). &)
  return
}
*/
func (ac *ApiClient) InstrumentUnderlyings(typ, currency string) (res []swagger.Instrument, err error) {
	err = ac.build(InstrumentUnderlyingsCmd).S("type", typ).S("currency", currency).Exec(&res)
	return
}

func (ac *ApiClient) Lists() (res []swagger.List, err error) {
	err = ac.build(ListsCmd).Exec(&res)
	return
}
func (ac *ApiClient) List(id int64) (res []swagger.Instrument, err error) {
	err = ac.build(ListCmd).I("id", id).Exec(&res)
	return
}

func (ac *ApiClient) Market(ids ...int64) (res []swagger.Market, err error) {
	err = ac.build(MarketCmd).IA("ids", ids).Exec(&res)
	return
}

/*
func (ac *ApiClient) SearchNews()(res swagger.,err error) {
  err = ac.build(SearchNewsCmd). &)
  return
}
func (ac *ApiClient) News(pathMap{ids []int64})(res swagger.,err error) {
  err = ac.build(NewsCmd). &)
  return
}
*/
func (ac *ApiClient) NewsSources() (res []swagger.NewsSource, err error) {
	err = ac.build(NewsSourcesCmd).Exec(&res)
	return
}

func (ac *ApiClient) RealtimeAccess() (res []swagger.RealtimeAccess, err error) {
	err = ac.build(RealtimeAccessCmd).Exec(&res)
	return
}
func (ac *ApiClient) TickSizes() (res []swagger.TicksizeTable, err error) {
	err = ac.build(TickSizeCmd).Exec(&res)
	return
}
func (ac *ApiClient) TickSize(ids ...int64) (res []swagger.TicksizeTable, err error) {
	err = ac.build(TickSizeCmd).IA("ids", ids).Exec(&res)
	return
}

func (ac *ApiClient) TradableInfo(ids ...string) (res []swagger.TradableInfo, err error) {
	err = ac.build(TradableInfoCmd).S("ids", strings.Join(ids, ",")).Exec(&res)
	return
}
func (ac *ApiClient) TradableDay(ids ...string) (res []swagger.IntradayGraph, err error) {
	err = ac.build(TradableIntradayCmd).S("ids", strings.Join(ids, ",")).Exec(&res)
	return
}
func (ac *ApiClient) TradableTrades(ids ...string) (res []swagger.PublicTrades, err error) {
	err = ac.build(TradableTradesCmd).S("ids", strings.Join(ids, ",")).Exec(&res)
	return
}

// Feeds
func (ac *ApiClient) FeedSub(typ, id, mark string) (res map[string]interface{}, err error) {
	err = ac.build(FeedSubCmd).S("type", typ).S("id", id).S("market", mark).Exec(&res)
	return
}

func (ac *ApiClient) FeedSubNews(source int64) (res map[string]interface{}, err error) {
	err = ac.build(FeedSubCmd).S("type", "news").I("source", source).Exec(&res)
	return
}

func (ac *ApiClient) FeedUnsub(subId string) (res map[string]string, err error) {
	err = ac.build(FeedUnsubCmd).S("id", subId).Exec(&res)
	return
}

func (ac *ApiClient) FeedStatus() (res map[string]interface{}, err error) {
	err = ac.build(FeedStatusCmd).Exec(&res)
	return
}

// Custom
func (ac *ApiClient) CustomRequest(command string) (rb *RequestBuilder) {
	return ac.build(RequestCommand(command))
}
