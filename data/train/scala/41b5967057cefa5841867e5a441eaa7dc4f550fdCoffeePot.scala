package com.agiledeveloper.pcj

import akka.stm.Ref
import akka.stm.atomic
import akka.stm.TransactionFactory

//START:CODE
object CoffeePot {
  val cups = Ref(24)
  
  def readWriteCups(write : Boolean) = { 
    val factory = TransactionFactory(readonly = true)
      
    atomic(factory) {
        if(write) cups.swap(20)
        cups.get() 
    }
  }

  def main(args : Array[String]) : Unit = {
    println("Read only")
    readWriteCups(false)

    println("Attempt to write")
    try {
      readWriteCups(true)      
    } catch {
      case ex => println("Failed " + ex)
    }
  }
}
//END:CODE
