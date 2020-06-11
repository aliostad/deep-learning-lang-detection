package api

import (
	"encoding/base64"
	"errors"
	"fmt"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/stretchr/testify/assert"

	. "github.com/denro/nordnet/util/models"
)

var defSessionKey = "DEFAULTSESSION"

func TestLoginErrorIntegration(t *testing.T) {
	handler := http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(401)
		w.Write([]byte(`{"code":"NEXT_LOGIN_INVALID_TIMESTAMP","message":"Something went wrong when logging in."}`))
	})
	ts := httptest.NewServer(handler)
	defer ts.Close()

	client := APIClient{URL: ts.URL}
	_, err := client.Login()

	assert.EqualError(t, err, "NEXT_LOGIN_INVALID_TIMESTAMP: Something went wrong when logging in.")
}

func TestSystemStatusIntegration(t *testing.T) {
	client, ts := setup(t, "GET", "/2", "", systemStatusJSON)
	defer ts.Close()

	if resp, err := client.SystemStatus(); err != nil {
		t.Fatal(err)
	} else {
		assert := assert.New(t)

		assert.EqualValues(123, resp.Timestamp)
		assert.Equal(true, resp.ValidVersion)
		assert.Equal(true, resp.SystemRunnnig)
		assert.Equal("test", resp.Message)
	}
}

func TestAccountsIntegration(t *testing.T) {
	client, ts := setup(t, "GET", "/2/accounts", defSessionKey, accountsJSON)
	defer ts.Close()

	if resp, err := client.Accounts(); err != nil {
		t.Fatal(err)
	} else {
		assert := assert.New(t)

		assert.NotEmpty(resp)

		acc := resp[0]
		assert.EqualValues(123, acc.Accno)
		assert.Equal("test", acc.Type)
		assert.Equal(true, acc.Default)
		assert.Equal("test", acc.Alias)
		assert.Equal(true, acc.Blocked)
		assert.Equal("test", acc.BlockedReason)
	}
}

func TestAccountIntegration(t *testing.T) {
	client, ts := setup(t, "GET", "/2/accounts/1000000", defSessionKey, accountJSON)
	defer ts.Close()

	if resp, err := client.Account(1000000); err != nil {
		t.Fatal(err)
	} else {
		assert := assert.New(t)

		assert.Equal("test", resp.AccountCurrency)
		assert.Equal(Amount{1.1, "test"}, resp.AccountCredit)
		assert.Equal(Amount{1.1, "test"}, resp.AccountSum)
		assert.Equal(Amount{1.1, "test"}, resp.Collateral)
		assert.Equal(Amount{1.1, "test"}, resp.CreditAccountSum)
		assert.Equal(Amount{1.1, "test"}, resp.ForwardSum)
		assert.Equal(Amount{1.1, "test"}, resp.FutureSum)
		assert.Equal(Amount{1.1, "test"}, resp.UnrealizedFutureProfitLoss)
		assert.Equal(Amount{1.1, "test"}, resp.FullMarketvalue)
		assert.Equal(Amount{1.1, "test"}, resp.Interest)
		assert.Equal(Amount{1.1, "test"}, resp.IntradayCredit)
		assert.Equal(Amount{1.1, "test"}, resp.LoanLimit)
		assert.Equal(Amount{1.1, "test"}, resp.OwnCapital)
		assert.Equal(Amount{1.1, "test"}, resp.OwnCapitalMorning)
		assert.Equal(Amount{1.1, "test"}, resp.PawnValue)
		assert.Equal(Amount{1.1, "test"}, resp.TradingPower)
	}
}

func TestAccountLedgersIntegration(t *testing.T) {
	client, ts := setup(t, "GET", "/2/accounts/1000000/ledgers", defSessionKey, accountLedgersJSON)
	defer ts.Close()

	if resp, err := client.AccountLedgers(1000000); err != nil {
		t.Fatal(err)
	} else {
		assert := assert.New(t)

		assert.NotEmpty(resp)

		accLedger := resp[0]
		assert.Equal(Amount{1.1, "test"}, accLedger.TotalAccIntDeb)
		assert.Equal(Amount{1.1, "test"}, accLedger.TotalAccIntCred)
		assert.Equal(Amount{1.1, "test"}, accLedger.Total)

		assert.NotEmpty(accLedger.Ledgers)

		ledger := accLedger.Ledgers[0]
		assert.Equal("test", ledger.Currency)
		assert.Equal(Amount{1.1, "test"}, ledger.AccountSum)
		assert.Equal(Amount{1.1, "test"}, ledger.AccountSumAcc)
		assert.Equal(Amount{1.1, "test"}, ledger.AccIntDeb)
		assert.Equal(Amount{1.1, "test"}, ledger.AccIntCred)
		assert.Equal(Amount{1.1, "test"}, ledger.ExchangeRate)
	}
}

