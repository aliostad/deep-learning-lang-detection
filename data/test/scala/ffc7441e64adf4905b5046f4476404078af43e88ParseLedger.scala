package models

import play.api.db.slick.Config.driver.simple._
import scala.slick.jdbc.{StaticQuery => Q}
import scala.slick.jdbc.GetResult
import java.sql.Date


case class ParseLedger(newItems: Int, oldItems: Int, failedItems: Int, createdAt : Date, endedAt: Date)


object ParseLedgerTable extends Table[ParseLedger]("parse_ledger") {
  implicit val getParseLedger =
      GetResult({r => r.nextInt; ParseLedger(r.nextInt,r.nextInt, r.nextInt, r.nextDate, r.nextDate) })

  def id = column[Int] ("id", O.PrimaryKey)
  def newItems = column[Int] ("new_items")
  def oldItems = column[Int] ("old_items")
  def failedItems = column[Int]("failed_items")
  def createdAt = column[Date]("created_at")
  def endedAt = column[Date]("ended_at")

  def * = newItems ~ oldItems  ~ failedItems ~ createdAt ~ endedAt <> (ParseLedger.apply _, ParseLedger.unapply _)

  def findAll(implicit session: Session) : List[ParseLedger] = {
      Q.queryNA[ParseLedger](s"select * from parse_ledger order by created_at desc").list()
  }

}
