package org.idio.wikidata.dump.element

import org.json4s._
import org.json4s.jackson.JsonMethods._

object DumpElement{

  /*
  * Parses  a line from the Wikidata Dump
  * */
   def parseElement(jsonString: String): Option[DumpElement] ={
     try{
          val parsedElement = parse(jsonString)
          val JString(elementId) = (parsedElement \ "id")
          elementId match {
            case s:String if s.startsWith("Q") => Some(new Item(parsedElement))
            case s:String if s.startsWith("P") => Some(new Property(parsedElement))
          }
     }catch{

       case _=> {
          println("WARNING - Error Parsing json..")
          None
       }
     }
   }


}

trait DumpElement{
  def getId():Option[String]
}