package robinhood

import (
	"net/http"
)

type QuoteService service

func (s *QuoteService) GetQuote(p *Position) (*Quote, *http.Response, error) {
	i, _, err := s.client.Instruments.GetInstrumentFromPosition(p)
	if err != nil {
		return nil, nil, err
	}

	return s.GetQuoteFromInstrument(i)
}

func (s *QuoteService) GetQuoteFromInstrument(i *Instrument) (*Quote, *http.Response, error) {
	req, err := s.client.NewRequestWithFullUrl("GET", i.Quote, nil)
	if err != nil {
		return nil, nil, err
	}

	q := &Quote{}
	resp, err := s.client.Do(req, q)

	if err != nil {
		return nil, resp, err
	}

	return q, resp, err
}
