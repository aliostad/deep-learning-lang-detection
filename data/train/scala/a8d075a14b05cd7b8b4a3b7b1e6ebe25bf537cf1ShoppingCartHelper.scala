package com.k7.shop.core.lib

import com.k7.shop.core.model.{ Product => ProductModel }
import com.k7.shop.core.model.CartEntry
import net.liftweb.http.S
import net.liftweb.common.Full
import net.liftweb.http.SessionVar
import scala.collection.mutable.Map
import net.liftweb.util.ValueCell
import net.liftweb.common.Empty
import net.liftweb.http.js.JsCmds
import net.liftweb.http.RequestVar
import com.k7.shop.core.model.User
import net.liftweb.http.provider.HTTPCookie
import net.liftweb.util.Helpers._
import net.liftweb.mapper.By
import net.liftweb.mapper.DB
import net.liftweb.db.DefaultConnectionIdentifier
import net.liftweb.http.LiftSession
import net.liftweb.http.Req

object cartContents extends SessionVar(ValueCell[List[ShoppingCartItem]](List()))

case object ShoppingCartUpdated

object ShoppingCartHelper {

  def init {
  }

}

trait ShoppingCartHelper {

  def addItemToCart(product: ProductModel) {
    val oldData = cartContents.get.currentValue._1

    oldData.find(e => e.product.id.is == product.id.is) match {
      case Some(item) => {
        val index = oldData.indexOf(item)
        cartContents.get.set(oldData.updated(index, ShoppingCartItem(item.product)))
      }
      case _ => cartContents.get.set(oldData :+ ShoppingCartItem(product))
    }

    notifyActors
  }

  def removeItemFromCart(product: ProductModel) {
    val oldData = cartContents.get.currentValue._1

    oldData.find(e => e.product.id.is == product.id.is) match {
      case Some(item) => {
        removeAllItemsFromCart(product)
      }
      case _ =>
    }

    notifyActors
  }

  def removeAllItemsFromCart(product: ProductModel) {
    val oldData = cartContents.get.currentValue._1

    cartContents.set(oldData filterNot (item => item.product == product))

    notifyActors
  }

  def notifyActors = {
    for {
      session <- S.session ~> "session not found"
    } yield {
      session.sendCometActorMessage("ShoppingCart", Empty, ShoppingCartUpdated)
    }
  }
}