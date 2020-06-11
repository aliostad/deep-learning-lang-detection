package main.scala.ex.basic

object Data  extends App{
   def loadRight() = {
          println("-----loadRight")
          List(2,1,2,2,2,4,3,2,3,2)
   }

  def loadPoint() ={
    println("-----loadPoint")
    List(5,5,10,10,15,15,5,10,10,5)
  }

  def loadAnswer()={
    println("------loadAnswer")
    List(2,1,2,3,1,3,4,2,2,2)
  }

  def loadAnswers() ={
    println("------loadAnswers")
    List(
      List(2,1,2,3,1,3,4,2,2,2),
      List(2,2,4,3,2,4,3,2,3,2),
      List(2,1,2,2,2,4,3,2,3,2),
      List(2,1,2,3,1,4,3,1,2,1),
      List(1,2,3,2,2,3,3,2,3,1))


  }


}