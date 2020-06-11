package dispatch

import (
	"cdnboss-middle-pro/modules/public"

	"github.com/labstack/echo"
)

// Line 线路接口, doType: glb - dispatch
func Line(rg *echo.Group) {

	// 获取全部线路
	rg.GET("/:doType/lines", public.ReqRelay(host))

	// 获取线路
	rg.GET("/:doType/lines/:lineId", public.ReqRelay(host))

	// 获取指定平台下的所有线路 - doType: dispatch
	rg.GET("/:doType/platforms/:platform_id/lines", public.ReqRelay(host))

	// 新建线路
	rg.POST("/:doType/lines", public.ReqRelay(host))

	// 修改线路
	rg.PUT("/:doType/lines/:lineId", public.ReqRelay(host))

}
