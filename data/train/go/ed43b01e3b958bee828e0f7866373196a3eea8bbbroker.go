// Copyright © 2017 Circonus, Inc. <support@circonus.com>
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//

package reverse

import (
	"crypto/tls"
	"crypto/x509"
	"encoding/json"
	"io/ioutil"
	stdlog "log"
	"math/rand"
	"net"
	"net/url"
	"reflect"
	"regexp"
	"strconv"
	"strings"
	"time"

	"github.com/circonus-labs/circonus-agent/internal/config"
	"github.com/circonus-labs/circonus-gometrics/api"
	"github.com/pkg/errors"
	"github.com/spf13/viper"
)

func (c *Connection) getTLSConfig(cid string, reverseURL *url.URL) (*tls.Config, error) {
	if cid == "" {
		return nil, errors.New("No broker CID supplied")
	}
	if ok, _ := regexp.MatchString("^/broker/[0-9]+$", cid); !ok {
		return nil, errors.Errorf("Invalid broker CID (%s)", cid)
	}

	cfg := &api.Config{
		TokenKey: viper.GetString(config.KeyAPITokenKey),
		TokenApp: viper.GetString(config.KeyAPITokenApp),
		URL:      viper.GetString(config.KeyAPIURL),
		Log:      stdlog.New(c.logger.With().Str("pkg", "circonus-gometrics.api").Logger(), "", 0),
		Debug:    viper.GetBool(config.KeyDebugCGM),
	}

	client, err := api.New(cfg)
	if err != nil {
		return nil, errors.Wrap(err, "Initializing cgm API")
	}

	broker, err := client.FetchBroker(api.CIDType(&cid))
	if err != nil {
		return nil, errors.Wrapf(err, "Fetching broker (%s) from API", cid)
	}

	cn, err := c.getBrokerCN(broker, reverseURL)
	if err != nil {
		return nil, err
	}
	cert, err := c.fetchBrokerCA(client)
	if err != nil {
		return nil, err
	}
	cp := x509.NewCertPool()
	if !cp.AppendCertsFromPEM(cert) {
		return nil, errors.New("Unable to add Broker CA Certificate to x509 cert pool")
	}

	tlsConfig := &tls.Config{
		RootCAs:    cp,
		ServerName: cn,
	}

	c.logger.Debug().Str("CN", cn).Msg("setting tls CN")

	return tlsConfig, nil
}

func (c *Connection) getBrokerCN(broker *api.Broker, reverseURL *url.URL) (string, error) {
	host := reverseURL.Hostname()

	// OK...
	//
	// mtev_reverse can have an IP or an FQDN for the host portion
	// it used to be that when it was an IP, the CN was needed in order to verify TLS connections
	// otherwise, the FQDN was valid. now, the FQDN may be valid for the cert or it may not be...

	cn := ""

	for _, detail := range broker.Details {
		// certs are generated against the CN (in theory)
		// 1. find the right broker instance with matching IP or external hostname
		// 2. set the tls.Config.ServerName to whatever that instance's CN is currently
		// 3. cert will be valid for TLS conns (in theory)
		if detail.IP != nil && *detail.IP == host {
			cn = detail.CN
			break
		}
		if detail.ExternalHost != nil && *detail.ExternalHost == host {
			cn = detail.CN
			break
		}
	}

	if cn == "" {
		return "", errors.Errorf("Unable to match reverse URL host (%s) to broker", host)
	}

	return cn, nil
}

func (c *Connection) fetchBrokerCA(client *api.API) ([]byte, error) {
	// use local file if specified
	file := viper.GetString(config.KeyReverseBrokerCAFile)
	if file != "" {
		cert, err := ioutil.ReadFile(file)
		if err != nil {
			return nil, errors.Wrapf(err, "Reading specified broker-ca-file (%s)", file)
		}
		return cert, nil
	}

	// otherwise, try the api
	data, err := client.Get("/pki/ca.crt")
	if err != nil {
		return nil, errors.Wrap(err, "Fetching Broker CA certificate")
	}

	type cacert struct {
		Contents string `json:"contents"`
	}

	var cadata cacert

	if err := json.Unmarshal(data, &cadata); err != nil {
		return nil, errors.Wrap(err, "Parsing Broker CA certificate")
	}

	if cadata.Contents == "" {
		return nil, errors.Errorf("No Broker CA certificate in response (%#v)", string(data))
	}

	return []byte(cadata.Contents), nil
}