func TestAccountOrdersIntegration(t *testing.T) {
	client, ts := setup(t, "GET", "/2/accounts/1000000/orders", defSessionKey, accountOrdersJSON)
	defer ts.Close()

	if resp, err := client.AccountOrders(1000000, &Params{}); err != nil {
		t.Fatal(err)
	} else {
		assert := assert.New(t)

		assert.NotEmpty(resp)

		order := resp[0]
		assert.EqualValues(123, order.Accno)
		assert.EqualValues(123, order.OrderId)
		assert.Equal(Amount{1.1, "test"}, order.Price)
		assert.Equal(1.1, order.Volume)
		assert.Equal(TradableId{"test", 123}, order.Tradable)
		assert.Equal(1.1, order.OpenVolume)
		assert.Equal(1.1, order.TradedVolume)
		assert.Equal("test", order.Side)
		assert.EqualValues(123, order.Modified)
		assert.Equal("test", order.Reference)
		assert.Equal(ActivationCondition{"test", 1.1, 1.1, "test"}, order.ActivationCondition)
		assert.Equal("test", order.PriceCondition)
		assert.Equal("test", order.VolumeCondition)
		assert.Equal(Validity{"test", 123}, order.Validity)
		assert.Equal("test", order.ActionState)
		assert.Equal("test", order.OrderState)
	}
}

func TestCreateOrderIntegration(t *testing.T) {
	client, ts := setup(t, "POST", "/2/accounts/1000000/orders?currency=SEK&identifier=101&market_id=11&price=65&side=buy&volume=100", defSessionKey, orderJSON)
	defer ts.Close()

	params := &Params{"identifier": "101", "market_id": "11", "price": "65", "volume": "100", "side": "buy", "currency": "SEK"}
	if resp, err := client.CreateOrder(1000000, params); err != nil {
		t.Fatal(err)
	} else {
		assert := assert.New(t)

		assertOrder(assert, resp)
	}
}

func TestActivateOrderIntegration(t *testing.T) {
	client, ts := setup(t, "PUT", "/2/accounts/1000000/orders/1000/activate", defSessionKey, orderJSON)
	defer ts.Close()

	if resp, err := client.ActivateOrder(1000000, 1000); err != nil {
		t.Fatal(err)
	} else {
		assert := assert.New(t)

		assertOrder(assert, resp)
	}
}

func TestUpdateOrderIntegration(t *testing.T) {
	client, ts := setup(t, "PUT", "/2/accounts/1000000/orders/1000?currency=SEK&price=65&volume=100", defSessionKey, orderJSON)
	defer ts.Close()

	params := &Params{"price": "65", "volume": "100", "currency": "SEK"}
	if resp, err := client.UpdateOrder(1000000, 1000, params); err != nil {
		t.Fatal(err)
	} else {
		assert := assert.New(t)

		assertOrder(assert, resp)
	}
}

func TestDeleteOrderIntegration(t *testing.T) {
	client, ts := setup(t, "DELETE", "/2/accounts/1000000/orders/1000", defSessionKey, orderJSON)
	defer ts.Close()

	if resp, err := client.DeleteOrder(1000000, 1000); err != nil {
		t.Fatal(err)
	} else {
		assert := assert.New(t)

		assertOrder(assert, resp)
	}
}

func TestAccountPositionsIntegration(t *testing.T) {
	client, ts := setup(t, "GET", "/2/accounts/1000000/positions", defSessionKey, accountPositionsJSON)
	defer ts.Close()

	if resp, err := client.AccountPositions(1000000); err != nil {
		t.Fatal(err)
	} else {
		assert := assert.New(t)

		assert.NotEmpty(resp)

		position := resp[0]
		assert.EqualValues(123, position.Accno)

		assert.NotEmpty(position.Instrument)

		instrument := position.Instrument
		assertInstrument(assert, &instrument)

		assert.Equal(1.1, position.Qty)
		assert.Equal(1.1, position.PawnPercent)
		assert.Equal(Amount{1.1, "test"}, position.MarketValueAcc)
		assert.Equal(Amount{1.1, "test"}, position.MarketValue)
		assert.Equal(Amount{1.1, "test"}, position.AcqPriceAcc)
		assert.Equal(Amount{1.1, "test"}, position.AcqPrice)
		assert.Equal(Amount{1.1, "test"}, position.MorningPrice)
	}
}

