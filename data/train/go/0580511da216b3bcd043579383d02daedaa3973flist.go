package list

import (
	"errors"
)

type LRUCache struct {
	value interface {}
}

type LRUCacheManager struct {
	MaxSize int
	Items []LRUCache
}

func NewLRUCacheManager(size int)  *LRUCacheManager {
	return &LRUCacheManager{size, make([]LRUCache, 0, size)}
}

func (manager *LRUCacheManager) FindIndex(v interface {}) int {
	for index, value := range manager.Items {
		if value == v {
			return index
		}
	}
	return -1
}

func (manager *LRUCacheManager) Append(v interface {}) {
	size := manager.MaxSize
	index := manager.FindIndex(v)

	if index != -1 {
		item := manager.Items[index]
		manager.Items = append(manager.Items[0:index], manager.Items[index:]...)
		manager.Items = append(manager.Items, item)
	} else {
		if size >= len(manager.Items) {
			manager.Items = manager.Items[1:size]
		}
		item := LRUCache{v}
		manager.Items = append(manager.Items, item)
	}
}

func (manager *LRUCacheManager) Get(index int) (interface {}, error) {
	if index >= len(manager.Items) || index < 0 {
		return nil, errors.New("Not Found Item by index")
	} else {
		return manager.Items[index].value, nil
	}
}

func (manager *LRUCacheManager) Len() int {
	return len(manager.Items)
}

func (manager *LRUCacheManager) Rest() int {
	length := manager.Len()
	return manager.MaxSize - length
}

func (manager *LRUCacheManager) Cap() int {
	return manager.MaxSize
}

func (manager *LRUCacheManager) List() []interface{} {
	var list = make([] interface {}, 0, len(manager.Items))

	for _, it := range manager.Items {
		list = append(list, it.value)
	}
	return list
}