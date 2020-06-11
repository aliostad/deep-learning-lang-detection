package buddy

import (
	"fmt"
	"net/url"
	"os"
	"strings"

	"github.com/pivotal-golang/lager"
)

// BackendBroker describes the location/creds for a backend broker providing actual services
type backendBroker struct {
	URL string
}

// LoadBackendBrokersFromEnv allows registration of backend brokers via environment variables
// BACKEND_BROKER=https://hostname1
func (b *AppHandler) LoadBackendBrokerFromEnv() {
	for _, e := range os.Environ() {
		pair := strings.Split(e, "=")
		if pair[0] == "BACKEND_BROKER" {
			backendURI := pair[1]
			uri, err := url.Parse(backendURI)
			if err != nil {
				b.Logger.Error("backend-brokers", fmt.Errorf("Could not parse $%s %s", pair[0], backendURI))
				continue
			}
			url := fmt.Sprintf("%s://%s", uri.Scheme, uri.Host)
			backendBroker := backendBroker{URL: url}
			b.BackendBroker = backendBroker
			b.Logger.Info("backend-broker", lager.Data{"backend-broker": url})
		}
	}
}
