package com.github.chengpohi.dump

import java.io.FileWriter

import com.github.chengpohi.registry.Registry

object DumpApp {
  import com.github.chengpohi.utils.ResponseGenerator._
  def main(args: Array[String]): Unit = {
    dump()
  }
  def dump(): Unit = {
    val n = 500
    val tag = "java"
    val questions = Registry.selectorService.selectTopNQuestions(n, tag)
    val res = questions.map(p => Registry.soService.getQuestion(p.id.toLong, tag))
    val writer = new FileWriter("dump/results.txt")
    res.foreach(q => {
      writer.append(q.toJson + System.lineSeparator())
    })
    writer.flush()
    writer.close()

  }
}
