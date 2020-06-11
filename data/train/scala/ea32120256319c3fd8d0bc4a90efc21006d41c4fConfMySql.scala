package database

import dbp.{Main =>_, Manage =>_, CommandLineParser =>_, _}

/**
 * All information about an mysql instance
 */
class ConfMySql(hosting: java.net.URL, db: String, user: String, pw: String)
	extends Configuration {
	val host = hosting
	val username = user
	val password = pw
	val database = db
}

case class MySqlInstance(con: ConfMySql, set: ProjectSetup) extends
	DBInstance(set: ProjectSetup) {
  type Conf = ConfMySql
  val conf: Conf = new ConfMySql(new java.net.URL(""),"","","")
  val printer = (c: Conf, s: ProjectSetup) => {if (c.host.toString startsWith "") 2 else 2}
  //def print2DB 
}

object Test {
  val a  = MySqlInstance(new ConfMySql(new java.net.URL(""),"","",""), new ProjectSetup(""))
  a.print2DB

  
}