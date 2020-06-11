package org.example

import argonaut.Argonaut._
import argonaut._
import scalaz.concurrent.Task
import scalaz.stream.Process
import scalaz.stream.Process._

object JsonConversions {

  implicit class ProcessJson[M[_], A: CodecJson](process: Process[M, A]) {
    def asJsonArray: Process[M, String] =
      emit("[") ++ process.map(_.asJson.nospaces).intersperse(",") ++ emit("]")
  }

  implicit def ArticleJson: CodecJson[Article]
    = casecodec4(Article.apply, Article.unapply)("id", "title", "doi", "published")
}
