package bmlogic.userManage

/**
  * Created by jeorch on 17-6-12.
  */
import play.api.libs.json.JsValue
import bmmessages.CommonMessage

abstract class msg_UserManageCommand extends CommonMessage
abstract class msg_QueryUserCommand extends CommonMessage

object UserManageMessage {
    case class msg_userManage_query(data : JsValue) extends msg_QueryUserCommand // 用户管理
    case class msg_deleteUserManage(data : JsValue) extends msg_UserManageCommand // 删除用户
    case class msg_saveUserManage(data : JsValue) extends msg_UserManageCommand   // 更新用户
    case class msg_saveUserAuth(data : JsValue) extends msg_UserManageCommand   // 更新用户
}