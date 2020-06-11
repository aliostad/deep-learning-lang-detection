package minatsubot

type permissionManager struct {
	handler PermissionHandler
}

func (manager *permissionManager) setPermissionHandler(handler PermissionHandler) bool {
	if manager.handler != nil {
		return false
	}
	manager.handler = handler
	return true
}

func (manager *permissionManager) hasUserPermission(name, perm string) bool {
	if manager.handler == nil {
		return true
	}
	return manager.handler.HasUserPermission(name, perm)
}

func (manager *permissionManager) hasGroupPermission(name, perm string) bool {
	if manager.handler == nil {
		return true
	}
	return manager.handler.HasGroupPermission(name, perm)
}

func (manager *permissionManager) getManager() PermissionHandler {
	return manager.handler
}