func TestAccountTradesIntegration(t *testing.T) {
	client, ts := setup(t, "GET", "/2/accounts/1000000/trades?days=7", defSessionKey, accountTradesJSON)
	defer ts.Close()

	params := &Params{"days": "7"}
	if resp, err := client.AccountTrades(1000000, params); err != nil {
		t.Fatal(err)
	} else {
		assert := assert.New(t)

		assert.NotEmpty(resp)

		trade := resp[0]
		assert.EqualValues(123, trade.Accno)
		assert.EqualValues(123, trade.OrderId)
		assert.Equal("test", trade.TradeId)
		assert.Equal(TradableId{"test", 123}, trade.Tradable)
		assert.Equal(Amount{1.1, "test"}, trade.Price)
		assert.Equal(1.1, trade.Volume)
		assert.Equal("test", trade.Side)
		assert.Equal("test", trade.Counterparty)
		assert.EqualValues(123, trade.Tradetime)
	}
}

func TestCountriesIntegration(t *testing.T) {
	client, ts := setup(t, "GET", "/2/countries", defSessionKey, countriesJSON)
	defer ts.Close()

	if resp, err := client.Countries(); err != nil {
		t.Fatal(err)
	} else {
		assert := assert.New(t)

		assert.NotEmpty(resp)

		country := resp[0]
		assert.Equal("test", country.Country)
		assert.Equal("test", country.Name)
	}
}

func TestLookupCountriesIntegration(t *testing.T) {
	client, ts := setup(t, "GET", "/2/countries/US,SV", defSessionKey, countriesJSON)
	defer ts.Close()

	if resp, err := client.LookupCountries("US,SV"); err != nil {
		t.Fatal(err)
	} else {
		assert := assert.New(t)

		assert.NotEmpty(resp)

		country := resp[0]
		assert.Equal("test", country.Country)
		assert.Equal("test", country.Name)
	}
}

func TestIndicatorsIntegration(t *testing.T) {
	client, ts := setup(t, "GET", "/2/indicators", defSessionKey, indicatorsJSON)
	defer ts.Close()

	if resp, err := client.Indicators(); err != nil {
		t.Fatal(err)
	} else {
		assert := assert.New(t)

		assert.NotEmpty(resp)

		indicator := resp[0]
		assertIndicator(assert, &indicator)
	}
}

func TestLookupIndicatorsIntegration(t *testing.T) {
	client, ts := setup(t, "GET", "/2/indicators/src:identifier,src:identifier", defSessionKey, indicatorsJSON)
	defer ts.Close()

	if resp, err := client.LookupIndicators("src:identifier,src:identifier"); err != nil {
		t.Fatal(err)
	} else {
		assert := assert.New(t)

		assert.NotEmpty(resp)

		indicator := resp[0]
		assertIndicator(assert, &indicator)
	}
}

func TestSearchInstrumentsIntegration(t *testing.T) {
	client, ts := setup(t, "GET", "/2/instruments?query=string", defSessionKey, instrumentsJSON)
	defer ts.Close()

	params := &Params{"query": "string"}
	if resp, err := client.SearchInstruments(params); err != nil {
		t.Fatal(err)
	} else {
		assert := assert.New(t)

		assert.NotEmpty(resp)

		instrument := resp[0]
		assertInstrument(assert, &instrument)
	}
}

func TestInstrumentsIntegration(t *testing.T) {
	client, ts := setup(t, "GET", "/2/instruments/1,2", defSessionKey, instrumentsJSON)
	defer ts.Close()

	if resp, err := client.Instruments("1,2"); err != nil {
		t.Fatal(err)
	} else {
		assert := assert.New(t)

		assert.NotEmpty(resp)

		instrument := resp[0]
		assertInstrument(assert, &instrument)
	}
}

