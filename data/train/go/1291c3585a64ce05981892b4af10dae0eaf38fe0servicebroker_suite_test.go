package servicebroker_test

import (
	"fmt"
	"github.com/go-martini/martini"
	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
	"github.com/pivotal-golang/lager/lagertest"
	"github.com/pivotalservices/servicebroker"
	"io/ioutil"
	"net/http"
	"net/http/httptest"
	"os"
	"path"
	"strings"

	"testing"
)

var (
	apiBroker  *martini.ClassicMartini
	testBroker *TestServiceBroker
	testLogger *lagertest.TestLogger
)

const (
	BROKER_USERNAME = "username"
	BROKER_PASSWORD = "password"
)

var _ = BeforeSuite(func() {
	testBroker = new(TestServiceBroker)
	os.Setenv("BROKER_USERNAME", BROKER_USERNAME)
	os.Setenv("BROKER_PASSWORD", BROKER_PASSWORD)

	testLogger = lagertest.NewTestLogger("broker-api-test")
	apiBroker = servicebroker.NewAPI(testBroker, testLogger)
})

func TestServicebroker(t *testing.T) {
	RegisterFailHandler(Fail)
	RunSpecs(t, "Servicebroker Suite")
}

func Fixture(name string) string {
	filePath := path.Join("fixtures", name)
	contents, err := ioutil.ReadFile(filePath)
	if err != nil {
		panic(fmt.Sprintf("Could not read fixture: %s", name))
	}

	return string(contents)
}

func Request(method, route, username, password string) *httptest.ResponseRecorder {
	return makeRequest(method, route, username, password, "")
}

func AuthorizedRequest(method, route, apiRequest string) *httptest.ResponseRecorder {
	return makeRequest(method, route, BROKER_USERNAME, BROKER_PASSWORD, apiRequest)
}

func makeRequest(method, route, username, password, apiRequest string) *httptest.ResponseRecorder {
	body := strings.NewReader(apiRequest)
	request, _ := http.NewRequest(method, route, body)
	if username != "" {
		request.SetBasicAuth(username, password)
	}
	request.Header.Add("Content-Type", "application/json")

	response := httptest.NewRecorder()
	apiBroker.ServeHTTP(response, request)
	return response
}
