package MeloyApi

import (
	"github.com/iwind/MeloyApi/plugins"
	"log"
)

// 插件管理器
type PluginManager struct {
	plugins []Plugin
}

// 插件定义
type Plugin interface {
	Name() string
	StartFunc(appDir string)
	ReloadFunc()
	StopFunc()
}

// 初始化
func (manager *PluginManager) Init() {
	if len(appConfig.Plugins) > 0 {
		for _, pluginName := range appConfig.Plugins {
			switch pluginName {
			case "watch":
				manager.Register(&plugins.WatchPlugin{})
			case "daemon":
				manager.Register(&plugins.DaemonPlugin{})
			}
		}
	}
}

// 添加插件
func (manager *PluginManager) Register(plugin Plugin) {
	manager.plugins = append(manager.plugins, plugin)
}

// 启动插件
func (manager *PluginManager) Start(appDir string) {
	for _, plugin := range manager.plugins {
		log.Println("start plugin", plugin.Name())
		plugin.StartFunc(appDir)
	}
}

// 重启插件
func (manager *PluginManager) Reload() {
	for _, plugin := range manager.plugins {
		plugin.ReloadFunc()
	}
}

// 停止插件
func (manager *PluginManager) Stop() {
	for i := len(manager.plugins) - 1; i >= 0; i -- {
		manager.plugins[i].StopFunc()
	}
}
