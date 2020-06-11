package transports

import (
	"github.com/Forau/yanngo/api"
	"github.com/Forau/yanngo/httpcli"

	"encoding/json"

	"fmt"
)

func NewDefaultTransport(endpoint string, user, pass, rawPem []byte) (transp api.TransportHandler, err error) {
	restcli := httpcli.NewRestClient(endpoint, user, pass, rawPem)

	defTransp := make(api.RequestCommandTransport)
	transp = defTransp

	makeHandler := func(method, path string, pathArgs, postArgs []string) func(api.Params) (json.RawMessage, error) {
		return func(p api.Params) (json.RawMessage, error) {
			parsedPath := p.Sprintf(path, pathArgs...)
			res, err := restcli.Execute(method, parsedPath, p.SubParams(postArgs...))
			fmt.Printf("\nGot response from http: %+v\n\n", string(res))
			return res, err
		}
	}

	defTransp.AddCommand(string(api.SessionCmd)).Description("Get the current session from last login").
		Handler(makeHandler("SPECIAL", "session", []string{}, []string{}))

	defTransp.AddCommand(string(api.AccountsCmd)).Description("Get list of accounts").TTLHours(12).
		Handler(makeHandler("GET", "accounts", []string{}, []string{}))

	defTransp.AddCommand(string(api.AccountCmd)).Description("Get account info").
		AddArgument("accno").Handler(makeHandler("GET", "accounts/%v", []string{"accno"}, []string{}))

	defTransp.AddCommand(string(api.AccountLedgersCmd)).Description("AccountLedgersCmd").
		AddArgument("accno").Handler(makeHandler("GET", "accounts/%v/ledgers", []string{"accno"}, []string{}))

	defTransp.AddCommand(string(api.AccountOrdersCmd)).Description("AccountOrdersCmd").
		AddArgument("accno").Handler(makeHandler("GET", "accounts/%v/orders", []string{"accno"}, []string{}))

	defTransp.AddCommand(string(api.CreateOrderCmd)).Description("CreateOrderCmd").
		AddArgument("accno").
		AddArgument("identifier").
		AddArgument("market_id").
		AddArgument("price").
		AddArgument("currency").
		AddArgument("volume").
		AddFullArgument("side", "Buy or Sell", []string{"BUY", "SELL"}, false).
		AddFullArgument("order_type", "The order type", []string{"FAK", "FOK", "LIMIT", "STOP_LIMIT", "STOP_TRAILING", "OCO"}, true).
		AddOptArgument("valid_until").
		AddOptArgument("open_volume").
		AddOptArgument("reference").
		AddFullArgument("activation_condition", "Used for stop loss orders", []string{"STOP_ACTPRICE_PERC", "STOP_ACTPRICE", "MANUAL", "OCO_STOP_ACTPRICE"}, true).
		AddOptArgument("trigger_value").
		AddFullArgument("trigger_condition", "Condition to trigger", []string{"<=", ">="}, true).
		AddOptArgument("target_value").
		Handler(makeHandler("POST", "accounts/%v/orders", []string{"accno"},
			[]string{"identifier", "market_id", "price", "currency", "volume", "side", "order_type", "valid_until", "open_volume",
				"reference", "activation_condition", "trigger_value", "trigger_condition", "target_value"}))

	defTransp.AddCommand(string(api.ActivateOrderCmd)).Description("ActivateOrderCmd").
		AddArgument("accno").AddArgument("order_id").
		Handler(makeHandler("PUT", "accounts/%v/orders/%v/activate", []string{"accno", "order_id"}, []string{}))

	defTransp.AddCommand(string(api.UpdateOrderCmd)).Description("UpdateOrderCmd").
		AddArgument("accno").AddArgument("order_id").
		AddArgument("price").
		AddArgument("currency").
		AddArgument("volume").
		Handler(makeHandler("PUT", "accounts/%v/orders/%v", []string{"accno", "order_id"},
			[]string{"price", "currency", "volume"}))

	defTransp.AddCommand(string(api.DeleteOrderCmd)).Description("DeleteOrderCmd").
		AddArgument("accno").AddArgument("order_id").
		Handler(makeHandler("DELETE", "accounts/%v/orders/%v", []string{"accno", "order_id"}, []string{}))

	defTransp.AddCommand(string(api.AccountPositionsCmd)).Description("AccountPositionsCmd").
		AddArgument("accno").Handler(makeHandler("GET", "accounts/%v/positions", []string{"accno"}, []string{}))

	defTransp.AddCommand(string(api.AccountTradesCmd)).Description("AccountTradesCmd").
		AddArgument("accno").Handler(makeHandler("GET", "accounts/%v/trades", []string{"accno"}, []string{}))

	defTransp.AddCommand(string(api.CountriesCmd)).Description("CountriesCmd").TTLHours(12).
		AddFullArgument("countries", "Countries to query. Coma separated list", []string{}, true).
		Handler(makeHandler("GET", "countries/%v", []string{"countries"}, []string{}))

	defTransp.AddCommand(string(api.IndicatorsCmd)).Description("IndicatorsCmd").TTLHours(12).
		AddFullArgument("indicators", "Indicators to query. Format: SRC:ID,...", []string{}, true).
		Handler(makeHandler("GET", "indicators/%v", []string{"indicators"}, []string{}))

	defTransp.AddCommand(string(api.InstrumentsCmd)).Description("InstrumentsCmd").TTLHours(12).
		AddArgument("instruments").Handler(makeHandler("GET", "instruments/%v", []string{"instruments"}, []string{}))

	defTransp.AddCommand(string(api.InstrumentSearchCmd)).Description("InstrumentSearchCmd").
		AddArgument("query").AddOptArgument("instrument_group_type").AddOptArgument("limit").AddOptArgument("offset").
		AddFullArgument("fuzzy", "", []string{"true", "false"}, true).
		Handler(makeHandler("GET", "instruments", []string{}, []string{"query", "instrument_group_type", "limit", "offset", "fuzzy"}))

	defTransp.AddCommand(string(api.InstrumentLeveragesCmd)).Description("InstrumentLeveragesCmd").TTLHours(12).
		AddArgument("instrument").
		AddOptArgument("expiration_date").AddOptArgument("issuer_id").
		AddFullArgument("market_view", "Filter on market view", []string{"U", "D"}, true).
		AddOptArgument("instrument_type").AddOptArgument("instrument_group_type").AddOptArgument("currency").
		Handler(makeHandler("GET", "instruments/%v/leverages", []string{"instrument"},
			[]string{"expiration_date", "issuer_id", "market_view", "instrument_type", "instrument_group_type", "currency"}))

	defTransp.AddCommand(string(api.InstrumentLeverageFiltersCmd)).Description("InstrumentLeverageFiltersCmd").TTLHours(12).
		AddArgument("instrument").Handler(makeHandler("GET", "instruments/%v/leverages/filters", []string{"instrument"}, []string{}))

	defTransp.AddCommand(string(api.InstrumentOptionPairsCmd)).Description("InstrumentOptionPairsCmd").TTLHours(12).
		AddArgument("instrument").Handler(makeHandler("GET", "instruments/%v/option_pairs", []string{"instrument"}, []string{}))

	defTransp.AddCommand(string(api.InstrumentOptionPairFiltersCmd)).Description("InstrumentOptionPairFiltersCmd").TTLHours(12).
		AddArgument("instrument").Handler(makeHandler("GET", "instruments/%v/option_pairs/filters", []string{"instrument"}, []string{}))

	defTransp.AddCommand(string(api.InstrumentLookupCmd)).Description("InstrumentLookupCmd").TTLHours(12).
		AddFullArgument("type", "Lookup type", []string{"market_id_identifier", "isin_code_currency_market_id"}, false).
		AddFullArgument("lookup", "Format for market_id_identifier: [market_id]:[identifier].\nFormat for isin_code_currency_market_id: [isin]:[currency]:[market_id]", []string{}, false).
		Handler(makeHandler("GET", "instruments/lookup/%v/%v", []string{"type", "lookup"}, []string{}))

	defTransp.AddCommand(string(api.InstrumentSectorsCmd)).Description("InstrumentSectorCmd").TTLHours(12).
		AddFullArgument("sectors", "List of sectors to filter. Separated with comma.", []string{}, true).
		Handler(makeHandler("GET", "instruments/sectors/%v", []string{"sectors"}, []string{}))

	defTransp.AddCommand(string(api.InstrumentTypesCmd)).Description("InstrumentTypesCmd").TTLHours(12).
		AddFullArgument("types", "List of types to filter. Separated with comma.", []string{}, true).
		Handler(makeHandler("GET", "instruments/types/%v", []string{"types"}, []string{}))

	defTransp.AddCommand(string(api.InstrumentUnderlyingsCmd)).Description("InstrumentUnderlyingsCmd").TTLHours(12).
		AddFullArgument("type", "Derivative type", []string{"leverage", "option_pair"}, false).
		AddArgument("currency").
		Handler(makeHandler("GET", "instruments/underlyings/%v/%v", []string{"type", "currency"}, []string{}))

	defTransp.AddCommand(string(api.ListsCmd)).Description("ListsCmd").TTLHours(12).
		Handler(makeHandler("GET", "lists", []string{}, []string{}))

	defTransp.AddCommand(string(api.ListCmd)).Description("ListCmd").TTLHours(12).
		AddArgument("id").Handler(makeHandler("GET", "lists/%v", []string{"id"}, []string{}))

	defTransp.AddCommand(string(api.MarketCmd)).Description("MarketCmd").TTLHours(12).
		AddFullArgument("ids", "List of id's. Comma separated", []string{}, true).
		Handler(makeHandler("GET", "markets/%v", []string{"ids"}, []string{}))

	defTransp.AddCommand(string(api.SearchNewsCmd)).Description("SearchNewsCmd").
		Handler(makeHandler("GET", "news", []string{}, []string{}))

	defTransp.AddCommand(string(api.NewsCmd)).Description("NewsCmd").
		AddFullArgument("ids", "List of id's. Comma separated", []string{}, false).
		Handler(makeHandler("GET", "news/%v", []string{"ids"}, []string{}))

	defTransp.AddCommand(string(api.NewsSourcesCmd)).Description("NewsSourcesCmd").TTLHours(12).
		Handler(makeHandler("GET", "news_sources", []string{}, []string{}))

	defTransp.AddCommand(string(api.RealtimeAccessCmd)).Description("RealtimeAccessCmd").
		Handler(makeHandler("GET", "realtime_access", []string{}, []string{}))

	defTransp.AddCommand(string(api.TickSizeCmd)).Description("TickSizeCmd").TTLHours(12).
		AddFullArgument("ids", "List of id's. Comma separated", []string{}, true).
		Handler(makeHandler("GET", "tick_sizes/%v", []string{"ids"}, []string{}))

	defTransp.AddCommand(string(api.TradableInfoCmd)).Description("TradableInfoCmd").TTLHours(12).
		AddFullArgument("ids", "List of id's. Comma separated", []string{}, false).
		Handler(makeHandler("GET", "tradables/info/%s", []string{"ids"}, []string{}))

	defTransp.AddCommand(string(api.TradableIntradayCmd)).Description("TradableIntradayCmd").
		AddFullArgument("ids", "List of id's. Comma separated", []string{}, false).
		Handler(makeHandler("GET", "tradables/intraday/%s", []string{"ids"}, []string{}))

	defTransp.AddCommand(string(api.TradableTradesCmd)).Description("TradableTradesCmd").
		AddFullArgument("ids", "List of id's. Comma separated", []string{}, false).
		Handler(makeHandler("GET", "tradables/trades/%v", []string{"ids"}, []string{}))

	return
}
