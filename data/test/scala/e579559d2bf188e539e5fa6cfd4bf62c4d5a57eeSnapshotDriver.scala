package com.jesgoo.tellme.matrix

import java.io.File
import scala.concurrent.Await
import com.jesgoo.tellme.TMain
import akka.actor.Actor
import akka.actor.ActorRef
import akka.pattern.ask
import akka.util.Timeout
import java.io.PrintWriter
import scala.io.Source

case object LOAD_DATA
case object STORE_DATA

class SnapshotDriver(tbl_manager: ActorRef) extends Actor {
  val dump_file_str = TMain.tcontext.DUMP_DB_FILE
  implicit val timeout = Timeout(5000)
  override def receive = {
    case LOAD_DATA =>
      val dump_file = new File(dump_file_str)
      if (dump_file.exists()) {
          val lines = Source.fromFile(dump_file).getLines
          var line = ""
          while(lines.hasNext){
            line = lines.next
            tbl_manager ! ADD_TABLE(line)
          }
      }
      println("LOAD_DATA finish")
    case STORE_DATA =>
      try {
        val dump_tmp_file = new File(dump_file_str + ".tmp")
        if (dump_tmp_file.exists()) {
          dump_tmp_file.delete()
        }
        if (!dump_tmp_file.getParentFile.exists()) {
          dump_tmp_file.getParentFile.mkdirs()
        }
        val future = tbl_manager ? GETALL
        val tables = Await.result(future.mapTo[TABLES_HASHMAP], timeout.duration).t_hm
        val writer = new PrintWriter(dump_tmp_file)
        for (table <- tables.values) {
          val tmps = table.toString()
          if(tmps != null){
            writer.append(tmps+"\n")
          }
        }
        writer.flush()
        writer.close()
        val dump_file = new File(dump_file_str)
        dump_tmp_file.renameTo(dump_file)
      } catch {
        case e: Exception =>
          e.printStackTrace()
      }
  }

}