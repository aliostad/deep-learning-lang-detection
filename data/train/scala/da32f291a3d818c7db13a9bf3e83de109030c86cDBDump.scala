package org.chilternquizleague.web

import org.chilternquizleague.domain._
import java.util.HashMap
import org.chilternquizleague.util.Storage._
import scala.collection.JavaConversions._
import org.chilternquizleague.domain.BaseEntity
import org.chilternquizleague.util.JacksonUtils
import com.fasterxml.jackson.databind.ObjectMapper
import java.util.{ List => JList }
import java.util.{ Map => JMap }
import com.googlecode.objectify.ObjectifyService._
import java.util.ArrayList
import com.googlecode.objectify.VoidWork
import java.util.logging.Logger

object DBDumper {

  val dumpTypes: List[Class[_ <: BaseEntity]] = List(classOf[Venue], classOf[User], classOf[Team], classOf[CommonText], classOf[Fixtures], classOf[Results], classOf[Competition], classOf[Season], classOf[GlobalApplicationData])

  def dump() = new DBDumper().dump

  def load(entities: JMap[String, JList[JMap[String, Any]]]) = new DBDumper().load(entities)

}

private class DBDumper {

  val LOG: Logger = Logger.getLogger(this.getClass.getName)

  def dump() = {

    val dump = new HashMap[String, JList[_]]

    for {
      t <- DBDumper.dumpTypes
    } {
      dump.put(t.getName, entityList(t))
    }

    dump
  }

  def load(entitySet: JMap[String, JList[JMap[String, Any]]]) = {
    val mapper = new ObjectMapper().registerModule(JacksonUtils.unsafeModule)

    val globals = entities[GlobalApplicationData]()

    transaction(() => delete(globals))

    for {
      t <- DBDumper.dumpTypes
      e <- entitySet.get(t.getName())
    } {
      if (String.valueOf(e.get("refClass")).contains("Competition")) {
        e.put("@class", "." + e.get("refClass"))
      }
      val s = mapper.writeValueAsString(e)

      ofy.save().entities(mapper.readValue(s, t));
      LOG.warning(s"Loaded ${t.getName}, id=${e.get("id")}")
    }
    
    for {global <- entities[GlobalApplicationData]()}
    {
      transaction(()=>save(global))
    }    
    Application.init()
  }

}