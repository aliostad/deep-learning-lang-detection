package main

import scala.xml._
import scala.io.Source._
import java.io.File

class Importer(path: String) {
  
  def isOk(): Boolean = {
    val file = new File(path)
    file.exists()
  }
  
  def run() = {
    val xml = XML.loadFile(path)
    val contacts = (for(
      node <- (xml \ "contact") 
    ) yield Contact.build((node \ "name").text, (node \ "lastName").text, (node \ "phone").map(phone => phone.text).toList))
    Contact.createAll(merge(contacts))
  }
  
  def merge(list: Seq[Contact]) = {
    var contacts: Array[Contact] = Array.fill(list.length)(null)
    val existingContacts = Contact.all()
    var contact: Contact = null
    var i = 0
    list.foreach{c =>
      var index = contacts.indexWhere(p => c.equals(p))
      var oldIndex = existingContacts.indexWhere(p => c.equals(p))
      var existingPhones: List[String] = Nil
      if(oldIndex >= 0){
        existingPhones = existingContacts(oldIndex).phones
        existingContacts(oldIndex).destroy()
      }
      if(index >= 0){
    	contact = Contact(c.name, c.lastName, (c.phones ::: contacts(index).phones ::: existingPhones).distinct)
    	contacts(index) = contact
      }
      else{
        contacts(i) = Contact.build(c.name, c.lastName, (c.phones ::: existingPhones).distinct)
        i += 1
      }
    }
    contacts.filter{c => c != null}
  }

}