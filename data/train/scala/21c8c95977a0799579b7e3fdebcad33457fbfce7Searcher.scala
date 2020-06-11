package com.stripe.ctf.instantcodesearch

import java.io._
import java.nio.file._

import com.twitter.concurrent.Broker

abstract class SearchResult
case class Match(path: String, line: Int) extends SearchResult
case class Done() extends SearchResult

class Searcher(index: Index) {

  def search(needle: String, broker: Broker[SearchResult]): Unit = {
    val results = index(needle)
    results.foreach {
      case (file, line) =>
        broker !! new Match(file, line)
    }
    broker !! new Done()
  }

}

