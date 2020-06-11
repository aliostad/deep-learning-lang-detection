package ru.bugzmanov.jstackcompact

import scala.annotation.tailrec

object CompactStackApp {

  def main(args: Array[String]) = {

    if(args.nonEmpty && args(0) == "-h") {
      println(
        """Usage:
          | - java -jar jstackcompact.jar <thread_dump.file>
          | - jstack <pid> | java -jar jstackcompact.jar """.stripMargin)

      System.exit(0)
    }

    val lines: Iterator[String] = if (args.isEmpty)
      io.Source.stdin.getLines
    else
      io.Source.fromFile(args(0)).getLines

    println(compact(lines))

  }

  def compact(list: Iterator[String]): String = {

    def collectThreadDump(iter: Iterator[String]): (Iterator[String], Vector[String]) = {
      val builder = Vector.newBuilder[String]
      while(iter.hasNext) {
        val next = iter.next()
        if(next.trim.isEmpty) return (iter,builder.result)
        else builder+= next
      }

      (iter, builder.result)
    }

    val dumps = Vector.newBuilder[ThreadStack]
    val builder = Vector.newBuilder[String]

    while(list.hasNext) {
      val next = list.next()
      if(next.matches("\".*\".*tid=.*")) {
        dumps += ThreadStack(Vector(next) ++ collectThreadDump(list)._2)
      }
    }

    CompactedThreadDump.transform(dumps.result).foldLeft("") {case (str, item) => str + "\n\n" + item.toString }
  }
}


case class ThreadStack(threadName: String, state: Option[String], traceElements: Vector[String]) {

  def sameState(t: ThreadStack) = this.state.isDefined &&
    this.state == t.state &&
    this.traceElements.nonEmpty &&
    this.traceElements == t.traceElements

  override def toString() = {
    val str = new StringBuilder()
    str.append(threadName)
    if (state.isDefined) {
      str.append("\n" + state.get)
      if (traceElements.nonEmpty) {
        str.append("\n" + traceElements.reduce(_ + "\n" + _))
      }
    }
    str.result
  }
}

object ThreadStack {
  def apply(str: String):ThreadStack = apply(str.split("\n").toVector)


  def apply(split: Vector[String]):ThreadStack = new ThreadStack(
    threadName = split.head,
    state = split.tail.headOption,
    traceElements = if (split.length > 2) split.drop(2) else Vector())

}

case class CompactedThreadDump(threads: Vector[String], state: Option[String], traceElement: Vector[String]) {
  override def toString() ={
    val str = new StringBuilder()
    if(threads.size > 1)
      str.append("Threads:[\n  " + threads.reduce(_ + "\n  " +_) + "\n]")
    else {
      str.append(threads.head)
    }
    if (state.isDefined) {
      str.append("\n" + state.get)
      if (traceElement.nonEmpty) {
        str.append("\n" + traceElement.reduce(_ + "\n" + _))
      }
    }
    str.result
  }
}

object CompactedThreadDump {

  def transform(dumps: Vector[ThreadStack]): Vector[CompactedThreadDump] = {
    import scala.collection.mutable

    @tailrec
    def recur(col: Vector[ThreadStack], builder: mutable.Builder[CompactedThreadDump, Vector[CompactedThreadDump]]): mutable.Builder[CompactedThreadDump, Vector[CompactedThreadDump]] = {
      if (col.nonEmpty) {
        val current: ThreadStack = col.head

        val partition = col.tail.partition(current.sameState)

        builder += CompactedThreadDump(
          threads = Vector(current.threadName) ++ partition._1.map(_.threadName),
          state = current.state, traceElement = current.traceElements)

        recur(partition._2, builder)
      } else {
        builder
      }
    }

    recur(dumps, Vector.newBuilder[CompactedThreadDump]).result
  }
}