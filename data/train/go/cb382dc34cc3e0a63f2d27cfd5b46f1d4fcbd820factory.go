package factory

import (
	"github.com/geminikim/minimem/constant"
	"github.com/geminikim/minimem/manager"
	"github.com/geminikim/minimem/handler"
)

func GetManagers() []manager.Manager {
	return []manager.Manager{
		manager.NewStringStoreManager(),
		manager.NewListStoreManager(),
		manager.NewHashStoreManager(),
	}
}

func GetHttpHandlers(managers []manager.Manager) []handler.HttpHandler {
	handlers := make([]handler.HttpHandler, len(managers))
	for index, manager := range managers {
		switch manager.GetType() {
		case constant.STRING: handlers[index] = handler.NewStringHttpHandler(manager)
		case constant.LIST: handlers[index] = handler.NewListHttpHandler(manager)
		case constant.HASH: handlers[index] = handler.NewHashHttpHandler(manager)
		}
	}
	return handlers
}