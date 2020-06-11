/**
  * Created by E7440 on 1/30/2017.
  */

import groovy.util.Eval
import scala.concurrent.{Await, Future}
import scala.concurrent.duration._
import scala.concurrent.ExecutionContext.Implicits.global
import akka.actor._

case class Expression(expression: (String, Int))
class LoadCalculatorActor extends Actor{
  def receive={
    case Expression(expression) => LoadGenerator.evaluateAndPrint(expression)
  }
}

object LoadGenerator {
  import java.io.PrintWriter
  import scala.io.Source

  val filepath="src/main/resources/LoadGenerator/"
  val source=Source.fromFile(filepath+"GroovyExpressions.txt")
  val expressionList=source.getLines.toList.zipWithIndex

  def evaluateAndPrint(expression: (String, Int))={
    val writer=new PrintWriter(filepath+"client"+expression._2+".txt")
    try{
      for{
        j <- 0 to 600
      }writer.println(j+" "+Eval.me("t", j, expression._1))
    }finally{
      writer.close()
    }
  }

  def calculateLoadWithParallelCollections={
    expressionList.par foreach (expression=>{
      evaluateAndPrint(expression)
    })
  }

  def calculateLoadWithFuture={
    def calculateLoadWithFutureHelper(listExpression:List[(String, Int)], futureSeq:Seq[Future[AnyVal]]):Unit=listExpression match{
      case Nil => Await.result(Future.sequence(futureSeq), 40.second)
      case _ =>
        val f=Future {
          evaluateAndPrint(listExpression.head)
        }
        calculateLoadWithFutureHelper(listExpression.tail, futureSeq :+ f)
    }
    calculateLoadWithFutureHelper(expressionList, Nil)
  }

  def calculateLoadWithActor={
    val system=ActorSystem("LoadCalculatorSystem")
    expressionList foreach (expression => {
      val actor=system.actorOf(Props[LoadCalculatorActor], "LoadGeneratorActor"+expression._2)
      actor ! Expression(expression)
    })
    system.shutdown
  }

  def main(args: Array[String]): Unit = {
    //calculateLoadWithParallelCollections
    calculateLoadWithFuture
    //calculateLoadWithActor
  }
}
