package controllers.v2

import play.api._
import play.api.mvc._
import play.api.libs.json._
import play.api.libs.json.Json._
import controllers._
import models.{Node, Order}

object Orders extends Controller with Secured {

  def prepare(no: Long) = Signed("manage_order") { implicit request => implicit user =>
    Node.findOneByNo(no) match {
      case Some(node) => 
        val o = Order(node.toTypedJson)
        if(o.prepare(user)){
          Accepted
        }else{
          o.cancel
          Ok
        }
      case None =>
        NotFound
    }
  }

  def cancel(no: Long) = Signed("manage_order") { implicit request => implicit user =>
    Node.findOneByNo(no) match {
      case Some(node) => 
        if(Order(node.toTypedJson).cancel){
          Accepted
        }else{
          Ok
        }
      case None =>
        NotFound
    }
  }

}