package cache

import (
	c "github.com/patrickmn/go-cache"
	"time"
)

type CacheLoader func(string) (value interface{}, found bool)

type LoadCache struct {
	cache          *c.Cache
	UpdateInterval time.Duration
	CacheLoad      CacheLoader
}

type ValueTimePair struct {
	Value     interface{}
	Time      time.Time
	LoadFound bool
}

func (this *LoadCache) Get(k string) (interface{}, bool) {
	p, found := this.cache.Get(k)

	var pair *ValueTimePair

	if p == nil {
		pair = new(ValueTimePair)
	} else {
		pair = p.(*ValueTimePair)
	}

	// 几种情况
	// 1. 不存在
	// 2. 存在,如果过期了就加载,但是此次访问还是会返回值
	if this.CacheLoad != nil {
		if !found {
			// 不存在
			this.cache.Set(k, &ValueTimePair{Value:nil, Time:time.Now(), LoadFound:false}, c.DefaultExpiration)
			go this.loadCache(k)
		} else if pair.Time.Add(this.UpdateInterval).Before(time.Now()) {
			// 存在且过期
			// 设置一个时间上有效值,防止其他线程重复加载数据
			this.cache.Set(k, &ValueTimePair{Value:pair.Value, Time:time.Now(), LoadFound:pair.LoadFound}, c.DefaultExpiration)
			go this.loadCache(k)
		}
	}
	return pair.Value, found && pair.LoadFound
}

func (this *LoadCache) loadCache(k string) {
	loadValue, loadFound := this.CacheLoad(k)
	this.cache.Set(k, &ValueTimePair{Value:loadValue, Time:time.Now(), LoadFound:loadFound}, c.DefaultExpiration)
}

func (this *LoadCache) Set(k string, x interface{}) {
	this.cache.Set(k, &ValueTimePair{Value:x, Time:time.Now(), LoadFound:true}, c.DefaultExpiration)
}

func NewCache(Expiration time.Duration, UpdateInterval time.Duration, CacheLoad CacheLoader) (*LoadCache) {
	return &LoadCache{cache:c.New(Expiration, Expiration), UpdateInterval:UpdateInterval, CacheLoad:CacheLoad}
}
