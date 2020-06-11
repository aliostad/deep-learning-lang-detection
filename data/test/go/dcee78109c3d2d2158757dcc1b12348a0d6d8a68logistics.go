package models

import (
	//"common"
	//"time"
	//"strconv"
	//"common"
	//"strconv"
	//"time"
    "github.com/gin-gonic/gin"
    "common"
    "strconv"
    "time"
)

//物流员结构体
type Shop_logistics struct {
	Logistics_id   int `gorm:"primary_key"`
	Logistics_name string
	Token          string
	Client_type    string
	Password       string
	Login_time     int
	App_token      string
}

//物流单结构体
type Shop_v_dispatch struct {
	Dispatch_id int
	Order_sn    string
    Logistics_state string
}



func (l *Shop_logistics) GetLogisticsInfo(c *gin.Context) {
	//查找物流员的信息
    c.Db.Where(map[string]interface{}{"logistics_name":l.Logistics_name, "logistics_pwd": common.STMd5(l.Password)}).First(l)
}

func (l *Shop_logistics) UpdateToken(c *gin.Context) {
    //更新物流员登录token
    randomInt := strconv.FormatInt(time.Now().Unix(), 10) + common.RandNum() //randomInt由时间戳和一个随机数组成的一个int
    randomStr := l.Logistics_name + randomInt                                //物流员名字加上随机int产生的一个str
    updateMap := map[string]interface{}{
        "token" : common.STMd5(randomStr),
        "login_time" : int(time.Now().Unix()),
        "app_token" : l.App_token,
    }

    if c.Db.Model(l).Updates(updateMap).RowsAffected != 1 {
        //更新失败，设置token为nil
        l.Token = ""
    }
}

//判断是否登录
func (l *Shop_logistics) IsLogin(c *gin.Context) {
    selMap := map[string]interface{}{
        "token" : l.Token,
    }
    c.Db.Where(selMap).First(l)
}

func (d *Shop_v_dispatch) GetDispatchList(c *gin.Context, l *Shop_logistics) ([]map[string]interface{}, error) {
    var dispatchList []map[string]interface{}
    selMap := map[string]interface{}{
        "logistics_id" : l.Logistics_id,
    }
    rows, err := c.Db.Model(d).Limit(10).Where(selMap).Select("dispatch_id, order_sn, logistics_state").Rows()
    defer rows.Close()
	for rows.Next() {
		var d Shop_v_dispatch
        c.Db.ScanRows(rows, &d)
		if err != nil {
			//log.Fatalf("for err, %v", err)
            return dispatchList, err
		}

		args := map[string]interface{}{
			"dispatch_id": d.Dispatch_id,
			"order_sn":    d.Order_sn,
		}
		dispatchList = append(dispatchList, args)
	}
	return dispatchList, err
}


