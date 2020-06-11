package com.tw.oocamp

import scala.collection.mutable.ListBuffer

class SuperRobot(size:Int=1) extends Robot{

  private val innerLockers:ListBuffer[Locker] = ListBuffer[Locker]()

  protected override def getStorableLocker():Option[Locker]={
    Option(innerLockers.map(v=>(v.remainingCount.toDouble/v.allCount.toDouble,v)).toSeq.sortBy(_._1).reverse.head._2)
  }

  protected override def getStoredLocker(ticket:Option[Ticket]):Option[Locker]={
    innerLockers collectFirst { case locker if locker.isValid(ticket)=>locker}
  }

  override def manage(locker: Locker){
    if(innerLockers.length==size) throw new IllegalArgumentException()
    innerLockers+=locker
  }
}

