package manager

import (
	"sync"

	"github.com/InnovaCo/serve-runner/logger"
)

func init() {
	GetInstance()
}

var instance Manager
var once sync.Once
var ManagerCtrl = "default"
var managerMap = map[string]Manager{}

func registry(name string, manager Manager) {
	managerMap[name] = manager
}

func GetInstance() Manager {
	once.Do(func() {
		if _, ok := managerMap[ManagerCtrl]; !ok {
			logger.Log.Info("Create default manage controller")
			ManagerCtrl = "default"
		}
		instance = managerMap[ManagerCtrl]
		instance.Init()
	})
	return instance
}

type Manager interface {
	Init() error
	Run() error
}
