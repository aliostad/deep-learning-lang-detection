package gorden

import (
    "net/http"
    "github.com/gorilla/sessions"
)

type Manager struct {
    strategy Strategy
    sessionConfig SessionConfig
    cookieStore *sessions.CookieStore
}

func (manager *Manager) Authenticate(arguments interface{}) bool {
    return manager.strategy.Authenticate(arguments)
}

func (manager *Manager) IsAuthenticated() bool {
    return manager.strategy.IsAuthenticated()
}

func (manager *Manager) SetUser(r *http.Request, w http.ResponseWriter, user_id int) {
    session, _ := manager.cookieStore.Get(r, manager.sessionConfig.CookieName)
    session.Values["user_id"] = user_id
    sessions.Save(r, w)
}

func (manager *Manager) GetUser(r *http.Request) interface{} {
    session, _ := manager.cookieStore.Get(r, manager.sessionConfig.CookieName)
    return session.Values["user_id"]
}

func NewManager(strategyName string, sessionConfig SessionConfig) *Manager {
    store := sessions.NewCookieStore(sessionConfig.CookieKey)
    strategyi, _ := strategies[strategyName]

    config := &Manager{
       strategy: strategyi,
       sessionConfig: sessionConfig,
       cookieStore: store,
    }

    return config
}