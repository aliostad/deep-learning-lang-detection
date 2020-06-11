package tradegozilla

import (
	"bytes"
	"crypto/tls"
	"encoding/json"
	"encoding/xml"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"net/http/cookiejar"
	"net/url"
	"os"
	"strings"
	"time"
	"github.com/hailiang/gosocks"
)

type Config struct {
	SocksProxyAddress string
	Username string
	Password string
	APIHost string
	SourceApp string
}

type AuthResponse struct {
	Token string `json:"token"`
	UserId int64 `json:"userId"`
}

type QuoteRequest struct {
	XMLName xml.Name `xml:"getQuotes"`
	Items []QuoteItem `xml:"item"`
}
type QuoteResponse struct {
	XMLName xml.Name `xml:""ns2:getQuotesResponse""`
	Items []QuoteItem `xml:"item"`
}

type OptionChainRequest struct {
	XMLName xml.Name `xml:"getOptionChain"`
	Symbols []string `xml:"symbol"`
}

type OptionChainResponse struct {
	XMLName xml.Name `xml:""ns2:getQuotesResponse""`
	Items []QuoteOptionItem `xml:"item"`
}

type QuotePrice struct {
	Amount float64 `xml:"amount"`
	Currency string `xml:"currency"`
}

type QuoteItem struct {
	XMLName xml.Name `xml:"item"`
	AskPrice QuotePrice `xml:"askPrice"`
	AskSize float64 `xml:"askSize"`
	BidPrice QuotePrice`xml:"bidPrice"`
	BidSize float64 `xml:"bidSize"`
	ClosingMark QuotePrice`xml:"closingMark"`
	HighPrice QuotePrice`xml:"highPrice"`
	ImpliedVolatility float64 `xml:"impliedVolatility"`
	LastSize int64 `xml:"lastSize"`
	LastTradeTimeMillis int64 `xml:"lastTradeTimeMillis"`
	LastTradedPrice QuotePrice`xml:"lastTradedPrice"`
	LowPrice QuotePrice`xml:"lowPrice"`
	Mark QuotePrice`xml:"mark"`
	MarkChangePct float64 `xml:"markChangePct"`
	MarkChangePrice QuotePrice`xml:"markChangePrice"`
	OpenPrice QuotePrice`xml:"openPrice"`
	Symbol string `xml:"symbol"`
	Volume int64 `xml:"volume"`
	YearHighPrice QuotePrice`xml:"yearHighPrice"`
	YearLowPrice QuotePrice`xml:"yearLowPrice"`
	DivType string `xml:"divType"`
	Dividend QuotePrice `xml:"dividend"`
	DividendDate int64 `xml:"dividendDate"`
	ExtLastTradedPrice QuotePrice `xml:"extLastTradedPrice"`
	InstrumentType string `xml:"instrumentType"`
	PreviousClosePrice QuotePrice `xml:"previousClosePrice"`
	SaleTradeTimeMillis int64 `xml:"saleTradeTimeMillis"`
	TradeCondition int64 `xml:"tradeCondition"`
}

type QuoteOptionItem struct {
	XMLName xml.Name `xml:"item"`
	Order int64 `xml:"order"`
	AddFlag string `xml:"addFlag"`
	DaysToExpire int64 `xml:"daysToExpire"`
	ExpiryLabel string `xml:"expiryLabel"`
	ExpiryType string `xml:"expiryType"`
	OptionCollection []QuoteOptionStrikePair `xml:"option_Collection"`
}

type QuoteOptionStrikePair struct {
	XMLName xml.Name `xml:"option_Collection"`
	Call QuoteOption `xml:"call"`
	Put QuoteOption `xml:"put"`
	Strike float64 `xml:"strike"`
}
type QuoteOption struct {
	DeliverableType string `xml:"deliverableType"`
	Exchange string `xml:"exchange"`
	ExchangeType string `xml:"exchangeType"`
	ExerciseStyle string `xml:"exerciseStyle"`
	ExpirationType string `xml:"expirationType"`
	ExpireType string `xml:"expireType"`
	ExpiryDeliverable string `xml:"expiryDeliverable"`
	Instrument QuoteInstrument `xml:"instrument"`
	InstrumentId int64 `xml:"instrumentId"`
	MinimumTickValue1 float64 `xml:"minimumTickValue1"`
	MinimumTickValue2 float64 `xml:"minimumTickValue2"`
	Multiplier int64 `xml:"multiplier"`
	OpraRoot string `xml:"opraRoot"`
	ReutersInstrumentCode string `xml:"reutersInstrumentCode"`
	SharesPerContract int64 `xml:"sharesPerContract"`
	StrikePrice float64 `xml:"strikePrice"`
	Symbol string `xml:"symbol"`
}

type QuoteInstrument struct {
	DaysToExpire int64 `xml:"daysToExpire"`
	EasyToBorrow bool `xml:"easyToBorrow"`
	ExchangeCode string `xml:"exchangeCode"`
	ExchangeType string `xml:"exchangeType"`
	ExerciseStyle string `xml:"exerciseStyle"`
	ExpireDay int `xml:"expireDay"`
	ExpireDayET int `xml:"expireDayET"`
	InstrumentId int64 `xml:"instrumentId"`
	InstrumentSubType string `xml:"instrumentSubType"`
	InstrumentType string `xml:"instrumentType"`
	MinimumTickValue1 float64 `xml:"minimumTickValue1"`
	MinimumTickValue2 float64 `xml:"minimumTickValue2"`
	Month int `xml:"month"`
	Multiplier float64 `xml:"multiplier"`
	OpraCode string `xml:"opraCode"`
	OptionType string `xml:"optionType"`
	Optionable bool `xml:"optionable"`
	ReutersInstrumentCode string `xml:"reutersInstrumentCode"`
	StrikePrice float64 `xml:"strikePrice"`
	Symbol string `xml:"symbol"`
	Tradeable bool `xml:"tradeable"`
	UnderlyingInstrumentId int64 `xml:"underlyingInstrumentId"`
	UnderlyingSymbol string `xml:"underlyingSymbol"`
	Year int `xml:"year"`
}