func TestInstrumentLeveragesIntegration(t *testing.T) {
	client, ts := setup(t, "GET", "/2/instruments/0/leverages?currency=SEK", defSessionKey, instrumentsJSON)
	defer ts.Close()

	params := &Params{"currency": "SEK"}
	if resp, err := client.InstrumentLeverages(0, params); err != nil {
		t.Fatal(err)
	} else {
		assert := assert.New(t)

		assert.NotEmpty(resp)

		instrument := resp[0]
		assertInstrument(assert, &instrument)
	}
}

func TestInstrumentLeverageFiltersIntegration(t *testing.T) {
	client, ts := setup(t, "GET", "/2/instruments/0/leverages/filters?currency=SEK", defSessionKey, instrumentLeverageFiltersJSON)
	defer ts.Close()

	params := &Params{"currency": "SEK"}
	if resp, err := client.InstrumentLeverageFilters(0, params); err != nil {
		t.Fatal(err)
	} else {
		assert := assert.New(t)

		assert.NotEmpty(resp.Issuers)

		issuer := resp.Issuers[0]
		assert.Equal("test", issuer.Name)
		assert.EqualValues(123, issuer.IssuerId)

		assert.NotEmpty(resp.MarketView)
		assert.Equal("test", resp.MarketView[0])

		assert.NotEmpty(resp.ExpirationDates)
		assert.Equal("test", resp.ExpirationDates[0])

		assert.NotEmpty(resp.InstrumentTypes)
		assert.Equal("test", resp.InstrumentTypes[0])

		assert.NotEmpty(resp.InstrumentGroupTypes)
		assert.Equal("test", resp.InstrumentGroupTypes[0])

		assert.NotEmpty(resp.Currencies)
		assert.Equal("test", resp.Currencies[0])

		assert.EqualValues(123, resp.NoOfInstruments)
	}
}

func TestInstrumentOptionPairsIntegration(t *testing.T) {
	client, ts := setup(t, "GET", "/2/instruments/0/option_pairs?expiration_date=2015-01-01", defSessionKey, instrumentOptionPairsJSON)
	defer ts.Close()

	params := &Params{"expiration_date": "2015-01-01"}
	if resp, err := client.InstrumentOptionPairs(0, params); err != nil {
		t.Fatal(err)
	} else {
		assert := assert.New(t)

		assert.NotEmpty(resp)

		optionPair := resp[0]
		assert.Equal(1.1, optionPair.StrikePrice)
		assert.Equal("test", optionPair.ExpirationDate)

		assertInstrument(assert, &optionPair.Call)
		assertInstrument(assert, &optionPair.Put)
	}
}

func TestInstrumentOptionPairFiltersIntegration(t *testing.T) {
	client, ts := setup(t, "GET", "/2/instruments/0/option_pairs/filters?expiration_date=2015-01-01", defSessionKey, instrumentOptionPairFiltersJSON)
	defer ts.Close()

	params := &Params{"expiration_date": "2015-01-01"}
	if resp, err := client.InstrumentOptionPairFilters(0, params); err != nil {
		t.Fatal(err)
	} else {
		assert := assert.New(t)

		assert.NotEmpty(resp.ExpirationDates)

		assert.Equal("test", resp.ExpirationDates[0])
	}
}

func TestInstrumentLookupIntegration(t *testing.T) {
	client, ts := setup(t, "GET", "/2/instruments/lookup/market_id_identifier/11:101", defSessionKey, instrumentsJSON)
	defer ts.Close()

	if resp, err := client.InstrumentLookup("market_id_identifier", "11:101"); err != nil {
		t.Fatal(err)
	} else {
		assert := assert.New(t)

		assert.NotEmpty(resp)

		instrument := resp[0]
		assertInstrument(assert, &instrument)
	}
}

func TestInstrumentSectorsIntegration(t *testing.T) {
	client, ts := setup(t, "GET", "/2/instruments/sectors?group=test", defSessionKey, instrumentSectorsJSON)
	defer ts.Close()

	params := &Params{"group": "test"}
	if resp, err := client.InstrumentSectors(params); err != nil {
		t.Fatal(err)
	} else {
		assert := assert.New(t)

		assert.NotEmpty(resp)

		sector := resp[0]
		assert.Equal("test", sector.Sector)
		assert.Equal("test", sector.Group)
		assert.Equal("test", sector.Name)
	}
}

