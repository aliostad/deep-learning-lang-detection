/*
	Digivance MVC Application Framework
	Session Manager Features
	Dan Mayor (dmayor@digivance.com)

	This file defines functionality for an in process browser session manager system. (E.g. per user
	server side memory map)

	This package is released under as open source under the LGPL-3.0 which can be found:
	https://opensource.org/licenses/LGPL-3.0
*/

package mvcapp

import (
	"time"

	"github.com/Digivance/str"
)

// SessionManager is the base struct that manages the collection
// of current http session models.
type SessionManager struct {
	Sessions       []*Session
	SessionTimeout time.Duration
}

// NewSessionManager returns a new Session Manager object
func NewSessionManager() *SessionManager {
	return &SessionManager{
		Sessions:       make([]*Session, 0),
		SessionTimeout: (900 * time.Second),
	}
}

// GetSession returns the current http session for the provided session id
func (manager *SessionManager) GetSession(id string) *Session {
	for key, val := range manager.Sessions {
		if str.Equals(val.ID, id) {
			return manager.Sessions[key]
		}
	}

	return manager.CreateSession(id)
}

// CreateSession creates and returns a new http session model
func (manager *SessionManager) CreateSession(id string) *Session {
	i := len(manager.Sessions)
	session := NewSession()
	session.ID = id
	manager.Sessions = append(manager.Sessions, session)
	return manager.Sessions[i]
}

// SetSession will set (creating if necessary) the provided session to
// the session manager collection
func (manager *SessionManager) SetSession(session *Session) {
	id := session.ID
	res := manager.GetSession(id)

	if res != nil {
		res = session
	} else {
		manager.Sessions = append(manager.Sessions, session)
	}
}

// DropSession will remove a session from the session manager collection based
// on the provided session id
func (manager *SessionManager) DropSession(id string) {
	for key, val := range manager.Sessions {
		if str.Equals(val.ID, id) {
			if key > 0 {
				manager.Sessions = append(manager.Sessions[:key-1], manager.Sessions[key:]...)
			} else {
				manager.Sessions = manager.Sessions[1:]
			}
		}
	}
}

// CleanSessions will drop inactive sessions
func (manager *SessionManager) CleanSessions() {
	expires := time.Now().Add(manager.SessionTimeout)

	for key, val := range manager.Sessions {
		if expires.After(val.ActivityDate) {
			if key > 0 {
				manager.Sessions = append(manager.Sessions[:key-1], manager.Sessions[key+1:]...)
			} else {
				manager.Sessions = manager.Sessions[1:]
			}
		}
	}
}
