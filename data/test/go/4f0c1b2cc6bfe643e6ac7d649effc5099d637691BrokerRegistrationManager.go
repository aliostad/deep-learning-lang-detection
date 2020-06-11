package brokerRegistration

import (
	"github.com/tkrex/IDS/common/models"
	"crypto/md5"
	"fmt"
	"errors"
)

//Manages the Broker Registration
type BrokerRegistrationManager struct {
	registrationStorageDelegate *BrokerRegistrationStorage
}

func NewBrokerRegistrationManager() *BrokerRegistrationManager {
	manager := new(BrokerRegistrationManager)
	manager.registrationStorageDelegate = NewBrokerRegistrationStorage()
	return manager
}


//Handles incoming registration requests.
//Create ID for a new Broker.
//Stores information at database.
func (manager *BrokerRegistrationManager) RegisterBroker(broker *models.Broker) (*models.Broker, error) {

	brokerIdentificationString := broker.IP + broker.InternetDomain
	byteArray := []byte(brokerIdentificationString)
	md5Bytes := md5.Sum(byteArray)
	brokerID := fmt.Sprintf("%x", md5Bytes)

	var err error

	if manager.registrationStorageDelegate == nil {
		return nil, errors.New("Can't connect with database")
	}

	broker.ID = brokerID
	if broker,_ := manager.registrationStorageDelegate.FindBrokerById(brokerID); broker != nil {
		fmt.Println("Broker Already Registered")
	} else {
		if err = manager.registrationStorageDelegate.StoreBroker(broker); err != nil {
			return nil, err
		}
	}
	return broker, nil
}

func (manager *BrokerRegistrationManager) AvailableDomains() ([]*models.RealWorldDomain, error) {
	storageManager := NewBrokerRegistrationStorage()
	return storageManager.FindAllDomains()
}