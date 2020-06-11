package model

import java.util.{UUID, Date, GregorianCalendar, Calendar}

import com.tinkerpop.blueprints.Vertex
import com.tinkerpop.gremlin.java.GremlinPipeline
import datasource.ManageDataSource
import datasource.ManageDataSource._
import datasource.GraphSyntaticSugar._
import play.api.Logger
import play.api.mvc.Headers
import synaticsugar.Sugars._

/**
 * Created by kanhasatya on 9/9/14.
 */
class AuthenticationModule(userName:String, password:String) {

  def authenticate: Option[String] =
    if (!password.equalsIgnoreCase("") and User(userName,password).getPassword.equalsIgnoreCase(password)) {
      val session = UserSession(userName,UserSession.getUUID)
      if(session.save)
        Some(session.getId)
      else None
    }

    else None
}

  case class UserSession(userName:String , id:String, sessionCreated:Date,createdFrom:String) {

    def getUser(id:String):Option[String] = ManageDataSource.getNonTransactionalInstance match{

      case Some(graph) => {
        val userList =  new GremlinPipeline(graph.getVertices("type","Session")).has("userSessionId",id).property("user").toList.asInstanceOf[java.util.ArrayList[String]]

        if(userList.size() >= 1){Logger.info("got the user name") ; Some(userList.get(0))}  else None

      }

      case None => None
    }


    def save:Boolean = ManageDataSource.getInstance match{

      case Some(graphInstance) => {

        def getProperties : Map[String,Any] = Map("type" -> "Session", "user" -> userName,"userSessionId" -> getId , "sessionCreated" -> new GregorianCalendar().getTime ,"createdFrom" -> "doesn't mater for timebeing")
        implicit val graph = graphInstance

        tx{

          graph.addCleanVertexWithProperties(getProperties)
        }

      }

      case None => false

    }

    def destroy : Boolean = ManageDataSource.getInstance match{

      case Some(graphInstance) => {


        implicit val graph = graphInstance

        tx{

             val vertexList =  new GremlinPipeline(graph.getVertices("type","Session")).has("userSessionId",id).toList.asInstanceOf[java.util.ArrayList[Vertex]]

             if(vertexList.size()>= 1){

               graph.removeVertex(vertexList.get(0))

             }

             else{
               throw new Exception("Did not get the session to delete")
             }
        }

      }

      case None => false

    }



    def getId = id

  }

  object UserSession{

    def apply(userName:String,session:String) = new UserSession(userName,session,null,"")
    def getUUID = UUID.randomUUID().toString
  }


case class User(name:String,password:String){

  def getPassword :String = ManageDataSource.getNonTransactionalInstance match {
    case Some(graph) => {
         val passList = new GremlinPipeline(graph.getVertices("type","User")).has("user",name).property("password").toList.asInstanceOf[java.util.ArrayList[String]]

        if(passList.size() >= 1) passList.get(0) else ""
    }

    case None =>  ""

  }

  def getProperties:Map[String,Any] = Map("type" -> "User", "user" -> name , "password" -> password)

  def save:Boolean = ManageDataSource.getInstance match{
    case Some(graphInstance) => {
      implicit val graph = graphInstance
      tx{
        graph.addCleanVertexWithProperties(getProperties)

      }

    }

    case None => false

  }

  def getUserNode : Option[Vertex] = ManageDataSource.getNonTransactionalInstance match {

    case Some(graph) => {

       Logger.info("Trying to find the user node for the user name:"+name)

       val userList = new GremlinPipeline(graph.getVertices("type","User")).has("user",name).toList.asInstanceOf[java.util.ArrayList[Vertex]]

       if(userList.size() >= 1){Logger.info("Got the user node"); Some(userList.get(0))}  else None
    }

    case None => None
      
  }
}

object User{
  def apply(name:String) = new User(name,"")

  def getUserNode(implicit headers:Headers) :Option[Vertex] = for{
    sessionId  <- headers.get("userSessionId")
    userName   <-  UserSession("",sessionId).getUser(sessionId)
    userNode   <-  User(userName).getUserNode

  }yield userNode
}


