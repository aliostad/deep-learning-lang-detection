package mongo

import mgo "gopkg.in/mgo.v2"

// Manager will be in charge of creating all our stores for the application
type Manager struct {
	User    UserStore
	Company CompanyStore
}

var manager *Manager

// NewManager instantiates our manager variable for use throughout the application
func NewManager(session *mgo.Session, db string) {
	manager = &Manager{
		User:    NewUserStorage(db, "users", session),
		Company: NewCompanyStorage(db, "companies", session),
	}
}

// Manage is our caller to use the manager
func Manage() *Manager {
	return manager
}
