package ex1

import ex1.PwdMgmt._
import shared.ConnProvider

import scala.io.StdIn.readLine

object Main extends App {



  def myProgram(userid: String): ConnProvider => Unit =
    connProvider => {
      println("Enter old password")
      val oldPwd = readLine()
      println("Enter new password")
      val newPwd = readLine()
      connProvider.run(changePwd(userid, oldPwd, newPwd).thisAction) //evaluate composed dbaction
    }

  def runInTest[A](dbProgram: ConnProvider => A): A = dbProgram(ConnProvider.SqliteTestDB)

  def runInProduction[A](dbProgram: ConnProvider => A): A = dbProgram(ConnProvider.MysqlProdDB)

  runInTest(myProgram("guestuser"))
}