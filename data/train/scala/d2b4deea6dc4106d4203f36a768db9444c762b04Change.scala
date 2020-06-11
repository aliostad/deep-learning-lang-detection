package de.jowisoftware.mining.importer

import TicketDataFields._
import java.util.Date

trait Change {
  val date: Date
  val editor: String
  def update(ticket: TicketData)
  def downgrade(ticket: TicketData)
}

class SimpleChange[T](val date: Date, field: FieldDescription[T], oldValue: T, newValue: T, val editor: String) extends Change {
  def update(ticket: TicketData) = ticket(field) = newValue
  def downgrade(ticket: TicketData) = ticket(field) = oldValue
}

class SplitChange[T](val date: Date, field: FieldDescription[String], pos: Int, oldValue: String, newValue: String, val editor: String) extends Change {
  def update(ticket: TicketData) = ticket(field) = replaceSegment(pos, ticket(field), newValue)
  def downgrade(ticket: TicketData) = ticket(field) = replaceSegment(pos, ticket(field), oldValue)

  private def replaceSegment(field: Int, original: String, newSegment: String) = {
    val segs = original.split(":", -1)
    segs(field) = newSegment
    segs.mkString(":")
  }
}

class ArrayChange[T](val date: Date, field: FieldDescription[Seq[T]], oldValue: Option[T], newValue: Option[T], val editor: String) extends Change {
  private def remove(ticket: TicketData, value: T) = ticket(field) = ticket(field).filterNot(_ == value)
  private def add(ticket: TicketData, value: T) = ticket(field) = (ticket(field) :+ value)

  private def replace(ticket: TicketData, oldValue: T, newValue: T) =
    ticket(field) = ticket(field).map { value => if (value == oldValue) newValue else value }

  def update(ticket: TicketData) =
    if (newValue == None)
      remove(ticket, oldValue.get)
    else if (oldValue == None)
      add(ticket, newValue.get)
    else
      replace(ticket, oldValue.get, newValue.get)

  def downgrade(ticket: TicketData) =
    if (oldValue == None)
      remove(ticket, newValue.get)
    else if (newValue == None)
      add(ticket, oldValue.get)
    else
      replace(ticket, newValue.get, oldValue.get)
}

class SetChange[T](val date: Date, field: FieldDescription[Seq[T]], oldValue: Set[T], newValue: Set[T], val editor: String) extends Change {
  def update(ticket: TicketData) =
    ticket(field) = (ticket(field).filterNot(oldValue.contains) ++ newValue)

  def downgrade(ticket: TicketData) =
    ticket(field) = (ticket(field).filterNot(newValue.contains) ++ oldValue)
}