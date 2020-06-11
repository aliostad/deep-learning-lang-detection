func (manager *Manager) SessionStart(w http.ResponseWriter, r *http.Request) {
    manager.lock.Lock()
    defer manager.lock.Unlock() 
    cookie, err := r.Cookie(manager.cookiename)
    if err != nil || cookie.Value == "" {
		sid := manager.sessionId()
		session, _ = manager.provider.SessionInit(sid)
		cookie := http.Cookie{Name: manager.cookiename, value: url.QueryEscape(sid), Path: "/", HttpOnly: true, MaxAge: int(manager.maxlifetime)}
		http.SetCookie(w, &cookie)
	} else {
		sid, _ =  url.QueryUnescape(cookie.Value)
		session, _ = manager.provider.SessionRead(sid)
	}
	return
}