package manager

import (
	"github.com/geminikim/minimem/constant"
	"github.com/geminikim/minimem/store"
)

type StringStoreManager struct {
	store *store.StringStore
}

func NewStringStoreManager() Manager {
	manager := new(StringStoreManager)
	manager.store = store.NewStringStore()
	return manager
}

func (manager StringStoreManager) Process(message Message) string {
	switch message.Command {
	case constant.GET: return manager.store.Get(message.Value[constant.KEY])
	case constant.SET: return manager.store.Set(message.Value[constant.KEY], message.Value[constant.VALUE])
	default: return constant.NOT_SUPPORTED_COMMAND
	}
}

func (manager StringStoreManager) GetType() string {
	return constant.STRING
}