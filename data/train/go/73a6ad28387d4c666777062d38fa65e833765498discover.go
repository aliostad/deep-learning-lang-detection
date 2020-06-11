package hue

import (
	"encoding/json"
	"net/http"
)

// BrokerDetails represents the details of a single bridge as returned by the broker service
type BrokerDetails struct {
	ID                string `json:"id"`
	InternalIPAddress string `json:"internalipaddress"`
	MACAddress        string `json:"macaddress"`
}

// DiscoverBridges requests a list of known bridges from the Philips meethue broker service.
// It returns a slice of BrokerBridgeDetails or a non-nil error
// The list of BrokerBridgeDetails can have len 0 while error is nil.
// This means the request was successfull, but the broker did not return any details.
func DiscoverBridges() ([]BrokerDetails, error) {
	// request data from Philips' meethue broker service
	brokerResponse, err := http.Get("https://www.meethue.com/api/nupnp")
	if err != nil {
		return nil, err
	}
	defer brokerResponse.Body.Close()

	// create brokerBridgeDetails slice
	bd := make([]BrokerDetails, 0)

	// deocde response body into BrokerBridgeDetails slice
	err = json.NewDecoder(brokerResponse.Body).Decode(&bd)
	if err != nil {
		return nil, err
	}

	// all done
	return bd, nil
}
