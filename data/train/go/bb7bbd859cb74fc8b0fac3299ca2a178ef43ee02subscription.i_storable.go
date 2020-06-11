package subscription

import (
	"github.com/ottemo/foundation/db"
	"github.com/ottemo/foundation/env"
	"time"
)

// GetID returns current ID of the Subscription
func (it *DefaultSubscription) GetID() string {
	return it.id
}

// SetID sets current ID of the current Subscription
func (it *DefaultSubscription) SetID(NewID string) error {
	it.id = NewID
	return nil
}

// Load will retrieve the Subscription information from database
func (it *DefaultSubscription) Load(ID string) error {

	collection, err := db.GetCollection(ConstCollectionNameSubscription)
	if err != nil {
		return env.ErrorDispatch(err)
	}

	values, err := collection.LoadByID(ID)
	if err != nil {
		return env.ErrorDispatch(err)
	}

	err = it.FromHashMap(values)
	return env.ErrorDispatch(err)
}

// Delete removes current Subscription from the database
func (it *DefaultSubscription) Delete() error {

	collection, err := db.GetCollection(ConstCollectionNameSubscription)
	if err != nil {
		return env.ErrorDispatch(err)
	}

	err = collection.DeleteByID(it.GetID())
	return env.ErrorDispatch(err)
}

// Save stores current Subscription to the database
func (it *DefaultSubscription) Save() error {

	collection, err := db.GetCollection(ConstCollectionNameSubscription)
	if err != nil {
		return env.ErrorDispatch(err)
	}

	// checking required fields for creating new subscription
	//	if err := it.Validate(); err != nil {
	//		return env.ErrorDispatch(err)
	//	}

	// update time depend values
	currentTime := time.Now()
	if it.CreatedAt.IsZero() {
		it.CreatedAt = currentTime
	}
	it.UpdatedAt = currentTime

	storingValues := it.ToHashMap()

	// saving operation
	newID, err := collection.Save(storingValues)
	if err != nil {
		return env.ErrorDispatch(err)
	}

	return it.SetID(newID)
}
