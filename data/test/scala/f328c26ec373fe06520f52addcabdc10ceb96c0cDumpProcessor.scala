package dump

import dataFormats.{WikiListPage, WikiPage, _}
import it.cnr.isti.hpc.wikipedia.article.Article

trait DumpProcessor {
  val articleList: List[Article]

  def startProcessing() = {
    // or articleList.map(processArticle).flatten
    articleList
      .map(processArticle)
      .filter(_.isDefined)
      .map(_.get)
  }

  def processArticle(article: Article): Option[WikiPage]
}

class ListProcessor(val articleList: List[Article]) extends DumpProcessor {

  override def processArticle(article: Article): Option[WikiListPage] = {
    val parser = new ListArticleParser(article)
    parser.parseArticle()
  }
}

class TableProcessor(val articleList: List[Article]) extends DumpProcessor {

  override def processArticle(article: Article): Option[WikiTablePage] = {
    val parser = new TableArticleParser(article)
    parser.parseArticle()
  }
}
