package bmlogic.userManage


import java.text.SimpleDateFormat
import java.util.Date

import bmutil.errorcode.ErrorCode
import bminjection.db.DBTrait
import bmlogic.auth.AuthData.AuthData
import bmlogic.userManage.UserManageMessage._
import bmmessages.{CommonModules, MessageDefines}
import bmpattern.ModuleTrait
import com.mongodb.casbah.Imports._
import play.api.libs.json.JsValue
import play.api.libs.json.Json.toJson
import bmlogic.auth.AuthModule.queryUserById

import scala.collection.immutable.Map
import scala.util.parsing.json.JSONObject

/**
  * Created by jeorch on 17-6-27.
  */
object UserManageModule extends ModuleTrait with AuthData {



    def dispatchMsg(msg: MessageDefines)(pr: Option[Map[String, JsValue]])(implicit cm : CommonModules): (Option[Map[String, JsValue]], Option[JsValue]) = msg match {
        case msg_deleteUserManage(data) => delete_user_func(data)
        case msg_saveUserManage(data) => save_user_func(data)
        case msg_saveUserAuth(data) => save_user_auth_func(data)

        case _ => ???
    }

    def delete_user_func(data: JsValue)(implicit cm : CommonModules): (Option[Map[String, JsValue]], Option[JsValue]) = {
        try {
            val db = cm.modules.get.get("db").map (x => x.asInstanceOf[DBTrait]).getOrElse(throw new Exception("no db connection"))
            val user = queryUserById(data)._1.get
            val o = m2d(toJson(user))
            db.deleteObject(o,"users","user_id")

            (Some(Map(
                "delete_result" -> toJson("ok")
            )), None)

        } catch {
            case ex: Exception => (None, Some(ErrorCode.errorToJson(ex.getMessage)))
        }

    }
    def save_user_func(data : JsValue)(implicit cm : CommonModules) : (Option[Map[String, JsValue]], Option[JsValue]) = {
        try {
            val sdf = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss")
            val db = cm.modules.get.get("db").map (x => x.asInstanceOf[DBTrait]).getOrElse(throw new Exception("no db connection"))
            val o : DBObject = data
            val date = (data \ "date").get.asOpt[String].get

            o += "date" -> sdf.parse(date).getTime.asInstanceOf[Number]
            o += "updateDate" -> new Date().getTime.asInstanceOf[Number]

            db.updateObject(o,"users","user_id")

            (Some(Map(
                "update_result" -> toJson("ok")
            )), None)

        } catch {
            case ex : Exception => (None, Some(ErrorCode.errorToJson(ex.getMessage)))
        }
    }

    def save_user_auth_func(data : JsValue)(implicit cm : CommonModules) : (Option[Map[String, JsValue]], Option[JsValue]) = {
        try {
            val db = cm.modules.get.get("db").map (x => x.asInstanceOf[DBTrait]).getOrElse(throw new Exception("no db connection"))
            val scope = (data \ "scope").get.asOpt[List[String]].getOrElse(throw new Exception("read scope error"))
            val user = queryUserById(data)._1.get
            val o = m2d(toJson(user))

            o += "date" ->  user.get("date").get.asOpt[Long].get.asInstanceOf[Number]
            o += "updateDate" -> new Date().getTime.asInstanceOf[Number]

            val category_list = scope.groupBy(x => x.charAt(0)).getOrElse('c',new MongoDBList)
            val edge_list = scope.groupBy(x => x.charAt(0)).getOrElse('e',new MongoDBList)
            val sampleVal= scope.filter(x => x.charAt(0) == 's').head.split("-")(1).toInt
            val scope_builder = MongoDBObject.newBuilder
            if (category_list.length==0){
                scope_builder += "category" -> new MongoDBList
            }else{
                scope_builder += "category" -> scope.groupBy(x => x.charAt(0)).get('c').get.map(x => x.substring(2,x.length))
            }
            if (edge_list.length==0){
                scope_builder += "edge" -> new MongoDBList
            }else{
                scope_builder += "edge" -> scope.groupBy(x => x.charAt(0)).get('e').get.map(x => x.substring(2,x.length))
            }
            scope_builder += "manufacture_name" -> pushManufactureNameScope(toJson(user))
            scope_builder += "is_admin" -> (toJson(user) \ "scope" \ "is_admin").asOpt[Int].map (x => x).getOrElse(0)
            scope_builder += "sample" -> sampleVal

            o += "scope" -> scope_builder.result

            db.updateObject(o,"users","user_id")

            (Some(Map(
                "result" -> toJson(o.toString)
            )), None)

        } catch {
            case ex : Exception => (None, Some(ErrorCode.errorToJson(ex.getMessage)))
        }
    }

}