func TestInstrumentSectorIntegration(t *testing.T) {
	client, ts := setup(t, "GET", "/2/instruments/sectors/test", defSessionKey, instrumentSectorsJSON)
	defer ts.Close()

	if resp, err := client.InstrumentSector("test"); err != nil {
		t.Fatal(err)
	} else {
		assert := assert.New(t)

		assert.NotEmpty(resp)

		sector := resp[0]
		assert.Equal("test", sector.Sector)
		assert.Equal("test", sector.Group)
		assert.Equal("test", sector.Name)
	}
}

func TestInstrumentTypesIntegration(t *testing.T) {
	client, ts := setup(t, "GET", "/2/instruments/types", defSessionKey, instrumentTypeJSON)
	defer ts.Close()

	if resp, err := client.InstrumentTypes(); err != nil {
		t.Fatal(err)
	} else {
		assert := assert.New(t)

		assert.NotEmpty(resp)

		instrumentType := resp[0]
		assert.Equal("test", instrumentType.InstrumentType)
		assert.Equal("test", instrumentType.Name)
	}
}

func TestInstrumentTypeIntegration(t *testing.T) {
	client, ts := setup(t, "GET", "/2/instruments/types/test,test", defSessionKey, instrumentTypeJSON)
	defer ts.Close()

	if resp, err := client.InstrumentType("test,test"); err != nil {
		t.Fatal(err)
	} else {
		assert := assert.New(t)

		assert.NotEmpty(resp)

		instrumentType := resp[0]
		assert.Equal("test", instrumentType.InstrumentType)
		assert.Equal("test", instrumentType.Name)
	}
}

func TestInstrumentUnderlyingsIntegration(t *testing.T) {
	client, ts := setup(t, "GET", "/2/instruments/underlyings/leverage/SEK", defSessionKey, instrumentsJSON)
	defer ts.Close()

	if resp, err := client.InstrumentUnderlyings("leverage", "SEK"); err != nil {
		t.Fatal(err)
	} else {
		assert := assert.New(t)

		assert.NotEmpty(resp)

		instrument := resp[0]
		assertInstrument(assert, &instrument)
	}
}

func TestListsIntegration(t *testing.T) {
	client, ts := setup(t, "GET", "/2/lists", defSessionKey, listsJSON)
	defer ts.Close()

	if resp, err := client.Lists(); err != nil {
		t.Fatal(err)
	} else {
		assert := assert.New(t)

		assert.NotEmpty(resp)

		list := resp[0]
		assert.Equal("test", list.Symbol)
		assert.EqualValues(123, list.DisplayOrder)
		assert.EqualValues(123, list.ListId)
		assert.Equal("test", list.Name)
		assert.Equal("test", list.Country)
		assert.Equal("test", list.Region)
	}
}

func TestListIntegration(t *testing.T) {
	client, ts := setup(t, "GET", "/2/lists/123", defSessionKey, instrumentsJSON)
	defer ts.Close()

	if resp, err := client.List(123); err != nil {
		t.Fatal(err)
	} else {
		assert := assert.New(t)

		assert.NotEmpty(resp)

		instrument := resp[0]
		assertInstrument(assert, &instrument)
	}
}

func TestLoginIntegration(t *testing.T) {
	client, ts := setup(t, "POST", "/2/login?auth=SECRET&service=TEST", "", loginJSON)
	defer ts.Close()

	client.Credentials = "SECRET"
	client.Service = "TEST"

	if resp, err := client.Login(); err != nil {
		t.Fatal(err)
	} else {
		assert := assert.New(t)

		assert.NotEmpty(resp)

		assert.Equal("test", resp.Environment)
		assert.Equal("test", resp.SessionKey)
		assert.EqualValues(123, resp.ExpiresIn)

		pubFeed := resp.PublicFeed
		assert.Equal("test", pubFeed.Hostname)
		assert.EqualValues(123, pubFeed.Port)
		assert.Equal(true, pubFeed.Encrypted)

		privFeed := resp.PrivateFeed
		assert.Equal("test", privFeed.Hostname)
		assert.EqualValues(123, privFeed.Port)
		assert.Equal(true, privFeed.Encrypted)

		assert.Equal("test", client.SessionKey)
	}
}

