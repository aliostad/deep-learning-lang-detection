package transports_test

import (
	"github.com/Forau/yanngo/api"
	"github.com/Forau/yanngo/transports"
	"testing"

	"net/http"
	"net/http/httptest"

	"io/ioutil"
	"os"
)

var pemData []byte

func init() {
	file, err := os.Open("../NEXTAPI_TEST_public.pem")
	if err != nil {
		panic(err)
	}
	pemData, err = ioutil.ReadAll(file)
	if err != nil {
		panic(err)
	}
}

func genCmd(cmd api.RequestCommand, q map[string]string) *api.Request {
	req, err := api.NewRequest(cmd, q)
	if err != nil {
		panic(err)
	}
	return req
}

// TODO: mocking
func TestCommands(t *testing.T) {
	ts := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		t.Logf("HTTP-SRV: %s -> %s", r.Method, r.URL)
		w.Write([]byte(r.URL.String()))

		// TODO: ......
	}))
	defer ts.Close()

	tr, err := transports.NewDefaultTransport(ts.URL, []byte("kalle"), []byte("hemlig"), pemData)
	if err != nil {
		t.Fatal(err)
	}

	cmds := []*api.Request{
		genCmd(api.AccountsCmd, nil),
		genCmd(api.AccountCmd, nil),
		genCmd(api.AccountLedgersCmd, nil),
		genCmd(api.AccountOrdersCmd, nil),
		genCmd(api.CreateOrderCmd, nil),
		genCmd(api.ActivateOrderCmd, nil),
		genCmd(api.UpdateOrderCmd, nil),
		genCmd(api.DeleteOrderCmd, map[string]string{"Accno": "123", "Id": "321"}),
		genCmd(api.AccountPositionsCmd, nil),
		genCmd(api.AccountTradesCmd, nil),
		genCmd(api.CountriesCmd, nil),
		genCmd(api.IndicatorsCmd, nil),
		genCmd(api.InstrumentSearchCmd, nil),
		genCmd(api.InstrumentsCmd, nil),
		genCmd(api.InstrumentLeveragesCmd, nil),
		genCmd(api.InstrumentLeverageFiltersCmd, nil),
		genCmd(api.InstrumentOptionPairsCmd, nil),
		genCmd(api.InstrumentOptionPairFiltersCmd, nil),
		genCmd(api.InstrumentLookupCmd, nil),
		genCmd(api.InstrumentSectorsCmd, nil),
		genCmd(api.InstrumentSectorCmd, nil),
		genCmd(api.InstrumentTypesCmd, nil),
		genCmd(api.InstrumentUnderlyingsCmd, nil),
		genCmd(api.ListsCmd, nil),
		genCmd(api.ListCmd, nil),
		genCmd(api.MarketCmd, nil),
		genCmd(api.SearchNewsCmd, nil),
		genCmd(api.NewsCmd, nil),
		genCmd(api.NewsSourcesCmd, nil),
		genCmd(api.RealtimeAccessCmd, nil),
		genCmd(api.TickSizesCmd, nil),
		genCmd(api.TickSizeCmd, nil),
		genCmd(api.TradableInfoCmd, nil),
		genCmd(api.TradableIntradayCmd, nil),
		genCmd(api.TradableTradesCmd, nil),
	}

	for _, req := range cmds {
		res := tr.Preform(req)
		t.Log(res.String())
	}
}