// Select a broker for use when creating a check, if a specific broker
// was not specified.
func (c *Connection) selectBroker(client *api.API, checkType string) (*api.Broker, error) {
	brokerList, err := client.FetchBrokers()
	if err != nil {
		return nil, errors.Wrap(err, "select broker")
	}

	if len(*brokerList) == 0 {
		return nil, errors.New("zero brokers found")
	}

	validBrokers := make(map[string]api.Broker)
	haveEnterprise := false

	for _, broker := range *brokerList {
		broker := broker
		if c.isValidBroker(&broker, checkType) {
			validBrokers[broker.CID] = broker
			if broker.Type == "enterprise" {
				haveEnterprise = true
			}
		}
	}

	if haveEnterprise { // eliminate non-enterprise brokers from valid brokers
		for k, v := range validBrokers {
			if v.Type != "enterprise" {
				delete(validBrokers, k)
			}
		}
	}

	if len(validBrokers) == 0 {
		return nil, errors.Errorf("found %d broker(s), zero are valid", len(*brokerList))
	}

	validBrokerKeys := reflect.ValueOf(validBrokers).MapKeys()
	selectedBroker := validBrokers[validBrokerKeys[rand.Intn(len(validBrokerKeys))].String()]

	c.logger.Debug().Str("broker", selectedBroker.Name).Msg("selected")

	return &selectedBroker, nil
}

// Is the broker valid (active, supports check type, and reachable)
func (c *Connection) isValidBroker(broker *api.Broker, checkType string) bool {
	var brokerHost string
	var brokerPort string
	valid := false
	for _, detail := range broker.Details {
		detail := detail

		// broker must be active
		if detail.Status != brokerActiveStatus {
			c.logger.Debug().Str("broker", broker.Name).Msg("not active, skipping")
			continue
		}

		// broker must have module loaded for the check type to be used
		if !c.brokerSupportsCheckType(checkType, &detail) {
			c.logger.Debug().Str("broker", broker.Name).Str("type", checkType).Msg("unsupported check type, skipping")
			continue
		}

		if detail.ExternalPort != 0 {
			brokerPort = strconv.Itoa(int(detail.ExternalPort))
		} else {
			if *detail.Port != 0 {
				brokerPort = strconv.Itoa(int(*detail.Port))
			} else {
				brokerPort = "43191"
			}
		}

		if detail.ExternalHost != nil && *detail.ExternalHost != "" {
			brokerHost = *detail.ExternalHost
		} else {
			brokerHost = *detail.IP
		}

		if brokerHost == "trap.noit.circonus.net" && brokerPort != "443" {
			brokerPort = "443"
		}

		minDelay := int(200 * time.Millisecond)
		maxDelay := int(2 * time.Second)

		for attempt := 1; attempt <= brokerMaxRetries; attempt++ {
			// broker must be reachable and respond within designated time
			conn, err := net.DialTimeout("tcp", net.JoinHostPort(brokerHost, brokerPort), brokerMaxResponseTime)
			if err == nil {
				conn.Close()
				valid = true
				break
			}

			delay := time.Duration(rand.Intn(maxDelay-minDelay) + minDelay)

			c.logger.Warn().
				Err(err).
				Str("delay", delay.String()).
				Str("broker", broker.Name).
				Int("attempt", attempt).
				Int("retries", brokerMaxRetries).
				Msg("unable to connect, retrying")

			time.Sleep(delay)
		}

		if valid {
			c.logger.Debug().Str("broker", broker.Name).Msg("valid")
			break
		}
	}
	return valid
}

// Verify broker supports the check type to be used
func (c *Connection) brokerSupportsCheckType(checkType string, details *api.BrokerDetail) bool {
	baseType := string(checkType)

	for _, module := range details.Modules {
		if module == baseType {
			return true
		}
	}

	if idx := strings.Index(baseType, ":"); idx > 0 {
		baseType = baseType[0:idx]
	}

	for _, module := range details.Modules {
		if module == baseType {
			return true
		}
	}

	return false
}
