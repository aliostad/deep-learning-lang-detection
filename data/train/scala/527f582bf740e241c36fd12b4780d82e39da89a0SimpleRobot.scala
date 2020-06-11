package com.tw.oocamp

import collection.mutable.ListBuffer

class SimpleRobot(size:Int=1) extends Robot {

  private val innerLockers:ListBuffer[Locker] = ListBuffer[Locker]()

  protected override def getStorableLocker():Option[Locker]={
    innerLockers collectFirst { case locker if !locker.isFull => locker}
  }

  protected override def getStoredLocker(ticket:Option[Ticket]):Option[Locker]={
    innerLockers collectFirst { case locker if locker.isValid(ticket)=>locker}
  }

  override def manage(locker: Locker){
    if(innerLockers.length==size) throw new IllegalArgumentException()
    innerLockers+=locker
  }

}
