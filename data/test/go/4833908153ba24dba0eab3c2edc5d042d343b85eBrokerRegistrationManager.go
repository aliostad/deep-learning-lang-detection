package registration

import (
	"encoding/json"
	"net/http"
	"bytes"
	"fmt"
	"io/ioutil"
	"net"
	"time"
	"sync"
	"net/url"
	"github.com/tkrex/IDS/common/models"
	"github.com/tkrex/IDS/daemon/persistence"
	"github.com/tkrex/IDS/daemon/configuration"
)

const RegisterInterval = time.Second * 10
//Manages the registration of the local Broker at the Information Discovery Gateway
type BrokerRegistrationManager struct {
	registrationServerAddress *url.URL
	registerTicker            *time.Ticker
	workerStarted             sync.WaitGroup
	workerStopped             sync.WaitGroup
	dbDelegate                *persistence.DomainInformationStorage
}

func NewBrokerRegistrationManager(registrationServerAddress *url.URL) *BrokerRegistrationManager {
	worker := new(BrokerRegistrationManager)
	worker.registrationServerAddress = registrationServerAddress
	worker.workerStarted.Add(1)
	worker.workerStopped.Add(1)
	go worker.registerBroker()
	worker.workerStarted.Wait()
	return worker
}


//Collects information about local MQTT Broker and sends a registration request to the Information Discovery Gateway
func (worker *BrokerRegistrationManager) registerBroker() {
	databaseWorker, err := persistence.NewDomainInformationStorage()
	if err != nil {
		fmt.Println("Database not reachable")
		return
	}
	worker.dbDelegate = databaseWorker
	worker.workerStarted.Done()

	if isBrokerRegistered := worker.isBrokerRegistered(); isBrokerRegistered {
		fmt.Println("Broker is already Registered")
		return
	}
	//TODO: Get IP address from Docker ENV

	daemonConfig := configuration.DaemonConfigurationManagerInstance().Config()

	broker := models.NewBroker()
	broker.IP = daemonConfig.BrokerURL.String()
	worker.findDomainNameForBroker(broker)
	worker.findRealWorldDomainsForBroker(broker)
	worker.findGeolocationForBroker(broker)

	worker.registerTicker = time.NewTicker(RegisterInterval)
	go func() {
		registrationSuccess := false
		defer worker.dbDelegate.Close()
		for _ = range worker.registerTicker.C {
			fmt.Println("RegistrationTicker Tick")
			if registrationSuccess {
				worker.registerTicker.Stop()
				break
			}
			registrationSuccess = worker.sendRegistrationRequestForBroker(broker)
		}
	}()
}

//Returns true if Broker is already registered. Thhe indicator is the ID, which is received when registering.
func (worker *BrokerRegistrationManager) isBrokerRegistered() bool {
	isBrokerRegistered := true
	broker, err := worker.dbDelegate.FindBroker()
	if err != nil {
		isBrokerRegistered = false
	} else if broker.ID == "" {
		isBrokerRegistered = false
	}
	return isBrokerRegistered
}

//Find Domain Name for Broker based on the IP Address via a Reverse DNS lookup
func (worker *BrokerRegistrationManager) findDomainNameForBroker(broker *models.Broker) {
	name, err := net.LookupAddr(broker.IP)
	if err != nil {
		broker.InternetDomain = ""
		return
	}
	broker.InternetDomain = name[0]
}

//Uses Website Categorizing API to determine Real World Domain of Broker
func (worker *BrokerRegistrationManager) findRealWorldDomainsForBroker(broker *models.Broker) {
	categorizer := NewWebsiteCategorizationWorker()
	categories, _ := categorizer.RequestCategoriesForWebsite("www.in.tum.de")
	domain := models.NewRealWorldDomain(categories[0])
	broker.RealWorldDomain = domain
}

func (worker *BrokerRegistrationManager) findGeolocationForBroker(broker *models.Broker) {
	geolocationFetcher := NewGeoLocationFetcher()
	location, err := geolocationFetcher.SendGeoLocationRequest(broker.IP)
	if err != nil {
		broker.Geolocation = new(models.Geolocation)
		return
	}
	broker.Geolocation = location
}


//Sends Registration request to Information Discovery Gateway
func (worker *BrokerRegistrationManager) sendRegistrationRequestForBroker(broker *models.Broker) bool {
	fmt.Println("Sending Broker Registration Request")

	jsonString, _ := json.Marshal(&broker)

	req, err := http.NewRequest("POST", worker.registrationServerAddress.String() + "/rest/brokers", bytes.NewBuffer(jsonString))
	req.Header.Set("Content-Type", "application/json")

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		fmt.Println(err)
		return false
	}
	defer resp.Body.Close()

	fmt.Println("response Status:", resp.Status)
	body, _ := ioutil.ReadAll(resp.Body)

	if resp.StatusCode != 200 {
		fmt.Println(resp.Status)
		fmt.Println(body)
		return false
	}

	response := new(models.BrokerRegistrationResponse)

	err = json.Unmarshal(body, &response)
	if err != nil {
		fmt.Println("REGISTER BROKER: Unkown response format")
		return false
	}

	err = worker.dbDelegate.StoreBroker(response.Broker)

	return true
}