package com.andrewjamesjohnson.x12

import org.json4s.JsonAST.{JObject, JValue}
import org.json4s.JsonDSL._
import org.json4s.jackson.JsonMethods._

import scala.language.postfixOps

case class Loop(name : String, segments : Seq[Segment], loops : Seq[Loop], segmentSeparator : String) extends X12[Loop, Segment] {
  override def children: Seq[Loop] = loops

  override def length: Int = segments.length

  override def iterator: Iterator[Segment] = segments.iterator

  override def apply(idx: Int): Segment = segments(idx)

  override def toString(): String = {
    val segmentString = segments.map(_.toString()).mkString(segmentSeparator + "\n")
    loops.size match {
      case 0 => segmentString + segmentSeparator
      case _ => segmentString + segmentSeparator + "\n" + loops.map(_.toString()).mkString("\n")
    }
  }

  def debug(indent: Int): Unit = {
    for (i <- 1 to indent) print("\t")
    println("Loop start: " + name)
    segments.foreach(_.debug(indent + 1))
    loops.foreach(_.debug(indent + 1))
    for (i <- 1 to indent) print("\t")
    println("Loop end: " + name)
  }

  def toOldOldJson: JValue = {
    render(segments.map(_.toOldOldJson) ++ loops.map(_.toOldOldJson))
  }

  def toOldJson: JValue = {
    val json = segments.map(_.toOldJson).foldLeft(JObject()) { (i, j) => i ~ j }
    if (children.isEmpty)
      json
    else
      json ~ ("content" -> render(loops.map(_.toOldJson)))
  }

  def toJson: JObject = {
    val root = segments.head.toJson
    val child = (root \ segments.head.name).asInstanceOf[JObject]

    val json = segments.tail.map(_.toJson).foldLeft(child) { (i, j) => i ~ j }
    segments.head.name -> (if (children.isEmpty)
      json
    else
      loops.map(_.toJson).foldLeft(json) { (i, j) => i ~ j })
  }
}
