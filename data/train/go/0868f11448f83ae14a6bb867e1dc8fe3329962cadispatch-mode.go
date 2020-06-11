package common

import (
	"cdnboss-middle-pro/modules/public"

	"github.com/labstack/echo"
)

//DispatchMode 调度模式接口
func DispatchMode(rg *echo.Group) {

	// 获取宕机调度模式
	rg.GET("/common/mode", public.ReqRelay(host))

	// 获取带宽调度模式
	rg.GET("/common/band/mode", public.ReqRelay(host))

	// 修改宕机调度模式 ...mode?mode=:mode
	rg.PUT("/common/mode", public.ReqRelay(host))

	// 修改带宽调度模式 .../band/mode?mode=:mode
	rg.PUT("/common/band/mode", public.ReqRelay(host))

	// 手动回收缓存组的带宽借用接口 ...groups/?id=:id
	rg.POST("/common/band/recovery/groups", public.ReqRelay(host))

}
