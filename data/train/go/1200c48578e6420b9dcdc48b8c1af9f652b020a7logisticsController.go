package controllers

import (
	"common"
	"github.com/gin-gonic/gin"
	"models"
	"net/http"

)

//物流员默认api
func LogisticsIndex(c *gin.Context) {
	c.JSON(common.RESPONSE_STATUS_SUCCESS, gin.H{
		"message": "pong",
	})
}

//物流员登录
func LogisticsLogin(c *gin.Context) {
	//初始化结构体变量
	logistics := models.Shop_logistics{
		Logistics_name: c.PostForm("username"),
		Password:       c.PostForm("password"),
		Client_type:    c.PostForm("client"),
		App_token:      c.Request.Header.Get("devToken"),
	}

	//参数是否为空
	if common.IsNull([]string{logistics.Logistics_name, logistics.Password, logistics.Client_type}) {
		c.JSON(http.StatusOK, gin.H{
			"message": "miss params, login err",
		})
		return
	}

	//验证物流员信息并更新token，现在版本设置为单用户登录，另外一台设备登录会造成上一台掉线
	//更新登录token，极光appToken
	logistics.GetLogisticsInfo(c)
	if logistics.Logistics_id == 0 {
		c.JSON(http.StatusOK, gin.H{
            "code": 0,
			"message": "username or passwd error",
		})
		return
	}

	logistics.UpdateToken(c)

    if logistics.Token == "" {
        c.JSON(http.StatusOK, gin.H{
            "code": 0,
            "message": "login error",
        })
        return
    }

    c.JSON(http.StatusOK, gin.H{
        "code":          200,
        "logisticsInfo": logistics,
    })
}

//物流员订单列表
func LogisticsOrder(c *gin.Context) {
	logistics := models.Shop_logistics{
        Token:c.Request.Header.Get("token"),

	}
	dispatch := models.Shop_v_dispatch{

	}

	//判断是否登录
	logistics.IsLogin(c)
	if logistics.Logistics_id == 0 {
		c.JSON(http.StatusOK, gin.H{
            "code" :0,
			"message": "is not login",
		})
		return
	}

	//获取订单列表
	dispatchList, err := dispatch.GetDispatchList(c, &logistics)
    if err != nil {
        c.JSON(http.StatusOK, gin.H{
            "code": 0,
            "message": err,
        })
        return
    }

	c.JSON(http.StatusOK, gin.H{
        "code":200,
		"message": dispatchList,
	})
	return
}
