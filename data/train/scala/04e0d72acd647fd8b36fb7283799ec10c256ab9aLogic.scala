package logic

import database.UserDatabase

class Logic {

  //  def truncateData(): List[(Int,String,Int)] =
  //  {
  //    val new_tags : List[(Int, String, Int)]
  //    return new_tags
  //  }

  def manageData(user_tag : Map[String,Int], user : String) : Map[String,Int] = {
    UserDatabase.create_table()

    if (!UserDatabase.user_exist(user))
      UserDatabase.add_user(user)

    val history_tags: Map[String,Int] = UserDatabase.get_tags(user)

    UserDatabase.update_tags(user_tag,user)

    history_tags
  }
}
