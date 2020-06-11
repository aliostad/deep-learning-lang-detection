package http

import "sync"

// ServeManager 全局HTTP服务管理
var ServeManager *ServerManager

// ServerManager HTTP服务管理器
type ServerManager struct {
	sync.RWMutex
	servers map[string]*Server
}

// Register 注册服务到管理器
func (serverManager *ServerManager) Register(key string, server *Server) {
	serverManager.Lock()
	serverManager.servers[key] = server
	serverManager.Unlock()
}

// UnRegister 注消服务
func (serverManager *ServerManager) UnRegister(key string) {
	serverManager.Lock()
	delete(serverManager.servers, key)
	serverManager.Unlock()
}

// In 检查服务是否存在
func (serverManager *ServerManager) In(key string) bool {
	serverManager.Lock()
	defer serverManager.Unlock()

	if _, ok := serverManager.servers[key]; ok {
		return true
	}

	return false
}

// NewServerManager 创建服务管理器
func NewServerManager() *ServerManager {
	return &ServerManager{}
}

// init 默认启动管理器
func init() {
	ServeManager = NewServerManager()
}
