package com.andrewjamesjohnson.x12

import org.json4s.JsonAST.JValue
import org.json4s.JsonDSL._
import org.json4s.jackson.JsonMethods._


case class Document(name : String, loops : Seq[Loop]) extends X12[Loop, Loop] {

  override def children: Seq[Loop] = loops

  override def length: Int = loops.length

  override def iterator: Iterator[Loop] = loops.iterator

  override def apply(idx: Int): Loop = loops(idx)

  override def toString(): String = {
    loops.map(_.toString()).mkString("\n")
  }

  def debug(): Unit = {
    println("Document start: " + name)
    loops.foreach(_.debug(1))
    println("Document end: " + name)
  }

  def toOldOldJson: JValue = {
    render(loops.map(_.toOldOldJson))
  }

  def toOldJson: JValue = {
    render(loops.map(_.toOldJson))
  }

  def toJson: JValue = {
    render(loops.map(_.toJson))
  }
}
