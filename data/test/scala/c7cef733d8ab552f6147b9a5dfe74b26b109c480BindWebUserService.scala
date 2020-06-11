/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package wangzx.member.service

import wangzx.jdbc.RichSQL2._
import wangzx.jdbc.RichString2._

class BindWebUserService {

  class Request {
    var MbUserId: Int = _     // 会员Id
    var WbUserName: String = _ // 绑定的原有用户名
    var WbPassword: String = _  // 绑定的原有用户密码
  }

  var dataSource: javax.sql.DataSource = _

  def service(request: Request) {

    implicit var conn = dataSource.getConnection


    val oldUser = query0_1("select * from user where username = ?", request.WbUserName)
    assert(oldUser != null, "用户名不存在")

    // !=? ==? 对字符串进行特殊处理 "" ==? null
    assert(request.WbPassword !=? "", "用户密码必须")
    assert( oldUser("password").asInstanceOf[String] ==? md5hex(request.WbPassword), "用户密码不符" )

    val cnt = queryInt("select count(*) from UserBandCard where userid = ?", oldUser("userid"))
    assert( cnt == 0, "该用户已绑定到银行卡" )

    val member = query0_1("select * from user where userid = ?", request.MbUserId)
    assert(member != null, "会员不存在")
    assert(member("username").asInstanceOf[String] !=? "", "当前会员已成功绑定用户名")

    transaction {
      //update("""update user set username = :username and nickname""")

      def f(fields: String*): Map[String,Any] = {
          var map: Map[String, Any] = Map();
          for(field <- fields) {
            map = map + (field -> oldUser(field))
          }
          map
      }

      val modified = f("username", "nickname", "password", "email",
                        "emailverified", "realname", "certtype", "certno",
                        "regfrom", "regtime", "LastLogonTime", "Status",
                        "Recommender", "qq", "msn")

      // 更新当前会员的信息，从原有用户复制上述字段
      update("update user set " + updateSql(modified) + "where userid = :userId",
            modified + ("userid" -> member("userid")))
     // 更新原有用户为不激活状态
      update("update user set status = 2 and username = null where userid = ?",
             oldUser("userid"))

      // 迁移原有用户的电子钱包
      val old_new_map = Map("new"->member("userid"), "old" -> oldUser("userid"))
      update("update EW_Account set acct_no = :new where acct_no = :old",   old_new_map)
      update("update ew_sub_account set acct_no = :new where acct_no = :old",old_new_map)
      update("update ew_journal set acct_no = :new where acct_no = :old",    old_new_map)

      // 迁移原有的用户积分
      update("update user_point set userid = :new where userid = :old",      old_new_map)
    }

  }

  private def md5hex(str: String): String = {
    assert(false, "Not Implemented")
    null
  }


  
}
