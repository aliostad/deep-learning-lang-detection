package session

import (
    "crypto/rand"
    "encoding/base64"
    //    "fmt"
    "io"
    "net/http"
    "net/url"
    "sync"
    "time"
)

type Manager struct {
    cookieName  string
    lock        sync.Mutex
    provider    Provider
    Maxlifetime int64
}

func NewManager(cookieName string, maxlifetime int64) (*Manager, error) {
    return &Manager{provider: *pder, cookieName: cookieName, Maxlifetime: maxlifetime}, nil
}

func (manager *Manager) SessionStart(w http.ResponseWriter, r *http.Request) (session Session) {
    manager.lock.Lock()
    defer manager.lock.Unlock()
    cookie, err := r.Cookie(manager.cookieName)
    if err != nil || cookie.Value == "" {
        sid := manager.sessionId()
        session, _ = manager.provider.SessionInit(sid)
        cookie := http.Cookie{Name: manager.cookieName, Value: url.QueryEscape(sid), Path: "/", HttpOnly: true, MaxAge: int(manager.Maxlifetime)}
        http.SetCookie(w, &cookie)
    } else {
        sid, _ := url.QueryUnescape(cookie.Value)
        session, _ = manager.provider.SessionRead(sid)
    }
    return
}

func (manager *Manager) SessionDestroy(w http.ResponseWriter, r *http.Request) {
    cookie, err := r.Cookie(manager.cookieName)
    if err != nil || cookie.Value == "" {
        return
    } else {
        manager.lock.Lock()
        defer manager.lock.Unlock()
        manager.provider.SessionDestroy(cookie.Value)
        expiration := time.Now()
        cookie := http.Cookie{Name: manager.cookieName, Path: "/", HttpOnly: true, Expires: expiration, MaxAge: -1}
        http.SetCookie(w, &cookie)
    }
}

func (manager *Manager) GC() {
    manager.lock.Lock()
    defer manager.lock.Unlock()
    manager.provider.SessionGC(manager.Maxlifetime)
    time.AfterFunc(time.Duration(manager.Maxlifetime)*time.Second, func() { manager.GC() })
}

func (manager *Manager) sessionId() string {
    b := make([]byte, 32)
    if _, err := io.ReadFull(rand.Reader, b); err != nil {
        return ""
    }
    return base64.URLEncoding.EncodeToString(b)
}
