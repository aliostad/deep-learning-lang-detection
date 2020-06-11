package xyz.uvwvu.controller.backend

import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Controller
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestMethod
import org.springframework.web.bind.annotation.ResponseBody
import xyz.uvwvu.common.Const
import xyz.uvwvu.common.ServerResponse
import xyz.uvwvu.pojo.User
import xyz.uvwvu.service.IUserService
import javax.servlet.http.HttpSession

/**
  * Created by aurevoirxavier on 10/05/2017.
  */
@Controller
@RequestMapping(Array("/manage/user"))
class UserManageController {
    @Autowired
    private[controller] var iUserService: IUserService = _

    @RequestMapping(value = Array("login.do"), method = Array(RequestMethod.POST))
    @ResponseBody
    def login(username: String, password: String, session: HttpSession): ServerResponse[User] = {
        val response = iUserService.login(username, password)

        if (response.isSuccess) {
            val user = response.data

            if (user.role == Const.ROLE_ADMIN) {
                session.setAttribute(Const.CURRENT_USER, user)

                return response
            }

            else return ServerResponse.createByErrorMessage("不是管理员，无法登陆")
        }

        response
    }
}