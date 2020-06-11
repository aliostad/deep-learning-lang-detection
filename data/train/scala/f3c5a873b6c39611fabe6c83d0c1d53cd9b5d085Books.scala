package org.packtpublishing.model

import org.joda.time.LocalDate

object Permissions extends Enumeration {
  type Permission = Value
  
  val MANAGE_PUBLISHERS = Value("MANAGE_PUBLISHERS")
  val MANAGE_BOOKS = Value("MANAGE_BOOKS") 
}

case class User(username: String, password: Array[Byte], salt: Array[Byte], permissions: Seq[Permissions.Permission] = Seq()) {
  def this(username: String, saltedPassword: (Array[Byte], Array[Byte])) = 
    this(username, saltedPassword._1, saltedPassword._2)
}

case class Permission(username: String, permission: Permissions.Permission)

case class Book(isbn: String, title: String, author: String, 
  publishingDate: LocalDate, publisherId: Long)
    
case class Publisher(id: Option[Long], name: String)

