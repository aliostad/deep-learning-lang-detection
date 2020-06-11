package session

import (
	"net/http"
)

// Manager is the bridge between user's browser cookies and server side sessions
type Manager struct {
	cookieName  string //private cookiename
	Store       Store
	maxlifetime int64
}

// NewManager creates a new instance of manager
func NewManager(store Store, cookieName string) *Manager {
	return &Manager{
		Store:      store,
		cookieName: cookieName,
	}
}

// EnsureSession - ensure the current browser has a session
func (manager *Manager) EnsureSession(w http.ResponseWriter, r *http.Request) (session Interface, err error) {
	cookie, err := r.Cookie(manager.cookieName)
	if err != nil || cookie.Value == "" {
		return manager.createSession(w, r)
	}
	sid := ID(cookie.Value)
	session, err = manager.Store.Read(sid)
	if err != nil {
		return manager.createSession(w, r)
	}
	return session, nil
}

func (manager *Manager) createSession(w http.ResponseWriter, r *http.Request) (session Interface, err error) {
	session, err = manager.Store.InitSession()
	if err != nil {
		return nil, err
	}
	cookie := http.Cookie{Name: manager.cookieName, Value: string(session.ID()), Path: "/", HttpOnly: true, MaxAge: int(manager.maxlifetime)}
	http.SetCookie(w, &cookie)
	return session, nil
}
