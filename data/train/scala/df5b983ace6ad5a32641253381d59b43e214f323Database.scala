package model

import org.springframework.boot.autoconfigure.EnableAutoConfiguration
import org.springframework.boot.SpringApplication
import org.springframework.context.annotation.ComponentScan
import scala.collection.JavaConversions._
import scala.beans.BeanProperty
import scala.collection.mutable.Map
import java.text.SimpleDateFormat
import java.util.Date

object Database {
  val users = Map[Int, User]()

  // add the user object to the map
  def addUser(u: User) {
    users(u.getUser_id) = u //add user

  }
  // get the a user from the map
  def getUser(user_id: Int): User = {
    users(user_id) //return the use object
  }

  def updateUser(user_id: Int, u: User): User = {

    var oldUser: User = getUser(user_id)
    // oldUser.setCreated_at(u.getCreated_at)
    if (u.getEmail != null) {
      oldUser.setEmail(u.getEmail)
    }

    if (u.getName != null) {
      oldUser.setName(u.getName)
    }

    if (u.getPassword != null) {
      oldUser.setPassword(u.getPassword)
    }

    return oldUser
  }
  //get a list of users from the map
}
