package init

import (
	c "ManageCenter/config"
	db "ManageCenter/service/db"
	manager "ManageCenter/service/model/managermodel"
	security "ManageCenter/utils/security"
	"fmt"

	log "github.com/inconshreveable/log15"
)

func InitManager() {
	s := db.Manager.GetSession()
	defer s.Close()
	count, err := manager.QueryManager(c.Cfg.ManagerUsername)
	if err != nil {
		log.Error(fmt.Sprintf("find manage err ", err))
	}
	if count == 0 {
		savedPassword := security.GeneratePasswordHash(c.Cfg.ManagerPassword)
		managerColl := new(manager.ManagerColl)
		managerColl.Managername = c.Cfg.ManagerUsername
		managerColl.Password = savedPassword
		managerColl.Save()
	}
}
