package manager

import (
	"github.com/server-forecaster/model/entity"
	"github.com/server-forecaster/utils"
	"time"
)

type UserManager struct {
	BaseManager
}

func (manager UserManager) AddUser(user *entity.User) bool {
	user.AuthToken = utils.MD5(time.Now().String())
	manager.DB.Create(&user)
	return !manager.DB.NewRecord(user)
}

func (manager UserManager) GetUserByAlias(alias string) *entity.User {
	user := entity.User{}
	manager.DB.Where("Alias = ?", alias).First(&user)
	if user.Alias == "" {
		return nil
	} else {
		return &user
	}
}

func (manager UserManager) GetUserByToken(token string) *entity.User {
	user := entity.User{}
	manager.DB.Where("auth_token = ?", token).First(&user)
	if user.Alias == "" {
		return nil
	} else {
		return &user
	}
}

func CreateUserManager() UserManager {
	return UserManager{BaseManager: Create()}
}
