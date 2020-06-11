package controllers

import javax.inject.Inject

import akka.actor.ActorSystem
import bminjection.db.DBTrait
import bminjection.token.AuthTokenTrait
import bmlogic.userManage.UserManageMessage._
import bmlogic.common.requestArgsQuery
import bmlogic.config.ConfigMessage.msg_queryAuthTree
import bmmessages.{CommonModules, MessageRoutes}
import bmpattern.LogMessage.msg_log
import play.api.libs.json.Json.toJson
import play.api.mvc.{Action, Controller}

class UserManageController@Inject()(as_inject : ActorSystem, dbt : DBTrait, att : AuthTokenTrait) extends Controller {
    implicit val as = as_inject
    def queryUsers = Action(request => requestArgsQuery().requestArgsV2(request) { jv =>
        import bmpattern.LogMessage.common_log
        MessageRoutes(msg_log(toJson(Map("method" -> toJson("queryUsers"))), jv)
            :: msg_userManage_query(jv) :: Nil, None)(CommonModules(Some(Map("db" -> dbt, "att" -> att))))
    })

    def deleteUser = Action(request => requestArgsQuery().requestArgsV2(request) { jv =>
        import bmpattern.LogMessage.common_log
        MessageRoutes(msg_log(toJson(Map("method" -> toJson("deleteUser"))), jv)
            :: msg_deleteUserManage(jv) :: Nil, None)(CommonModules(Some(Map("db" -> dbt, "att" -> att))))
    })

    def saveUser = Action(request => requestArgsQuery().requestArgsV2(request) { jv =>
        import bmpattern.LogMessage.common_log
        MessageRoutes(msg_log(toJson(Map("method" -> toJson("saveUsers"))), jv)
            :: msg_saveUserManage(jv) :: Nil, None)(CommonModules(Some(Map("db" -> dbt, "att" -> att))))
    })

    def queryAuthTree = Action(request => requestArgsQuery().requestArgsV2(request) { jv =>
        import bmpattern.LogMessage.common_log
        MessageRoutes(msg_log(toJson(Map("method" -> toJson("queryUsers"))), jv)
            :: msg_queryAuthTree(jv) :: Nil, None)(CommonModules(Some(Map("db" -> dbt, "att" -> att))))
    })

    def saveUserAuth = Action(request => requestArgsQuery().requestArgsV2(request) { jv =>
        import bmpattern.LogMessage.common_log
        MessageRoutes(msg_log(toJson(Map("method" -> toJson("queryUsers"))), jv)
            :: msg_saveUserAuth(jv) :: Nil, None)(CommonModules(Some(Map("db" -> dbt, "att" -> att))))
    })
}