// $Id$
package net.kazmuzik.scala.dev.twitter.mongodb.tool

import net.kazmuzik.scala.dev.twitter.mongodb.TwitterMongoStatusCollection
import com.mongodb._
import java.io._

class StatusDumper(coll:TwitterMongoStatusCollection, out:PrintWriter) {
  def dump(status:DBObject):Unit = {
    status.removeField("_id")
    out.print(status.toString())
  }
  def dumpAll():Unit = {
    val cursor = coll.find()
    var first = true
    while (cursor.hasNext()) {
      if (first) {
        out.println("[")
        first = false
      }
      else {
        out.println(" ,")
      }
      dump(cursor.next())
    }
    out.println()
    out.println("]")
    out.flush()
  }
}

object StatusDumper {
  def apply():StatusDumper = new StatusDumper(TwitterMongoStatusCollection(), new PrintWriter(new OutputStreamWriter(System.out, "UTF-8")))

  def main(args:Array[String]):Unit = {
    StatusDumper().dumpAll()
  }
}
