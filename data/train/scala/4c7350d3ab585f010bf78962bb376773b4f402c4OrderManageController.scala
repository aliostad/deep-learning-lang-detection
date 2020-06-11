package xyz.uvwvu.controller.backend

import javax.servlet.http.HttpSession

import com.github.pagehelper.PageInfo
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Controller
import org.springframework.web.bind.annotation.{RequestMapping, RequestParam, ResponseBody}
import xyz.uvwvu.common.{Const, ResponseCode, ServerResponse}
import xyz.uvwvu.pojo.User
import xyz.uvwvu.service.{IOrderService, IUserService}
import xyz.uvwvu.vo.OrderVo

/**
  * Created by aurevoirxavier on 30/05/2017.
  */
@Controller
@RequestMapping(Array("/manage/order"))
class OrderManageController {
    @Autowired
    private[controller] var iUserService: IUserService = _
    @Autowired
    private[controller] var iOrderService: IOrderService = _

    @RequestMapping(Array("list.do"))
    @ResponseBody
    def orderList(session: HttpSession, @RequestParam(value = "pageNum", defaultValue = "1") pageNum: Int, @RequestParam(value = "pageSize", defaultValue = "10") pageSize: Int): ServerResponse[PageInfo[_]] = {
        val user = session.getAttribute(Const.CURRENT_USER).asInstanceOf[User]

        if (user == null) return ServerResponse.createByErrorCodeMessage(ResponseCode.NEED_LOGIN.id, "用户未登录,请登录管理员")

        if (iUserService.checkAdminRole(user).isSuccess) iOrderService.manageList(pageNum, pageSize)
        else ServerResponse.createByErrorMessage("无权限操作")
    }

    @RequestMapping(Array("detail.do"))
    @ResponseBody
    def orderDetail(session: HttpSession, orderNo: Long): ServerResponse[OrderVo] = {
        val user = session.getAttribute(Const.CURRENT_USER).asInstanceOf[User]

        if (user == null) return ServerResponse.createByErrorCodeMessage(ResponseCode.NEED_LOGIN.id, "用户未登录,请登录管理员")

        if (iUserService.checkAdminRole(user).isSuccess) iOrderService.manageDetail(orderNo)
        else ServerResponse.createByErrorMessage("无权限操作")
    }

    @RequestMapping(Array("search.do"))
    @ResponseBody
    def orderSearch(session: HttpSession, orderNo: Long, @RequestParam(value = "pageNum", defaultValue = "1") pageNum: Int, @RequestParam(value = "pageSize", defaultValue = "10") pageSize: Int): ServerResponse[PageInfo[_]] = {
        val user = session.getAttribute(Const.CURRENT_USER).asInstanceOf[User]

        if (user == null) return ServerResponse.createByErrorCodeMessage(ResponseCode.NEED_LOGIN.id, "用户未登录,请登录管理员")

        if (iUserService.checkAdminRole(user).isSuccess) iOrderService.manageSearch(orderNo, pageNum, pageSize)
        else ServerResponse.createByErrorMessage("无权限操作")
    }

    @RequestMapping(Array("send_goods.do"))
    @ResponseBody
    def sendOrderGoods(session: HttpSession, orderNo: Long): ServerResponse[String] = {
        val user = session.getAttribute(Const.CURRENT_USER).asInstanceOf[User]

        if (user == null) return ServerResponse.createByErrorCodeMessage(ResponseCode.NEED_LOGIN.id, "用户未登录,请登录管理员")

        if (iUserService.checkAdminRole(user).isSuccess) iOrderService.manageSendGoods(orderNo)
        else ServerResponse.createByErrorMessage("无权限操作")
    }
}