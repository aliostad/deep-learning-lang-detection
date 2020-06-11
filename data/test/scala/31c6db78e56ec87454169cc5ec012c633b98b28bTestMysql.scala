package sql

import java.sql.{Connection, DriverManager, PreparedStatement}

import untils.ConfigUtils

/**
 * Created by wangdabin1216 on 15/11/3.
 */
object TestMysql {


  def main (args:Array[String]){

  val configs = ConfigUtils.getConfig("/config/db.properties")
  val url = configs.get("MYSQL_DB_URL").get
  val username = configs.get("MYSQL_DB_USERNAME").get
  val password = configs.get("MYSQL_DB_PASSWORD").get
  var conn: Connection = null
  var ps: PreparedStatement = null
  val insert_sql = "insert into statistical(goodid,ptid,ywbm,ctype,click_sum,buy_sum) values (?,?,?,?,?,?)"
  val delete_sql = "delete from statistical where goodid = ?"
  val update_sql = "update statistical set ptid = ?,ywbm = ?,ctype = ?,click_sum = ?,buy_sum = ? where goodid = ?"
  val select_sql = "select * from statistical"
  println("将数据更新到mysql中...")
  try {
    Class.forName("com.mysql.jdbc.Driver")
    conn = DriverManager.getConnection(url, username, password)
    var newSet = Set[String]()
    var oldSet = Set[String]()
    ps = conn.prepareStatement(select_sql)
    val oldResult = ps.executeQuery()
    while(oldResult.next()){
      val goodid = oldResult.getString(1)
      oldSet += goodid
    }

    val iterator = Set("1")

    iterator.foreach(data => {
      newSet +=data
    })
    println(newSet)
    println(oldSet)
    val addSet = newSet -- oldSet
    val updateSet = newSet & oldSet
    val delSet = oldSet -- newSet
    println(delSet)
    iterator.filter(x => {addSet.contains(x)}).foreach(data => {
      println(data)
      println("-------1")
      ps = conn.prepareStatement(insert_sql)
      ps.setString(1,data)
      ps.setString(2,data)
      ps.setString(3,data)
      ps.setString(4,data)
      ps.setString(5, data)
      ps.setString(6,data)
      ps.executeUpdate()
    })
    iterator.filter(x => {updateSet.contains(x)}).foreach(data => {
      println(data)
      println("-------2")
      ps = conn.prepareStatement(update_sql)
      ps.setString(1,data)
      ps.setString(2,data)
      ps.setString(3,data)
      ps.setString(4,data)
      ps.setString(5, data)
      ps.setString(6,data)
      ps.executeUpdate()
    })

    delSet.foreach(data => {
      println(data)
      println("-------3")
      ps = conn.prepareStatement(delete_sql)
      ps.setString(1,data)
      ps.execute()
    })
  }catch {
    case e:Exception => println(e)
  }

  finally {
    if (ps != null) {
      ps.close()
    }
    if (conn != null) {
      conn.close()
    }
  }
}

}
