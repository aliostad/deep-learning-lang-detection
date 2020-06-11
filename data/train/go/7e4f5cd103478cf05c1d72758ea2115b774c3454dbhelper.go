package db

import (
	"sync"
)

// ZhihuManager 类的单例
var (
	zhihuInstance struct {
		*ZhihuManager
		sync.Mutex
	}

	weiboInstance struct {
		*WeiboManager
		sync.Mutex
	}
)

// GetZhihuInstance 获取数据库对象的单例
func GetZhihuInstance() *ZhihuManager {
	if zhihuInstance.ZhihuManager == nil {
		zhihuInstance.Lock()

		if zhihuInstance.ZhihuManager == nil {
			zhihuInstance.ZhihuManager = NewZhihuManager()
		}

		zhihuInstance.Unlock()
	}

	return zhihuInstance.ZhihuManager
}

// GetDefaultInstance 获取数据库对象的单例
func GetDefaultInstance() *WeiboManager {
	if weiboInstance.WeiboManager == nil {
		weiboInstance.Lock()

		if weiboInstance.WeiboManager == nil {
			weiboInstance.WeiboManager = NewWeiboManager()
		}

		weiboInstance.Unlock()
	}

	return weiboInstance.WeiboManager
}
