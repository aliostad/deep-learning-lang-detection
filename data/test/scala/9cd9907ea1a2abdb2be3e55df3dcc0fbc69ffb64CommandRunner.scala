package org.grumpysoft.runner

import org.grumpysoft.parser.{RedirectInput, Pipe, Fragment, Expression}
import sys.process.{Process, ProcessBuilder}
import java.io.File

class MyProcessBuilder(val args: List[String],
                       val batches: List[List[String]],
                       val directions: List[Expression]) {
  def accept(exp: Expression) : MyProcessBuilder = exp match {
    case Fragment(shard) => new MyProcessBuilder(shard :: args, batches, directions)
    case Pipe => new MyProcessBuilder(Nil, args :: batches, Pipe :: directions)
    case RedirectInput => new MyProcessBuilder(Nil, args :: batches, RedirectInput :: directions)
  }

  def build() : ProcessBuilder = {
    val orderedBatches = (args :: batches).reverse
    val orderedDirections = directions.reverse

    val initialProcess : ProcessBuilder = Process(orderedBatches.head.reverse)
    val batchesWithDirections = orderedBatches.tail.zip(orderedDirections)

    batchesWithDirections.foldLeft(initialProcess) { (processBuilder, batchAndDirection) =>
      batchAndDirection._2 match {
        case Pipe =>
          processBuilder #| Process(batchAndDirection._1.reverse)
        case RedirectInput =>
          processBuilder #< new File(batchAndDirection._1.head)
      }
    }
  }
}

class CommandRunner {
  def run(expressions: List[Expression]) : ProcessBuilder = {
    val myProcessBuilder = expressions.foldLeft(new MyProcessBuilder(Nil, Nil, Nil)) { (mpb, exp) => mpb.accept(exp) }
    myProcessBuilder.build()
  }
}