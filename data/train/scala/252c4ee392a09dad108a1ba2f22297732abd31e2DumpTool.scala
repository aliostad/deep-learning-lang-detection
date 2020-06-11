package utils

import scala.collection.mutable.Map
import java.io.FileOutputStream
import model.PersonCard.Person
import scala.collection.JavaConversions.{asJavaCollection=>_,_}

object DumpTool {
  def dumpDataBlockToDisk(map: Map[String, String], os: FileOutputStream) = {
    //create a block of date
    val personList = for ((key, value) <- map) yield {
      val personBuilder = Person.newBuilder()
      personBuilder.setName(key)
      personBuilder.setPhone(value)
      val person = personBuilder.build()
      person
    }

    val storage = model.PersonCard.Storage.newBuilder()
    val dataBlock = storage.addAllPerson(personList).build()

    //dump it
    dataBlock.writeTo(os)
  }
}
