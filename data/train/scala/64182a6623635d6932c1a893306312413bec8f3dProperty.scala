package org.idio.wikidata.dump.element

import scala.util.{Success, Try}

import org.json4s._
import org.json4s.jackson.JsonMethods._
/**
 * Represents a Relationship Type in Wikidata
 */

class Property(parsedJson: JValue) extends DumpElement {

  def getId():Option[String]={
    Try((parsedJson \ "id").asInstanceOf[JString].s) match{
      case Success(s) => Some(s)
      case _ => None
    }
  }

  def getLabel(language:String):Option[String]={
    try{
      val languageAliases = (parsedJson \ "aliases" \ language).asInstanceOf[JArray].arr
      Some((languageAliases(0) \ "value").asInstanceOf[JString].s)
    }catch{
      case _=> None
    }
  }


}
