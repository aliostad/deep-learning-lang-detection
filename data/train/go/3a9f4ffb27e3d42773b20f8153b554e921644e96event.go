package tinygo

import (
	"fmt"
)

// 管理器事件
type ManagerEvent interface {
	// Started 在Manager运行的时候触发
	Started(manager *Manager)
	// BeforeRunning 在每个App运行前触发
	BeforeRunning(manager *Manager, app App)
	// AferRunning 在每个App运行后触发
	AferRunning(manager *Manager, app App)
	// InitFailed 在App初始化出错的时候触发
	InitFailed(manager *Manager, app App, err error)
	// RunFailed 在每个App运行出错的时候触发
	RunFailed(manager *Manager, app App, err error)
	// RunPaniced 在每个App崩溃的时候触发
	RunPaniced(manager *Manager, app App, info interface{})
	// RunFinished 在每个App运行完毕的时候触发
	RunFinished(manager *Manager, app App)
	// Ended 在Manager停止运行时触发
	Ended(manager *Manager)
}

// 默认事件处理器
type DefaultManagerEvent struct {
}

// Started 在Manager运行的时候触发
func (this *DefaultManagerEvent) Started(manager *Manager) {

}

// BeforeRunning 在每个App运行前触发
func (this *DefaultManagerEvent) BeforeRunning(manager *Manager, app App) {

}

// AferRunning 在每个App运行后触发
func (this *DefaultManagerEvent) AferRunning(manager *Manager, app App) {

}

// InitFailed 在App初始化出错的时候触发
func (this *DefaultManagerEvent) InitFailed(manager *Manager, app App, err error) {
	fmt.Println(app.Name(), "App 初始化错误", err)
}

// RunFailed 在每个App运行出错的时候触发
func (this *DefaultManagerEvent) RunFailed(manager *Manager, app App, err error) {
	fmt.Println(app.Name(), "App 运行错误", err)
}

// RunPaniced 在每个App崩溃的时候触发
func (this *DefaultManagerEvent) RunPaniced(manager *Manager, app App, info interface{}) {
	fmt.Println(app.Name(), "App 崩溃", info)
}

// RunFinished 在每个App运行完毕的时候触发
func (this *DefaultManagerEvent) RunFinished(manager *Manager, app App) {

}

// Ended 在Manager停止运行时触发
func (this *DefaultManagerEvent) Ended(manager *Manager) {

}
