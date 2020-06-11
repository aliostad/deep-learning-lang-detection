package mytodo.test

import java.sql.Timestamp

import mytodo.datasource.dataObjects.TaskData
import mytodo.datasource.dataObjects.repeaters.{IntervalRepeaterData, DayRepeaterData, DateRepeaterData}
import mytodo.datasource.database.TasksDatabase
import org.scalatest.{BeforeAndAfter, FlatSpec, Assertions}
import java.util.Calendar
import java.util.Calendar._
import org.scalatest.Assertions._
import mytodo.task.reminder._
import java.io.File

class RepeatFunctionTest extends FlatSpec with BeforeAndAfter{

  val sqlDS = new TasksDatabase
  var tempFile : File = null
  
  before{
    sqlDS.createAndOpen("test.db")
    tempFile = new File("test.db")
  }

  after{
    sqlDS.close()
    tempFile.delete()
  }

  behavior of "RepeatAtDate"
  
  val oldStart = Calendar.getInstance()
  oldStart.set(2014, DECEMBER, 31, 13, 25, 47)

  val oldEnd = Calendar.getInstance()
  oldEnd.set(2016, NOVEMBER, 17, 21, 32, 43)

  val newStart = Calendar.getInstance()
  newStart.set(2023, JUNE, 5, 22, 33, 11)

  private def checkNones(args  : ( Option[Calendar],  Option[Calendar]) ) = {
    assert(args._1 == None)
    assert(args._2 == None)
  }
  
  def checkLeftNone(args : (Option[Calendar], Option[Calendar]), check : (Calendar => Boolean) ) = {
    assert(args._1 == None)
    assert(check(args._2.get))
  }

  def checkRightNone(args : (Option[Calendar], Option[Calendar]), check : (Calendar => Boolean) ) = {
    assert(args._2 == None)
    assert(check(args._1.get))
  }

  it should "set start time in date from constructor" in{ //make reusable
    val task = sqlDS.taskTable.create(TaskData(name = "Task1"))
    val fun = sqlDS.dateRepeatersTable.create( DateRepeaterData(task.id, mytodo.Util.toTimestamp(newStart)) )
    checkNones(fun(None, None) )
    checkLeftNone(fun(None, Some(newStart)), _ == newStart)
    checkRightNone(fun(Some(newStart), None), _ == newStart)
    val (checkStart, _) = fun(Some(oldStart), Some(oldEnd))
    Util.calendarAssert(newStart, checkStart.get)
  }
  
  def checkNewEnd[T <: RepeatFunction](fun : T) = {
    val (checkStart, checkEnd) = fun(Some(oldStart), Some(oldEnd))
    val oldDiff = oldEnd.getTimeInMillis - oldStart.getTimeInMillis
    val newDiff = checkEnd.get.getTimeInMillis - checkStart.get.getTimeInMillis
    Util.calendarOrderAssert( checkStart.get, checkEnd.get )
    assert( oldDiff == newDiff)
  }

  it should "new end should be after the same interval as old end" in{ //Make reusable
    val task = sqlDS.taskTable.create(TaskData(name = "Task1"))
    val fun = sqlDS.dateRepeatersTable.create( DateRepeaterData(task.id, mytodo.Util.toTimestamp(newStart)) )
    checkNewEnd(fun)
  }
  
  behavior of "DayOfMonth"
  
  it should "set day field of calendar in certain day in next month" in{
    val task = sqlDS.taskTable.create(TaskData(name = "Task1"))
    val fun = sqlDS.dayRepeatersTable.create(DayRepeaterData(task.id, 31))
    checkNones(fun(None, None) )
    //checkLeftNone(fun.repeat( (None, Some(newStart)) ), _ == newStart)
    //checkRightNone(fun.repeat( (Some(newStart), None) ), _ == newStart)
    val (newStart, _) = fun(Some(oldStart), Some(oldEnd))
    val nexMonth : Calendar = oldStart.clone.asInstanceOf[Calendar]
    nexMonth.add(MONTH, 1)
    Util.calendarAssert(nexMonth, newStart.get)
  }

  it should "new end should be after the same interval as old end" in{ //Make reusable
    val task = sqlDS.taskTable.create(TaskData(name = "Task1"))
    val fun = sqlDS.dayRepeatersTable.create(DayRepeaterData(task.id, 31))
    checkNewEnd(fun)
  }
  
  it should "set day to the last day of month if there is no corresponding day number in month" in{
    val task = sqlDS.taskTable.create(TaskData(name = "Task1"))
    val fn = sqlDS.dayRepeatersTable.create(DayRepeaterData(task.id, 31))
    val (janStart, _) = fn( (Some(oldStart), Some(oldEnd)) )
    assert(janStart.get.get(MONTH) == JANUARY)
    var (newStart, newEnd) = fn( fn( (Some(oldStart), Some(oldEnd)) ) )
    assert(newStart.get.get(MONTH) == FEBRUARY)
    assert(newStart.get.get(DAY_OF_MONTH) == 28)
    newStart = fn( (newStart, newEnd) )._1
    assert(newStart.get.get(MONTH) == MARCH)
    assert(newStart.get.get(DAY_OF_MONTH) == 31)
  }

  behavior of "RepeatAfterInterval"

  it should "set next start after an interval in milliseconds" in{
    val task = sqlDS.taskTable.create(TaskData(name = "Task1"))
    val fun = sqlDS.intervalRepeatersTable.create(IntervalRepeaterData(task.id, new Timestamp(1000)))
    def nextNSec(n : Int) : Calendar = {
      val c = oldStart.clone.asInstanceOf[Calendar]
      c.add(SECOND, 1)
      c
    }
    val (newStart, _) = fun(Some(oldStart), Some(oldEnd))
    assert(newStart.get == nextNSec(1))
    val (_, _) = fun(fun(fun(Some(oldStart), Some(oldEnd))))
    Util.calendarAssert( nextNSec(3), newStart.get)
  }

  it should "new end should be after the same interval as old end" in{ //Make reusable
    val task = sqlDS.taskTable.create(TaskData(name = "Task1"))
    val fun = sqlDS.intervalRepeatersTable.create(IntervalRepeaterData(task.id, new Timestamp(1000)))
    checkNewEnd(fun)
  }

  it should "print correct image" in{
    val task = sqlDS.taskTable.create(TaskData(name = "Task1"))
    val fun = sqlDS.intervalRepeatersTable.create(IntervalRepeaterData(task.id, new Timestamp(3000)))
    assert(fun.toString == "Repeat after 00 minutes and 03 seconds")
    sqlDS.intervalRepeatersTable.remove(task.id)
    val fun2 = sqlDS.intervalRepeatersTable.create(IntervalRepeaterData(task.id, new Timestamp(30 * 60 * 1000 + 32 * 1000)))
    assert(fun2.toString == "Repeat after 30 minutes and 32 seconds")
    sqlDS.intervalRepeatersTable.remove(task.id)
    val fun3 = sqlDS.intervalRepeatersTable.create(IntervalRepeaterData(task.id, new Timestamp(33 * 60 * 1000 + 3600 * 1000)))
    assert(fun3.toString ==  "Repeat after 01 hours and 33 minutes")
  }

}