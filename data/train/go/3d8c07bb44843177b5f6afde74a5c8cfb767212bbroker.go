package models

import (
	"github.com/rmn87/m-cute/db"
	"github.com/boltdb/bolt"
	"gopkg.in/mgo.v2/bson"
	"encoding/json"
)
type Broker struct {
	Id 		bson.ObjectId 	`json:"id,omitempty"`
	Name 		string 		`json:"name"`
	Protocol 	string		`json:"protocol"`
	Hostname 	string		`json:"hostname"`
	Port 		int		`json:"port"`
	Username 	string		`json:"username"`
	Password 	string		`json:"password"`
	ClientId 	string		`json:"client_id"`
	Subs 		[]Sub 		`json:"subs,omitempty"`
}

func InitTestBrokers() {
	testBroker := NewBroker("MachineShop","mqtt.machineshop.io","tcp://","testBroker123","edge","edge123",1883)
	testBroker.Id = bson.ObjectIdHex("559306d71d41c8b846000002")
	testBroker.Subs = make([]Sub,2)
	testBroker.Subs[0] = *NewSub("p/u/reports/#",0)
	testBroker.Subs[1] = *NewSub("p/d/config/#",1)

	testBroker.Save()
}

func NewBroker(name, hostname, protocol, clientId, username, password string, port int) *Broker {
	return &Broker{
		Id: 		bson.NewObjectId(),
		Name: 		name,
		Hostname: 	hostname,
		Protocol: 	protocol,
		Port:	 	port,
		Username: 	username,
		Password: 	password,
		ClientId: 	clientId,
	}
}

func GetBrokers() (map[string]Broker, error) {
	brokers := make(map[string]Broker)

	if err := db.Get().View(func(tx *bolt.Tx) error {
		brokersBucket := tx.Bucket([]byte("brokers"))
		if err := brokersBucket.ForEach(func(id, b []byte) error {
			broker := &Broker{}
			if err := json.Unmarshal(b,broker); err == nil {
				brokers[string(id)] = *broker
			}
			return nil
		}); err != nil {
			return err
		}
		return nil
	}); err != nil {
		return nil, err
	}

	return brokers, nil
}

func GetBrokerById(id string) (Broker, error) {
	broker := &Broker{}

	if err := db.Get().View(func(tx *bolt.Tx) error {
		brokers := tx.Bucket([]byte("brokers"))
		brokerBytes := brokers.Get([]byte(id))
		if err := json.Unmarshal(brokerBytes,broker); err != nil {
			return err
		}
		return nil
	}); err != nil {
		return Broker{}, err
	}

	return *broker, nil
}

func (b *Broker) Save() error {
	return db.Get().Update(func(tx *bolt.Tx) error {
		brokers, err := tx.CreateBucketIfNotExists([]byte("brokers"))
		if err != nil {
			return err
		}
		encoded, err := json.Marshal(b)
		if err != nil {
			return err
		}
		return brokers.Put([]byte(b.Id.Hex()), encoded)
	})
}

func (b *Broker) Delete() error {
	return db.Get().Update(func(tx *bolt.Tx) error {
		brokers, err := tx.CreateBucketIfNotExists([]byte("brokers"))
		if err != nil {
			return err
		}
		return brokers.Delete([]byte(b.Id.Hex()))
	})
}

func DeleteBrokerById(id string) error {
	return db.Get().Update(func(tx *bolt.Tx) error {
		brokers, err := tx.CreateBucketIfNotExists([]byte("brokers"))
		if err != nil {
			return err
		}
		return brokers.Delete([]byte(id))
	})
}