package org.plummtw.jinrou.snippet

import scala.xml._
import net.liftweb._
import net.liftweb.mapper._
import http._
import js._
import util._
import S._
import SHtml._
import Helpers._

import org.plummtw.jinrou.model._
import org.plummtw.jinrou.enum._
import org.plummtw.jinrou.util._
import org.plummtw.jinrou.data._

class AdminController {
  def admin (xhtml : Group) : NodeSeq = {

    val admin_manage       = AdminManage.findAll()

    var admin_ip_list    =  admin_manage.filter(_.param_name.is == "admin_ip")
    var admin_ip         =
      if (admin_ip_list.length != 0)
        admin_ip_list(0).param_value.is
      else
        "127.0.0.1"

    val ip_address = S.request.map{x=>JinrouUtil.getIpAddress(x)}.openOr("")
    if (! admin_ip.split(";").contains(ip_address)) {
      S.redirectTo("main.html")
    }

    var room_start_list    =  admin_manage.filter(_.param_name.is == "room_start")
    var room_start         =
      if (room_start_list.length != 0)
        room_start_list(0).param_value.is
      else
        "7"
    var room_end_list    =  admin_manage.filter(_.param_name.is == "room_end")
    var room_end         =
      if (room_end_list.length != 0)
        room_end_list(0).param_value.is
      else
        "22"

    var room_count_list    =  admin_manage.filter(_.param_name.is == "room_count")
    var room_count         =
      if (room_count_list.length != 0)
        room_count_list(0).param_value.is
      else
        "3"

    def modify () {
      val admin_manage       = AdminManage.findAll()
      var room_start_list    =  admin_manage.filter(_.param_name.is == "room_start")
      var room_end_list    =  admin_manage.filter(_.param_name.is == "room_end")
      var room_count_list    =  admin_manage.filter(_.param_name.is == "room_count")

      val admin_room_start =
        if (room_start_list.length == 0)
          AdminManage.create.param_name("room_start")
        else
          room_start_list(0)
      admin_room_start.param_value(room_start).save()

      val admin_room_end =
        if (room_end_list.length == 0)
          AdminManage.create.param_name("room_end")
        else
          room_end_list(0)
      admin_room_end.param_value(room_end).save()

      val admin_room_count =
        if (room_count_list.length == 0)
          AdminManage.create.param_name("room_count")
        else
          room_count_list(0)
      admin_room_count.param_value(room_count).save()
      S.redirectTo("manage.html")
    }

    bind("entry", xhtml,
      "room_start"         -> SHtml.text(room_start,    room_start = _, "size"->"45"),
      "room_end"           -> SHtml.text(room_end,        room_end = _, "size"->"50"),
      "room_count"         -> SHtml.text(room_count,    room_count = _, "size"->"50"),
      "submit"             -> SHtml.submit(" 修  改 ",  modify)
    )
  }

