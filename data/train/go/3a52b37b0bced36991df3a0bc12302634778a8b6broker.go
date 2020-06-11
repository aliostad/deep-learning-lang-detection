package broker

import (
	"fmt"
	"github.com/cloudfoundry-community/brooklyn-plugin/assert"
	"github.com/cloudfoundry/cli/cf/errors"
	"github.com/cloudfoundry/cli/plugin"
	"io/ioutil"
	"net/http"
	"net/url"
	"strings"
)

type BrokerCredentials struct {
	Broker   string
	Username string
	Password string
}

func NewBrokerCredentials(broker, username, password string) *BrokerCredentials {
	return &BrokerCredentials{broker, username, password}
}

func SendRequest(req *http.Request) ([]byte, error) {
	client := &http.Client{}
	resp, err := client.Do(req)
	assert.ErrorIsNil(err)
	defer resp.Body.Close()
	body, err := ioutil.ReadAll(resp.Body)
	if resp.Status != "200 OK" {
		fmt.Println("response Status:", resp.Status)
		fmt.Println("response Headers:", resp.Header)
		fmt.Println("response Body:", string(body))
	}
	return body, err
}

func ServiceBrokerUrl(cliConnection plugin.CliConnection, broker string) (string, error) {
	brokers, err := cliConnection.CliCommandWithoutTerminalOutput("service-brokers")
	assert.Condition(err == nil, "could not get service broker url")
	for _, a := range brokers {
		fields := strings.Fields(a)
		if fields[0] == broker {
			return fields[1], nil
		}
	}
	return "", errors.New("No such broker")
}

func CreateRestCallUrlString(cliConnection plugin.CliConnection, cred *BrokerCredentials, path string) string {
	brokerUrl, err := ServiceBrokerUrl(cliConnection, cred.Broker)
	assert.Condition(err == nil, "No such broker")
	brooklynUrl, err := url.Parse(brokerUrl)
	assert.Condition(err == nil, "Can't parse url")
	brooklynUrl.Path = path
	brooklynUrl.User = url.UserPassword(cred.Username, cred.Password)
	return brooklynUrl.String()
}