type MonsterClient struct {
	client *http.Client
	config *Config
	account *AuthResponse
}

func (q QuoteInstrument) ExpiryDate() time.Time {
	location, _ := time.LoadLocation("America/New_York")
	return time.Date(q.Year, time.Month(q.Month), q.ExpireDayET, 16, 0, 0, 0, location)
}

func (m MonsterClient) InitConfig() (error) {
	m.config.SocksProxyAddress = os.Getenv("SOCKS_PROXY_ADDR")
	m.config.Username = os.Getenv("MONSTER_USER")
	m.config.Password = os.Getenv("MONSTER_PASS")
	m.config.APIHost = os.Getenv("MONSTER_HOST")
	m.config.SourceApp = os.Getenv("MONSTER_SOURCEAPP")
	return nil
}

func (m MonsterClient) InitHTTPClient() (error) {
	dialSocksProxy := socks.DialSocksProxy(socks.SOCKS5, m.config.SocksProxyAddress)
	transport := &http.Transport{
		Dial: dialSocksProxy,
		TLSClientConfig: &tls.Config{InsecureSkipVerify: true},
	}
	options := cookiejar.Options{}
	jar, err := cookiejar.New(&options)
	if err != nil {
		log.Fatal(err)
	}
	m.client.Transport = transport
	m.client.Jar = jar
	return nil
}
func (m MonsterClient) NewClient() (client *MonsterClient, err error) {
	client = &MonsterClient{}
	client.config = &Config{}
	client.client = &http.Client{}
	client.account = &AuthResponse{}
	client.InitConfig()
	client.InitHTTPClient()
	return client, nil
}

func (m MonsterClient) Auth() bool {
	fmt.Printf("url is: %s", m.config)
	data := url.Values{"j_username":{m.config.Username}, "j_password":{m.config.Password}}
	req_url := strings.Join([]string{"https://", m.config.APIHost, "/j_acegi_security_check"}, "")
	req, err := http.NewRequest("POST", req_url, bytes.NewBufferString(data.Encode()))
	if err != nil {
		log.Fatal(err)
	}

	req.Header.Add("Accept", "text/xml,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8")
	req.Header.Add("Content-Type", "application/x-www-form-urlencoded")
	req.Header.Add("sourceapp", m.config.SourceApp)

	resp, err := m.client.Do(req)
	if err != nil {
		log.Fatal(err)
	}
	defer resp.Body.Close()
	body, err := ioutil.ReadAll(resp.Body)

	// TODO: Actually check if there was an error, and return it for handling
	fmt.Printf("Auth body was : %s\n", body)
	// TODO: Check response body for error types and return for handling
	json.Unmarshal(body, &m.account)
	fmt.Printf("Setting account token to: %s\n", m.account.Token)
	return true
}

func (m MonsterClient) Post(path string, payload []byte) (response_body []byte, err error) {
	req_url := strings.Join([]string{"https://", m.config.APIHost, path}, "")
	req, err := http.NewRequest("POST", req_url, bytes.NewReader(payload))
	// TODO: Handle errors
	req.Header.Add("Accept", "text/xml")
	req.Header.Add("Content-Type", "text/xml")
	req.Header.Add("sourceapp", m.config.SourceApp)
	req.Header.Add("token", m.account.Token)
	quoteresp, err := m.client.Do(req)
	if err != nil {
		log.Fatal(err)
	}
	fmt.Printf("Response status was: %v\n", quoteresp.StatusCode)
	defer quoteresp.Body.Close()
	body, err := ioutil.ReadAll(quoteresp.Body)
	if err != nil {
		log.Fatal(err)
	}
	return body, nil
}

func (m MonsterClient) Quote(symbol string) (quotes []QuoteItem, err error) {
	var reqData QuoteRequest
	qitem := QuoteItem{Symbol: symbol, InstrumentType: "Equity"}
	reqData.Items = append(reqData.Items, qitem)
	// TODO: Handle errors
	payload, err := xml.Marshal(reqData)
	// TODO: Handle errors
	quoteresp, _ := m.Post("/services/quotesService", payload)
	var qr QuoteResponse
	xml.Unmarshal(quoteresp, &qr)
	return qr.Items, nil
}

func (m MonsterClient) Options(symbols []string) (options []QuoteOption, err error) {
	var optData OptionChainRequest
	for _, symbol := range symbols {
		optData.Symbols = append(optData.Symbols, symbol)
	}
	// TODO: Handle errors
	opayload, err := xml.Marshal(optData)
	//fmt.Printf("Option request payload is: %s", opayload)
	optionsresp, _ := m.Post("/services/quotesOptionService", opayload)
	var chain OptionChainResponse
	xml.Unmarshal(optionsresp, &chain)

	fmt.Printf("Items are : %s\n", chain.Items)
	for _, items := range chain.Items {
	  for _, strikePair := range items.OptionCollection {
	    options = append(options, strikePair.Call)
	    options = append(options, strikePair.Put)
	  }
	}
	return options, nil
}
