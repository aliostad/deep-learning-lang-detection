package load

import (
	"monitor/server/base"
	"fmt"
	db "monitor/server/db/mysqldb"

)

func InsertLoadDB(js base.SysLoadInfo,serverid int64){
	db := db.ConnDB()
	load := new(Collect_load)
	load.ServerId = serverid
	load.AvgStatload1 = js.AvgStat.Load1
	load.AvgStatload5 = js.AvgStat.Load5
	load.AvgStatload15 = js.AvgStat.Load15
	load.MiscStatprocsRunning = js.MiscStat.ProcsRunning
	load.MiscStatprocsBlocked = js.MiscStat.ProcsBlocked
	load.MiscStatctxt = js.MiscStat.Ctxt
	load.TimeStamp = js.TimeStamp
	affected, err := db.Insert(load)
	if err != nil{
		fmt.Println(err)
	}
	fmt.Println(affected)
}