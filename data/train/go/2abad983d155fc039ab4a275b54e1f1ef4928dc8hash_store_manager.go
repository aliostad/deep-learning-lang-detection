package manager

import (
	"github.com/geminikim/minimem/constant"
	"github.com/geminikim/minimem/store"
)

type HashStoreManager struct {
	store *store.HashStore
}

func NewHashStoreManager() Manager {
	manager := new(HashStoreManager)
	manager.store = store.NewHashStore()
	return manager
}

func (manager HashStoreManager) Process(message Message) string {
	switch message.Command {
	case constant.GET: return manager.store.Get(message.Value[constant.KEY], message.Value[constant.FIELD])
	case constant.SET: return manager.store.Set(message.Value[constant.KEY], message.Value[constant.FIELD], message.Value[constant.VALUE])
	default: return constant.NOT_SUPPORTED_COMMAND
	}
}

func (manager HashStoreManager) GetType() string {
	return constant.HASH
}