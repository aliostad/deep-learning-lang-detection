package org.scalaquery.example

import scala.language.postfixOps
import org.scalaquery.ql.{Query, ColumnBase, Table}
import org.scalaquery.ql.driver.{Driver}, Driver.Implicit._
import org.scalaquery.ql.Table
import org.scalaquery.util.NamingContext

object StatementVerify {
  def main(args: Array[String]): Unit = {

    object Users extends Table[(Int, String, String)]("users") {
      def id = column[Int]("id")
      def first = column[String]("first")
      def last = column[String]("last")
      def * = id ~ first ~ last
    }

    object Orders extends Table[(Int, Int)]("orders") {
      def userID = column[Int]("userID")
      def orderID = column[Int]("orderID")
      def * = userID ~ orderID
    }

    def dump(n: String, q: Query[ColumnBase[_], _]) {
      val nc = NamingContext()
      q.dump(n + ": ", nc)
      println(Driver.buildSelect(q, nc))
      println()
    }

    val q1 = for (u <- Users) yield u

    val q1b = q1.mapResult { case (id, f, l) => id + ". " + f + " " + l }

    val q2 = for {
      u <- Users
      _ <- Query.orderBy(u.first asc) >> Query.orderBy(u.last desc)
      o <- Orders filter { o => (u.id is o.userID) & (u.first isNotNull) }
    } yield u.first ~ u.last ~ o.orderID

    val q3 = for (u <- Users filter (_.id is 42)) yield u.first ~ u.last

    val q4 = for {
      (u, o) <- Users join Orders on (_.id is _.userID)
      _ <- Query orderBy u.last
    } yield u.first ~ o.orderID

    val q5 = for (
      o <- for (
        o <- Orders if o.orderID in (
          for { o2 <- Orders if o.userID is o2.userID } yield o2.orderID.max
        )
      ) yield o.orderID;
      _ <- Query orderBy o
    ) yield o

    val q6a =
      for (
        o <- (for (
          o <- Orders if o.orderID in (
            for { o2 <- Orders if o.userID is o2.userID } yield o2.orderID.max
          )
        ) yield o.orderID);
        _ <- Query orderBy o
      ) yield o

    val q6b =
      for (
        o <- (for (
          o <- Orders if o.orderID in (
            for { o2 <- Orders if o.userID is o2.userID } yield o2.orderID.max
          )
        ) yield o.orderID ~ o.userID);
        _ <- Query orderBy o._1
      ) yield o

    val q6c =
      for (
        o <- (for (
          o <- Orders if o.orderID in (
            for { o2 <- Orders if o.userID is o2.userID } yield o2.orderID.max
          )
        ) yield o);
        _ <- Query orderBy o.orderID
      ) yield o.orderID ~ o.userID

    dump("q1", q1)
    dump("q2", q2)
    dump("q3", q3)
    dump("q4", q4)
    dump("q5", q5)
    dump("q6a", q6a)
    dump("q6b", q6b)
    dump("q6c", q6c)

    val usersBase = Users.mapOp(n => Table.Alias(n))

    {
      val m1a = for {
        u <- Query(usersBase)
        r <- Query(u)
      } yield r
      val m1b = Query(usersBase)
      dump("m1a", m1a)
      dump("m1b", m1b)
    }

    {
      def f[A](t: Table[A]) = t.mapOp(n => Table.Alias(n))
      val m2a = for { u <- Query(Users) } yield f(u)
      val m2b = Query(f(Users))
      dump("m2a", m2a)
      dump("m2b", m2b)
    }

    /*
    {
      val g1 = { u: UsersTable => u sortBy u.first }
      val g2 = { u: UsersTable => u sortBy u.last }
      println()
      (for(a <- Query(usersBase); b <- g2(a); result <- g1(b)) yield result).dump("m3a: ")
      (for(a <- Query(usersBase); result <- (for(b <- g2(a); temp <- g1(b)) yield temp)) yield result).dump("m3b: ")
    }
    */

    println()

    println("Insert1: " + Driver.buildInsert(Users))
    println("Insert2: " + Driver.buildInsert(Users.first ~ Users.last))

    val d1 = Users.filter(_.id is 42)
    val d2 = for (u <- Users filter (_.id notIn Orders.map(_.userID))) yield u
    println("d0: " + Driver.buildDelete(Users, NamingContext()))
    println("d1: " + Driver.buildDelete(d1, NamingContext()))
    println("d2: " + Driver.buildDelete(d2, NamingContext()))

    (Users.ddl ++ Orders.ddl).createStatements.foreach(println)
  }
}