func TestLogoutIntegration(t *testing.T) {
	client, ts := setup(t, "DELETE", "/2/login", defSessionKey, logoutJSON)
	defer ts.Close()

	if resp, err := client.Logout(); err != nil {
		t.Fatal(err)
	} else {
		assert := assert.New(t)

		assert.NotEmpty(resp)

		// in real situations logged_in should be false, but we're testing against null values
		assert.Equal(true, resp.LoggedIn)
	}
}

func TestTouchIntegration(t *testing.T) {
	client, ts := setup(t, "PUT", "/2/login", defSessionKey, touchJSON)
	defer ts.Close()

	if resp, err := client.Touch(); err != nil {
		t.Fatal(err)
	} else {
		assert := assert.New(t)

		assert.NotEmpty(resp)

		// in real situations logged_in should be false, but we're testing against null values
		assert.Equal(true, resp.LoggedIn)
	}
}

func TestMarketsIntegration(t *testing.T) {
	client, ts := setup(t, "GET", "/2/markets", defSessionKey, marketsJSON)
	defer ts.Close()

	if resp, err := client.Markets(); err != nil {
		t.Fatal(err)
	} else {
		assert := assert.New(t)

		assert.NotEmpty(resp)

		market := resp[0]
		assert.EqualValues(123, market.MarketId)
		assert.Equal("test", market.Country)
		assert.Equal("test", market.Name)
	}
}

func TestMarketIntegration(t *testing.T) {
	client, ts := setup(t, "GET", "/2/markets/123,123", defSessionKey, marketsJSON)
	defer ts.Close()

	if resp, err := client.Market("123,123"); err != nil {
		t.Fatal(err)
	} else {
		assert := assert.New(t)
		assert.NotEmpty(resp)

		market := resp[0]
		assert.EqualValues(123, market.MarketId)
		assert.Equal("test", market.Country)
		assert.Equal("test", market.Name)
	}
}

func TestNewsSearchIntegration(t *testing.T) {
	client, ts := setup(t, "GET", "/2/news?query=test", defSessionKey, newsJSON)
	defer ts.Close()

	params := &Params{"query": "test"}
	if resp, err := client.SearchNews(params); err != nil {
		t.Fatal(err)
	} else {
		assert := assert.New(t)
		assert.NotEmpty(resp)

		news := resp[0]
		assert.EqualValues(123, news.NewsId)
		assert.EqualValues(123, news.SourceId)
		assert.Equal("test", news.Headline)

		assert.NotEmpty(news.Instruments)
		assert.EqualValues(123, news.Instruments[0])

		assert.Equal("test", news.Type)
		assert.Equal("test", news.Lang)
		assert.EqualValues(123, news.Timestamp)
	}
}

func TestNewsIntegration(t *testing.T) {
	client, ts := setup(t, "GET", "/2/news/123,123", defSessionKey, newsItemJSON)
	defer ts.Close()

	if resp, err := client.News("123,123"); err != nil {
		t.Fatal(err)
	} else {
		assert := assert.New(t)
		assert.NotEmpty(resp)

		news := resp[0]
		assert.EqualValues(123, news.NewsId)
		assert.EqualValues(123, news.SourceId)
		assert.Equal("test", news.Headline)
		assert.Equal("test", news.Body)

		assert.NotEmpty(news.Instruments)
		assert.EqualValues(123, news.Instruments[0])

		assert.Equal("test", news.Type)
		assert.Equal("test", news.Lang)
		assert.EqualValues(123, news.Timestamp)
	}
}

func TestNewsSourcesIntegration(t *testing.T) {
	client, ts := setup(t, "GET", "/2/news_sources", defSessionKey, newsSourcesJSON)
	defer ts.Close()

	if resp, err := client.NewsSources(); err != nil {
		t.Fatal(err)
	} else {
		assert := assert.New(t)
		assert.NotEmpty(resp)

		source := resp[0]
		assert.Equal("test", source.Name)
		assert.EqualValues(123, source.SourceId)
		assert.Equal("test", source.Level)

		assert.NotEmpty(source.Countries)
		assert.Equal("test", source.Countries[0])
	}
}

func TestRealtimeAccessIntegration(t *testing.T) {
	client, ts := setup(t, "GET", "/2/realtime_access", defSessionKey, realtimeAccessJSON)
	defer ts.Close()

	if resp, err := client.RealtimeAccess(); err != nil {
		t.Fatal(err)
	} else {
		assert := assert.New(t)
		assert.NotEmpty(resp)

		access := resp[0]
		assert.EqualValues(123, access.MarketId)
		assert.EqualValues(123, access.Level)
	}
}