  def room_admin (xhtml : Group) : NodeSeq = {

    val admin_manage       = AdminManage.findAll()

    var admin_ip_list    =  admin_manage.filter(_.param_name.is == "admin_ip")
    var admin_ip         =
      if (admin_ip_list.length != 0)
        admin_ip_list(0).param_value.is
      else
        "127.0.0.1"

    val ip_address = S.request.map{x=>JinrouUtil.getIpAddress(x)}.openOr("")
    if (! admin_ip.split(";").contains(ip_address)) {
      S.redirectTo("main.html")
    }

    var room_no = S.param("room_no").getOrElse("0")
    val room_id : Long =
      try { room_no.toLong }
      catch { case e: Exception => 0 }    //val room        = Room.get(room_id)
    val room_list   = Room.findAll(By(Room.id, room_id))
    val room        = if (room_list.length == 0) null else room_list(0)

    var message     = ""
    var font_type   = ""

    var user_table  : NodeSeq = NodeSeq.Empty
    if (room != null) {
       val user_entrys = UserEntry.findAll(By(UserEntry.room_id, room_id))
       user_table = UserEntryHelper.user_admin_table(room, user_entrys)
    }

    def view () {
      S.redirectTo("manage.html?room_no=" + room_no)
    }

    def send_message () {
      val room_id : Long =
        try { room_no.toLong }
        catch { case e: Exception => 0 }    //val room        = Room.get(room_id)
      val room_list   = Room.findAll(By(Room.id, room_id))
      val room        = if (room_list.length == 0) null else room_list(0)

      if (room == null) {
        S.redirectTo("manage.html?room_no=" + room_no)
      }

      val user_entrys = UserEntry.findAll(By(UserEntry.room_id, room_id))
      val room_day_list   = RoomDay.findAll(By(RoomDay.room_id, room_id), OrderBy(RoomDay.day_no, Descending))
      val room_day        = if (room_day_list.length == 0) null else room_day_list(0)

      // 去掉 actioner_id actioner_id(user_entrys(0).id.is)
      val talk = Talk.create.roomday_id(room_day.id.is)
                            .font_type(font_type).message(message).mtype(MTypeEnum.TALK_ADMIN.toString)
      talk.save

      S.redirectTo("manage.html?room_no=" + room_no)
    }

    def send_private_message () {
      val room_id : Long =
        try { room_no.toLong }
        catch { case e: Exception => 0 }    //val room        = Room.get(room_id)
      val room_list   = Room.findAll(By(Room.id, room_id))
      val room        = if (room_list.length == 0) null else room_list(0)

      if (room == null) {
        S.redirectTo("manage.html?room_no=" + room_no)
      }

      val user_entrys = UserEntry.findAll(By(UserEntry.room_id, room_id))
      val room_day_list   = RoomDay.findAll(By(RoomDay.room_id, room_id), OrderBy(RoomDay.day_no, Descending))
      val room_day        = if (room_day_list.length == 0) null else room_day_list(0)

      (1 to 25).foreach { index =>
        if (S.param("id" + index.toString).getOrElse("") != "") {
          val actionee = user_entrys.filter(_.user_no.is == index)(0)
          // 去掉 actioner_id actioner_id(user_entrys(0).id.is)
          val talk = Talk.create.roomday_id(room_day.id.is).actionee_id(actionee.id.is)
                                .font_type(font_type).message(message).mtype(MTypeEnum.TALK_ADMIN_PRIVATE.toString)
          talk.save
        }
      }

      S.redirectTo("manage.html?room_no=" + room_no)
    }

    def abandon () {
      val room_id : Long =
      try { room_no.toLong }
      catch { case e: Exception => 0 }    //val room        = Room.get(room_id)
      val room_list   = Room.findAll(By(Room.id, room_id))
      val room        = if (room_list.length == 0) null else room_list(0)

      if (room != null) {
        room.status(RoomStatusEnum.ENDED.toString).victory(RoomVictoryEnum.ABANDONED.toString).save()
        S.redirectTo("manage.html?room_no=" + room_no)
      }
    }

    def send_private_message_tag = if ((room != null) && (room.status.is != RoomStatusEnum.WAITING.toString))
                                  SHtml.submit("私人訊息",  send_private_message)
                                else
                                  <span></span>

    bind("entry", xhtml,
      "room_no"             -> SHtml.text(room_no,    room_no = _, "size"->"45"),
      "user_table"          -> user_table,
      "view"                -> SHtml.submit(" 檢  視 ",      view),
      "message"             -> SHtml.text(message,    message = _, "size"->"45"),
      "font_type"           -> SHtml.select(Seq(("8","8"),("12","12"),("16","16"),("20","20")),
                               Full("12"), font_type = _),
      "send_message"        -> SHtml.submit("全體訊息",  send_message),
      "send_private_message" -> send_private_message_tag,
      "abandon"             -> SHtml.submit(" 廢  村 ",  abandon, "id" -> "abandon")
    )
  }
}