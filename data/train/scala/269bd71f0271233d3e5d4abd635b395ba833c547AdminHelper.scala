package org.plummtw.astgrail.util

import scala.xml._
import net.liftweb._
import net.liftweb.mapper._
import http._
import js._
import util._
import S._
import SHtml._
import Helpers._


import org.plummtw.astgrail.model._
import org.plummtw.astgrail.enum._

object AdminHelper {
  val DEFAULT_ROOM_START   = 7
  val DEFAULT_ROOM_END    = 22
  val DEFAULT_ROOM_COUNT = 3
  
  lazy val identicon_link = {
    val identicon_list = AdminManage.findAll(By(AdminManage.param_name, "identicon_server"))
    if (identicon_list.length == 0)
      "http://identicon.relucks.org/"
    else
      identicon_list(0).param_value.is
  }

  lazy val trip_link = {
    val trip_list = AdminManage.findAll(By(AdminManage.param_name, "trip_server"))
    if (trip_list.length == 0)
      "http://diam.ngct.net/trip.php?go=trip&id="
    else
      trip_list(0).param_value.is
  }
}