func TestTickSizesIntegration(t *testing.T) {
	client, ts := setup(t, "GET", "/2/tick_sizes", defSessionKey, tickSizesJSON)
	defer ts.Close()

	if resp, err := client.TickSizes(); err != nil {
		t.Fatal(err)
	} else {
		assert := assert.New(t)
		assert.NotEmpty(resp)

		tickSize := resp[0]
		assert.EqualValues(123, tickSize.TickSizeId)

		tickSizeInterval := tickSize.Ticks[0]
		assert.EqualValues(123, tickSizeInterval.Decimals)
		assert.Equal(1.1, tickSizeInterval.FromPrice)
		assert.Equal(1.1, tickSizeInterval.ToPrice)
		assert.Equal(1.1, tickSizeInterval.Tick)
	}
}

func TestTickSizeIntegration(t *testing.T) {
	client, ts := setup(t, "GET", "/2/tick_sizes/123,123", defSessionKey, tickSizesJSON)
	defer ts.Close()

	if resp, err := client.TickSize("123,123"); err != nil {
		t.Fatal(err)
	} else {
		assert := assert.New(t)
		assert.NotEmpty(resp)

		tickSize := resp[0]
		assert.EqualValues(123, tickSize.TickSizeId)

		tickSizeInterval := tickSize.Ticks[0]
		assert.EqualValues(123, tickSizeInterval.Decimals)
		assert.Equal(1.1, tickSizeInterval.FromPrice)
		assert.Equal(1.1, tickSizeInterval.ToPrice)
		assert.Equal(1.1, tickSizeInterval.Tick)
	}
}

func TestTradableInfoIntegration(t *testing.T) {
	client, ts := setup(t, "GET", "/2/tradables/info/11:101,13:101", defSessionKey, tradableInfoJSON)
	defer ts.Close()

	if resp, err := client.TradableInfo("11:101,13:101"); err != nil {
		t.Fatal(err)
	} else {
		assert := assert.New(t)
		assert.NotEmpty(resp)

		tradableInfo := resp[0]
		assert.EqualValues(123, tradableInfo.MarketId)
		assert.Equal(true, tradableInfo.Iceberg)

		calendarDay := tradableInfo.Calendar[0]
		assert.Equal("test", calendarDay.Date)
		assert.EqualValues(123, calendarDay.Open)
		assert.EqualValues(123, calendarDay.Close)

		orderType := tradableInfo.OrderTypes[0]
		assert.Equal("test", orderType.Type)
		assert.Equal("test", orderType.Name)
	}
}

func TestTradableIntradayIntegration(t *testing.T) {
	client, ts := setup(t, "GET", "/2/tradables/intraday/11:101,13:101", defSessionKey, tradableIntradayJSON)
	defer ts.Close()

	if resp, err := client.TradableIntraday("11:101,13:101"); err != nil {
		t.Fatal(err)
	} else {
		assert := assert.New(t)
		assert.NotEmpty(resp)

		tradableIntraday := resp[0]
		assert.EqualValues(123, tradableIntraday.MarketId)
		assert.Equal("test", tradableIntraday.Identifier)

		assert.NotEmpty(tradableIntraday.Ticks)

		tick := tradableIntraday.Ticks[0]
		assert.EqualValues(123, tick.Timestamp)
		assert.Equal(1.1, tick.Last)
		assert.Equal(1.1, tick.Low)
		assert.Equal(1.1, tick.High)
		assert.Equal(1.1, tick.Volume)
		assert.EqualValues(123, tick.NoOfTrades)
	}
}

func TestTradableTradesIntegration(t *testing.T) {
	client, ts := setup(t, "GET", "/2/tradables/trades/11:101,13:101", defSessionKey, tradableTradesJSON)
	defer ts.Close()

	if resp, err := client.TradableTrades("11:101,13:101"); err != nil {
		t.Fatal(err)
	} else {
		assert := assert.New(t)
		assert.NotEmpty(resp)

		tradableTrade := resp[0]
		assert.EqualValues(123, tradableTrade.MarketId)
		assert.Equal("test", tradableTrade.Identifier)

		assert.NotEmpty(tradableTrade.Trades)

		trade := tradableTrade.Trades[0]
		assert.Equal("test", trade.BrokerBuying)
		assert.Equal("test", trade.BrokerSelling)
		assert.EqualValues(123, trade.Volume)
		assert.Equal(1.1, trade.Price)
		assert.Equal("test", trade.TradeId)
		assert.Equal("test", trade.TradeType)
		assert.EqualValues(123, trade.TradeTimestamp)
	}
}

