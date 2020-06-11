package controllers

import play.api._
import play.api.mvc._
import play.api.libs.iteratee.Enumerator
import play.api.mvc.Codec
import play.api.data._
import play.api.data.Forms._
import play.api.mvc._

import com.mongodb.casbah.Imports._
import java.util.Calendar
import java.text._

object UserManager extends Controller {

 implicit val myCustomCharset = Codec.javaSupported("utf-8")
 
  def edit_user_act(user_id: String) = Action { request => 
    val post_map = request.body.asFormUrlEncoded.get // Map[String, List]
    val query = MongoDBObject("_id" -> user_id)
    
	var update = MongoDBObject("is_super"->"false")    
    
	for((k,v)<-post_map){
        if(k == "permissions" || k == "categories"){
            update = update ++ (k->v)
        }else{
            update = update ++ (k->v(0))         
        }
	}
    
    DB.colls("User").update(query, update)
    
    Redirect("/user_manage.html")
  }
  
   def edit_user(user_id: String) = Action {request=>
    val query = MongoDBObject("_id" -> user_id)
	val user = DB.colls("User").findOne(query).get
	Ok(views.html.edit_user(Permissions.actions, Permissions.categories, user))
  }  
 
  def del_user_act(user_id: String) = Action{ implicit request =>
	  val query = MongoDBObject("_id" -> user_id)
	  val result = DB.colls("User").remove(query)
	  
	  Ok("""{"status":200, "msg":"success"}""")
  }
    
 
  def add_user_act = Action { implicit request =>
    val post_map = request.body.asFormUrlEncoded.get // Map[String, List]
    
    var user:Map[String, Any] = Map(
        "_id"->(new (java.util.Date).getTime+""),
        "is_super"->"false",
        "permissions" -> List(),
        "categories" -> List()
        )
    
	for((k,v)<-post_map){
        if(k == "permissions" || k == "categories"){
            user += (k->v);
        }else{
            user += (k->v(0));            
        }
	}
	DB.colls("User").insert(user)
    
    Redirect("/user_manage.html")
  } 
  
  def add_user = Action {request=>
  
    val user_id = request.session.get("user_id").get
    val query_user = MongoDBObject("_id" -> user_id)
    val user  = DB.colls("User").findOne(query_user).get
        
	Ok(views.html.add_user(Permissions.actions, Permissions.categories, user))
  }
  
  def user_manage = Action {request=>
    val user_list  = DB.colls("User").find().toList
  
    val user_id = request.session.get("user_id").get
    val query_user = MongoDBObject("_id" -> user_id)
    val user  = DB.colls("User").findOne(query_user).get
    
	Ok(views.html.user_manage(user_list, user))
  }  
  

}