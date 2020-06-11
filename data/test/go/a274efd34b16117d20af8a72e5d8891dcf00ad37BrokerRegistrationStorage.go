package brokerRegistration

import (
	"github.com/tkrex/IDS/common/models"
	"fmt"
	"time"
	"gopkg.in/mgo.v2"
	"gopkg.in/mgo.v2/bson"
)

const (
	Host = "localhost:27017"
	Database = "IDSGateway"
	BrokerCollection = "brokers"
	DomainCollection = "domains"
)
//Handles Storage of registered Brokers via a MongoDB
type BrokerRegistrationStorage struct {
	session *mgo.Session
}

func NewBrokerRegistrationStorage() *BrokerRegistrationStorage {
	worker := new(BrokerRegistrationStorage)

	session, err := mgo.DialWithTimeout(Host, time.Second * 3)
	if err != nil {
		return nil
	}
	fmt.Println("Connected to Database: ",Host)
	worker.session = session
	return worker
}

func (worker *BrokerRegistrationStorage) brokerCollection() *mgo.Collection {
	return worker.session.DB(Database).C(BrokerCollection)
}

func (worker *BrokerRegistrationStorage) domainCollection() *mgo.Collection {
	return worker.session.DB(Database).C(DomainCollection)
}



func (worker *BrokerRegistrationStorage) StoreDomain(domain *models.RealWorldDomain) error {
	coll := worker.domainCollection()
	index := mgo.Index{
		Key:        []string{"name"},
		Unique:     true,
		DropDups:   true,
		Background: true,
		Sparse:     true,
	}
	_ = coll.EnsureIndex(index)
	err := coll.Insert(domain)
	return  err
}

func (worker *BrokerRegistrationStorage) FindAllDomains() ([]*models.RealWorldDomain, error) {
	coll := worker.domainCollection()
	domains := []*models.RealWorldDomain{}
	var error error
	if error = coll.Find(nil).All(&domains); error != nil {
		fmt.Println(error)
	}
	return domains, error
}



func (worker *BrokerRegistrationStorage) StoreBroker(broker *models.Broker) (error) {
	coll := worker.brokerCollection()

	if err := coll.Insert(broker); err != nil {
		return err
	}
	worker.StoreDomain(broker.RealWorldDomain)
	return nil
}



func (worker *BrokerRegistrationStorage) FindAllBrokers() ([]*models.Broker, error) {
	coll := worker.brokerCollection()
	var brokers []*models.Broker
	var error error
	if error = coll.Find(nil).All(brokers); error != nil {
		fmt.Println(error)
	}
	return brokers, error
}

func (worker *BrokerRegistrationStorage) FindBrokerById(brokerID string) (*models.Broker, error) {
	coll := worker.brokerCollection()

	broker := new(models.Broker)
	if error := coll.Find(bson.M{"id":brokerID}).One(broker); error != nil {
		return nil, error
	}
	return broker, nil
}

func (worker *BrokerRegistrationStorage) Close() {
	worker.session.Close()
}