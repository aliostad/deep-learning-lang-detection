package com.scala.dao

/**
  * Created by CNSVCSHADM on 2017/5/25.
  */

import slick.ast.ColumnOption.PrimaryKey
import slick.jdbc.OracleProfile.api._
import

import scala.concurrent.ExecutionContext.Implicits.global

class Scala_Test(tag: Tag) extends  Table[(String, String, Int)](tag,"SCALA_TEST" ) {
  def id = column[String] ( "ID" ,O.PrimaryKey)
  def name = column[String]("NAME")
  def age = column[Int]("AGE")
  def * = (id, name ,age )
}


object db_manage extends App{
  val db = Database.forConfig("back")
  try{
    val scala_test = TableQuery[Scala_Test]
    val name = scala_test.filter(_.age== 25).map(_.name)
    println(name)
  }finally db.close()
}