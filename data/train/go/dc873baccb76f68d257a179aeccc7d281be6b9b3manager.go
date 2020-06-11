package session

import (
	"sync"
	"net/http"
	"io"
	"crypto/rand"
	"encoding/base64"
	"net/url"
	"time"
)
type Manager struct {
    managerName  string     //private cookiename
    lock        sync.Mutex // protects session
    provider    Provider
    maxlifetime int64
}

var GlobalSessions *Manager

//然后在init函数中初始化
func init() {
    GlobalSessions = NewManager("sessionid", 3600)

    // globalSessions.
    go GlobalSessions.GC()
}
//init a session manager using manager_name and maxlifetime
//in current version, manager_name is sessionid
func NewManager(managerName string, maxlifetime int64) *Manager {
	provider := pder//pder init in provider
    return &Manager{provider: provider, managerName: managerName, maxlifetime: maxlifetime}
}

//generate a new 32 byte long session id
func (manager *Manager) sessionId() string {
    b := make([]byte, 32)
    if _, err := io.ReadFull(rand.Reader, b); err != nil {
        return ""
    }
    return base64.URLEncoding.EncodeToString(b)
}

//when start a new session, get current sid stored in user's browser
//if not exist, instance a new session and return

//we store the sessionid in client and the session in server memory
func (manager *Manager) SessionStart(w http.ResponseWriter, r *http.Request) (session Session) {
    manager.lock.Lock()
    defer manager.lock.Unlock()
    cookie, err := r.Cookie(manager.managerName)
    if err != nil || cookie.Value == "" {
        sid := manager.sessionId()
        session, _ = manager.provider.SessionInit(sid)
        cookie := http.Cookie{Name: manager.managerName, Value: url.QueryEscape(sid), Path: "/", HttpOnly: true, 
        MaxAge: int(manager.maxlifetime)}
        http.SetCookie(w, &cookie)
    } else {
        sid, _ := url.QueryUnescape(cookie.Value)
        session, _ = manager.provider.SessionRead(sid)
    }
    return session
}

//Destroy sessionid
func (manager *Manager) SessionDestroy(w http.ResponseWriter, r *http.Request){
    cookie, err := r.Cookie(manager.managerName)
    if err != nil || cookie.Value == "" {
        return
    } else {
        manager.lock.Lock()
        defer manager.lock.Unlock()
        manager.provider.SessionDestroy(cookie.Value)
        expiration := time.Now()
        cookie := http.Cookie{Name: manager.managerName, Path: "/", HttpOnly: true, Expires: expiration, MaxAge: -1}
        http.SetCookie(w, &cookie)
    }
}

func (manager *Manager) GC() {
    manager.lock.Lock()
    defer manager.lock.Unlock()
    manager.provider.SessionGC(manager.maxlifetime)
    time.AfterFunc(5*60*time.Second, func() { manager.GC() })
}