// OrderMonitorController
package controllers

import (
	"POIWolaiMonitor/libs"
	"POIWolaiMonitor/models"
	"encoding/json"
	"fmt"
	"strconv"

	"github.com/astaxie/beego"
	page "github.com/astaxie/beego/utils/pagination"
)

type POIOrderMonitorController struct {
	beego.Controller
}

func (c *POIOrderMonitorController) OrderMonitor() {
	c.Layout = "layout/layout_monitor.tpl"
	c.TplNames = "monitor/order_monitor.tpl"
	resp := models.POIMonitorOrderResponse{}
	content, _ := libs.ParseGetRequest(libs.MONITOR_ORDER_URL, nil)
	json.Unmarshal([]byte(content), &resp)
	dispatchOrders := make([]*models.POIOrder, 0)
	orderDispatchInfo := resp.Content.OrderDispatchInfo
	for _, master := range orderDispatchInfo {
		order := models.QueryOrderById(master.MasterId)
		var dispatchdTeachers string
		for _, slave := range master.Slaves {
			teacher := models.QueryUserById(slave.SlaveId)
			teacherInfo := fmt.Sprintf("%s(%d)", teacher.Nickname, slave.SlaveId)
			dispatchdTeachers = dispatchdTeachers + "," + teacherInfo
		}
		if len(dispatchdTeachers) > 0 {
			order.DispatchdTeachers = dispatchdTeachers[1:]
		}
		dispatchOrders = append(dispatchOrders, order)
	}

	//	teacherOrderDispatchInfo := resp.Content.TeacherOrderDispatchInfo
	//	userOrderDispatchInfo := resp.Content.UserOrderDispatchInfo
	c.Data["dispatchOrders"] = dispatchOrders
	c.Data["type"] = "order"
}

func (c *POIOrderMonitorController) OrderQuery() {
	c.Layout = "layout/layout_monitor.tpl"
	c.TplNames = "monitor/order_query.tpl"
	count := models.GetOrdersCount()
	if count > 0 {
		p := page.NewPaginator(c.Ctx.Request, 10, count)
		orders := models.QueryOrders(p.Offset(), 10)
		c.Data["data"] = orders
		c.Data["paginator"] = p
	}
	c.Data["type"] = "order"
}

func (c *POIOrderMonitorController) GetOrderDispatch() {
	c.Layout = "layout/layout_monitor.tpl"
	orderIdStr := c.Input().Get("orderId")
	fmt.Println("aaaaa:", orderIdStr)
	orderId, _ := strconv.ParseInt(orderIdStr, 10, 64)
	orderDispatchs := models.QueryOrderDispatchByOrderId(orderId)
	if len(orderDispatchs) == 0 {
		c.Ctx.WriteString("没有分发记录！")
	} else {
		orderDispatchJson, _ := json.Marshal(orderDispatchs)
		c.Ctx.WriteString(string(orderDispatchJson))
	}
}
