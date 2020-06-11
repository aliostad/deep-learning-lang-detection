package models

import (
	"github.com/rmn87/m-cute/db"
	"github.com/boltdb/bolt"
)

func GetActive() (string, error) {
	var activeBrokerId string = ""

	if err := db.Get().View(func(tx *bolt.Tx) error {
		active := tx.Bucket([]byte("active"))
		activeBrokerIdBytes := active.Get([]byte("active_broker_id"))
		activeBrokerId = string(activeBrokerIdBytes)
		return nil
	}); err != nil {
		return "", err
	}

	return activeBrokerId, nil
}

func UpdateActive(id string) error {
	return db.Get().Update(func(tx *bolt.Tx) error {
		active, err := tx.CreateBucketIfNotExists([]byte("active"))
		if err != nil {
			return err
		}
		return active.Put([]byte("active_broker_id"),[]byte(id))
	})
}