package services

import (
	implementationUser "github.com/AitorGuerrero/UserGo/adapters/user"
	implementationManager "github.com/AitorGuerrero/UserGo/adapters/user/manager"
	"github.com/AitorGuerrero/UserGo/user"
	"github.com/AitorGuerrero/UserGo/user/manager"
)
var userSource = implementationUser.Source{map[string]*user.User{}}
var managerSource = implementationManager.Source{map[string]*manager.Manager{}}

func UserSource() user.Source {
	return &userSource
}

func ManagerSource() manager.Source {
	return &managerSource
}
