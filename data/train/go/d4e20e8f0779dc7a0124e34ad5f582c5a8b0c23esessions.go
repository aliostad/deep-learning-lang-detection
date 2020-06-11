package middleware

import (
	"sync"
	"time"
)

type WxSessionManager struct {
	mLifeTime int64               // 存活时间
	mLock     sync.RWMutex        //互斥锁头
	mSessions map[string]*Session //session指针指向内容
}

// session 内容
type Session struct {
	lastTime time.Time              // 登录的时间已用来回收
	mValues  map[string]interface{} // session设置的具体值
}

var manager *WxSessionManager
var once sync.Once

func GetSessionManager(lifeTime int64) *WxSessionManager {
	once.Do(
		func() {
			manager = &WxSessionManager{
				mLifeTime: lifeTime,
				mSessions: make(map[string]*Session)}
		})
	// todo 定时回收
	go manager.GC()
	return manager

}

func (manager *WxSessionManager) Set(thirdPartyKey string, key string, value interface{}) {
	//加锁
	manager.mLock.Lock()
	defer manager.mLock.Unlock()
	session, ok := manager.mSessions[thirdPartyKey]
	if ok {
		session.mValues[key] = value
	} else {
		session := &Session{lastTime: time.Now(), mValues: make(map[string]interface{})}
		session.mValues[key] = value
		manager.mSessions[thirdPartyKey] = session
	}

}

func (manager *WxSessionManager) Get(thirdPartyKey string, key string) (interface{}, bool) {
	manager.mLock.RLock()
	defer manager.mLock.RUnlock()
	if session, ok := manager.mSessions[thirdPartyKey]; ok {
		if val, ok := session.mValues[key]; ok {
			return val, ok
		}
	}
	return nil, false
}

func (manager *WxSessionManager) AuthUser(thirdPartyKey string) bool {
	manager.mLock.RLock()
	defer manager.mLock.RUnlock()
	if _, ok := manager.mSessions[thirdPartyKey]; ok {
		return true
	} else {
		return false
	}
}

func (manager *WxSessionManager) GC() {
	manager.mLock.Lock()
	defer manager.mLock.Unlock()
	for sessionId, session := range manager.mSessions {
		if session.lastTime.Unix()+manager.mLifeTime > time.Now().Unix() {
			delete(manager.mSessions, sessionId)
		}
	}
	// 定时任务回收
	time.AfterFunc(time.Duration(manager.mLifeTime)*time.Second, func() { manager.GC() })
}