// Assert Order type
func assertOrder(assert *assert.Assertions, order *OrderReply) {
	assert.EqualValues(123, order.OrderId)
	assert.Equal("test", order.ResultCode)
	assert.Equal("test", order.OrderState)
	assert.Equal("test", order.ActionState)
	assert.Equal("test", order.Message)
}

// Assert Indicator type
func assertIndicator(assert *assert.Assertions, indicator *Indicator) {
	assert.Equal("test", indicator.Name)
	assert.Equal("test", indicator.Src)
	assert.Equal("test", indicator.Identifier)
	assert.EqualValues(123, indicator.Delayed)
	assert.Equal(true, indicator.OnlyEod)
	assert.Equal("test", indicator.Open)
	assert.Equal("test", indicator.Close)
	assert.Equal("test", indicator.Country)
	assert.Equal("test", indicator.Type)
	assert.Equal("test", indicator.Region)
	assert.EqualValues(123, indicator.InstrumentId)
}

// Assert Instrument type
func assertInstrument(assert *assert.Assertions, instrument *Instrument) {
	assert.EqualValues(123, instrument.InstrumentId)

	assert.NotEmpty(instrument.Tradables)
	tradable := instrument.Tradables[0]

	assert.EqualValues(123, tradable.MarketId)
	assert.Equal("test", tradable.Identifier)
	assert.EqualValues(123, tradable.TickSizeId)
	assert.Equal(1.1, tradable.LotSize)
	assert.EqualValues(123, tradable.DisplayOrder)

	assert.Equal("test", instrument.Currency)
	assert.Equal("test", instrument.InstrumentGroupType)
	assert.Equal("test", instrument.InstrumentType)
	assert.Equal(1.1, instrument.Multiplier)
	assert.Equal("test", instrument.Symbol)
	assert.Equal("test", instrument.IsinCode)
	assert.Equal("test", instrument.MarketView)
	assert.Equal(1.1, instrument.StrikePrice)
	assert.Equal(1.1, instrument.NumberOfSecurities)
	assert.Equal("test", instrument.ProspectusUrl)
	assert.Equal("test", instrument.ExpirationDate)
	assert.Equal("test", instrument.Name)
	assert.Equal("test", instrument.Sector)
	assert.Equal("test", instrument.SectorGroup)

	assert.NotEmpty(instrument.Underlyings)
	underlying := instrument.Underlyings[0]

	assert.EqualValues(123, underlying.InstrumentId)
	assert.Equal("test", underlying.Symbol)
	assert.Equal("test", underlying.IsinCode)
}

func setupTestServer(t *testing.T, method, path, session string, stubData []byte) *httptest.Server {
	handler := http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if r.Method != method {
			t.Fatal(errors.New(fmt.Sprintln("Method was expected to be:", method, "got:", r.Method)))
		} else if r.RequestURI != path {
			t.Fatal(errors.New(fmt.Sprintln("Path was expected to be:", path, "got:", r.RequestURI)))
		} else if auth := r.Header.Get("Authorization"); auth != "" {
			if decoded, err := base64.StdEncoding.DecodeString(auth[6:]); err != nil {
				t.Fatal(err)
			} else if userpass := session + ":" + session; userpass != string(decoded) {
				t.Fatal(errors.New(fmt.Sprintln("Session was expected to be:", userpass, "got:", string(decoded))))
			} else if userpass == ":" {
				t.Fatal(errors.New(fmt.Sprintln("No pass provided")))
			}
		}

		w.Write(stubData)
	})

	return httptest.NewServer(handler)
}

func setup(t *testing.T, method, path, session, stubData string) (*APIClient, *httptest.Server) {
	testServer := setupTestServer(t, method, path, session, []byte(stubData))
	client := &APIClient{URL: testServer.URL, Service: NNSERVICE, Version: NNAPIVERSION, SessionKey: session}
	return client, testServer
}
