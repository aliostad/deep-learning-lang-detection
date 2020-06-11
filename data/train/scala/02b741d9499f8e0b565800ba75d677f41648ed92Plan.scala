package com.stan.server

import scala.collection.mutable.ArrayBuffer
import collection.mutable
import reflect.BeanProperty

/**
 * Created with IntelliJ IDEA.
 * User: grantheywood
 * Date: 03/02/2013
 * Time: 16:18
 * Holds a POA, contains a number of tasks
 */
class Plan(nam: String, des: String)
{
  private var name = nam
  private var description = des
  private var tasks = new mutable.ArrayBuffer[Task]


  def addTask(newTask: Task)
  {
    tasks.+=(newTask)
  }

  def removeTaskbyTask(oldTask: Task)
  {
    tasks.-=(oldTask)
  }


  // Getters and Setters

}
