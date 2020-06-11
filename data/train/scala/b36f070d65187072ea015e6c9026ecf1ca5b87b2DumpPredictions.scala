package edu.knowitall.eval

import scala.io.Source

object DumpPredictions extends App {
  
  def dumpTop(inputs: Iterable[String], oracle: Oracle, output: SystemOutput) = {
    for {
      i <- inputs
      o <- output.topOutputFor(i)
      c <- output.topScoreFor(i, o)
      l <- oracle.getLabel(i, o)
      li = if (l) 1 else 0
    } println(s"$i\t$o\t$c\t$li")
  }
  
  def dumpAll(inputs: Iterable[String], oracle: Oracle, output: SystemOutput) = {
    for {
      i <- inputs
      r <- output.recordsFor(i)
      o = r.output
      c <- output.topScoreFor(i, o)
      l <- oracle.getLabel(i, o)
      li = if (l) 1 else 0
    } println(s"$i\t$o\t$c\t$li")
  }
  
  val mode = args(0)
  val inputsPath = args(1)
  val labelsPath = args(2)
  val outputPath = args(3)
  
  val inputs = Source.fromFile(inputsPath, "UTF8").getLines.toList
  val oracle = new FileOracle(labelsPath)
  val output = SystemOutput.fromPath(outputPath)
  
  mode match {
    case "top" => dumpTop(inputs, oracle, output)
    case "all" => dumpAll(inputs, oracle, output)
  }

}