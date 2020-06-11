package robinhood

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
)

const instrumentsURL = "https://api.robinhood.com/instruments/"

// Instrument holds basic information about a financial instrument.
type Instrument struct {
	ID              string
	Name            string
	Symbol          string
	URL             string
	QuoteURL        string `json:"quote"`
	FundamentalsURL string `json:"fundamentals"`
	MarketURL       string `json:"market"`
	BloombergID     string `json:"bloomberg_unique"`
	ListDate        string `json:"list_date"`
	State           string
	Country         string
	Tradeable       bool
}

type instrumentResponse struct {
	Results     []Instrument
	PreviousURL *string `json:"previous"`
	NextURL     *string `json:"next"`
}

// AllInstruments request a list of all available instruments from the Robinhood API
func AllInstruments() ([]Instrument, error) {
	var instruments []Instrument
	url := instrumentsURL
	for {
		ir, err := getInstruments(url)
		if err != nil {
			return nil, err
		}

		for _, inst := range ir.Results {
			instruments = append(instruments, inst)
		}

		if ir.NextURL == nil {
			break
		}
		url = *ir.NextURL
	}

	return instruments, nil
}

// InstrumentWithID requests a financial instrument with an instrument ID from the Robinhood API.
func InstrumentWithID(id string) (*Instrument, error) {
	url := instrumentsURL + id + "/"

	resp, err := http.Get(url)
	if err != nil {
		return nil, err
	}

	if resp.StatusCode != 200 {
		return nil, fmt.Errorf("instruments.go: non-ok response %s", resp.Status)
	}

	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return nil, err
	}

	inst := new(Instrument)
	if err := json.Unmarshal(body, inst); err != nil {
		return nil, err
	}

	return inst, nil
}

// InstrumentWithSymbol requests the financial instrument with a ticker symbol from the Robinhood API
func InstrumentWithSymbol(s string) (*Instrument, error) {
	url := instrumentsURL + fmt.Sprintf("?symbol=%s", s)

	for {
		ir, err := getInstruments(url)
		if err != nil {
			return nil, err
		}

		for _, inst := range ir.Results {
			if inst.Symbol == s {
				return &inst, nil
			}

		}

		if ir.NextURL == nil {
			break
		}

		url = *ir.NextURL
	}

	return nil, fmt.Errorf("instruments.go: failed to find instrument %s", s)
}

func getInstruments(url string) (*instrumentResponse, error) {
	resp, err := http.Get(url)
	if err != nil {
		return nil, err
	}

	if resp.StatusCode != 200 {
		return nil, fmt.Errorf("instruments.go: non-ok response %s", resp.Status)
	}

	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return nil, err
	}

	ir := new(instrumentResponse)
	if err := json.Unmarshal(body, ir); err != nil {
		return nil, err
	}
	return ir, nil
}
