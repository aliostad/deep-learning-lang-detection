package org.plummtw.astgrail.snippet

import _root_.net.liftweb._
import net.liftweb.mapper._
import http._
import SHtml._
import js._
import JsCmds._
import js.jquery._
import JqJsCmds._
import common._
import util._
import Helpers._


import scala.xml.NodeSeq

//import collection.mutable.{LinkedList, HashMap, SynchronizedMap}

import org.plummtw.astgrail.enum._
import org.plummtw.astgrail.model._
import org.plummtw.astgrail.util._
import org.plummtw.astgrail.data._
import org.plummtw.astgrail.actor._
import org.plummtw.astgrail.card._

import org.plummtw.astgrail.heavy.GameProcessor

class AdminSnippet {
  def admin  = {
    val admin_manage       = AdminManage.findAll()

    var admin_ip_list    =  admin_manage.filter(_.param_name.is == "admin_ip")
    var admin_ip         =
      if (admin_ip_list.length != 0)
        admin_ip_list(0).param_value.is
      else
        "127.0.0.1"

    val ip_address = S.request.map{x=>PlummUtil.getIpAddress(x)}.openOr("")
    if (! admin_ip.split(";").contains(ip_address)) {
      S.redirectTo("main.html")
    }

    var room_start         =
      try { admin_manage.filter(_.param_name.is == "room_start")(0).param_value.is }
      catch { case e: Exception => AdminHelper.DEFAULT_ROOM_START.toString}
      
    var room_end           =
      try { admin_manage.filter(_.param_name.is == "room_end")(0).param_value.is }
      catch { case e: Exception => AdminHelper.DEFAULT_ROOM_END.toString}

    var room_count         =
      try { admin_manage.filter(_.param_name.is == "room_count")(0).param_value.is }
      catch { case e: Exception => AdminHelper.DEFAULT_ROOM_COUNT.toString}

    def modify = {
      val admin_manage       = AdminManage.findAll()
      var room_start_list    =  admin_manage.filter(_.param_name.is == "room_start")
      var room_end_list    =  admin_manage.filter(_.param_name.is == "room_end")
      var room_count_list    =  admin_manage.filter(_.param_name.is == "room_count")

      val admin_room_start =
        if (room_start_list.length == 0)
          AdminManage.create.param_name("room_start")
        else
          room_start_list(0)
      admin_room_start.param_value(room_start.toString).save()

      val admin_room_end =
        if (room_end_list.length == 0)
          AdminManage.create.param_name("room_end")
        else
          room_end_list(0)
      admin_room_end.param_value(room_end.toString).save()

      val admin_room_count =
        if (room_count_list.length == 0)
          AdminManage.create.param_name("room_count")
        else
          room_count_list(0)
      admin_room_count.param_value(room_count.toString).save()
      S.redirectTo("manage.html")
    }

    "#room_start"       #> SHtml.text(room_start,  x=>  room_start = x) &
    "#room_end"         #> SHtml.text(room_end,    x=>  room_end   = x) &
    "#room_count"       #> SHtml.text(room_count,  x=>  room_count = x) &
    "#submit"           #> SHtml.submit(" 修  改 ",  () =>modify)
  }

  def room_admin  = {
    val admin_manage       = AdminManage.findAll()

    var admin_ip_list    =  admin_manage.filter(_.param_name.is == "admin_ip")
    var admin_ip         =
      if (admin_ip_list.length != 0)
        admin_ip_list(0).param_value.is
      else
        "127.0.0.1"

    val ip_address = S.request.map{x=>PlummUtil.getIpAddress(x)}.openOr("")
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
    var font_type   = "normal"

    var user_table  : NodeSeq = NodeSeq.Empty
    if (room != null) {
       val user_entrys = UserEntry.findAllByRoom(room) // UserEntry.findAll(By(UserEntry.room_id, room_id))
       val roomround  = RoomRound.find(By(RoomRound.room_id, room_id), OrderBy(RoomRound.round_no, Descending)).get 
       val roomphase  = RoomPhase.find(By(RoomPhase.roomround_id, roomround.id.is), OrderBy(RoomPhase.phase_no, Descending)).get
      
       user_table = UserEntryHelper.user_admin_table(room, roomphase, user_entrys.filter(!_.revoked.is))
    }

    def view = {
      S.redirectTo("manage.html?room_no=" + room_no)
    }

    def send_message = {
      val room_id : Long =
        try { room_no.toLong }
        catch { case e: Exception => 0 }    //val room        = Room.get(room_id)
      val room_list   = Room.findAll(By(Room.id, room_id))
      val room        = if (room_list.length == 0) null else room_list(0)

      if (room == null) {
        S.redirectTo("manage.html?room_no=" + room_no)
      }

      val userentrys = UserEntry.findAll(By(UserEntry.room_id, room_id))
      val roomround  = RoomRound.find(By(RoomRound.room_id, room_id), OrderBy(RoomRound.round_no, Descending)).get
      // 去掉 actioner_id actioner_id(user_entrys(0).id.is)
      val talk = Talk.create.roomround_id(roomround.id.is)
                            .cssclass(font_type).message(message).mtype(MTypeEnum.TALK_ADMIN.toString)
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

      val userentrys = UserEntry.findAll(By(UserEntry.room_id, room_id))
      val roomround  = RoomRound.find(By(RoomRound.room_id, room_id), OrderBy(RoomRound.round_no, Descending)).get

      (1 to 25).foreach { index =>
        if (S.param("id" + index.toString).getOrElse("") != "") {
          val actionee = userentrys.filter(_.user_no.is == index)(0)
          // 去掉 actioner_id actioner_id(user_entrys(0).id.is)
          val talk = Talk.create.roomround_id(roomround.id.is).actionee_id(actionee.id.is)
                                .cssclass(font_type).message(message).mtype(MTypeEnum.TALK_ADMIN_PRIVATE.toString)
          talk.save
        }
      }

      S.redirectTo("manage.html?room_no=" + room_no)
    }

    def abandon = {
      val room_id : Long =
      try { room_no.toLong }
      catch { case e: Exception => 0 }    //val room        = Room.get(room_id)
      val room_list   = Room.findAll(By(Room.id, room_id))
      val room        = if (room_list.length == 0) null else room_list(0)

      if (room != null) {
        //room.status(RoomStatusEnum.ENDED.toString).victory(RoomVictoryEnum.ABANDONED.toString).save()
        GameProcessor.abandon(room)
        S.redirectTo("manage.html?room_no=" + room_no)
      }
    }

    def send_private_message_tag = if ((room != null) && (room.status.is != RoomStatusEnum.WAITING.toString))
                                  SHtml.submit("私人訊息",  send_private_message)
                                else
                                  <span></span>

    "#room_no"             #> SHtml.text(room_no, x => room_no = x)&
    "#user_table *"        #> user_table &
    "#view"                #> SHtml.submit(" 檢  視 ",  () => view) &
    "#message"             #> SHtml.text(message, x =>  message = x) &
    "#font_type"           #> SHtml.select(Seq(("large","強力發言"),("slightlarge","稍強發言"),("normal","普通發言"),("small","小聲發言")),
                              Full(font_type),  x => font_type = x) &
    "#send_message"        #> SHtml.submit("全體訊息",  () =>send_message) &
    "#send_private_message" #> send_private_message_tag &
    "#abandon"             #> SHtml.submit(" 廢  村 ",  () =>abandon, "id" -> "abandon")
  }
}