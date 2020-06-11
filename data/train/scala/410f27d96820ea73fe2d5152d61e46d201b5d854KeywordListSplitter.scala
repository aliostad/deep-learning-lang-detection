package spout.TwitterAPIUtils

/*
 * MANAGE PARALLELISM
 * if i have multiple tasks for this spout i distribute the keywords to every task in a balanced way
 */
import scala.concurrent._
import ExecutionContext.Implicits.global

object KeywordListSplitter {
  def getKeywordList(keywords: List[String],spoutSize: Int, myIdx: Int): Future[List[String]] = {
    Future {
    val keywordsGrouped = keywords.grouped(keywords.length/spoutSize).toList
    //println("keywordGrouped: "+keywordsGrouped +" spoutSize: "+ spoutSize +" myindx "+ myIdx)
    if(keywordsGrouped(myIdx).isEmpty)
	throw new RuntimeException("No track found for spout" +
	" [spoutsSize:"+spoutSize+", keywords:"+keywords.length+"] the amount" +
	" of tracks must be more then the spout paralellism")
    else 
      keywordsGrouped(myIdx)
    }
  }
}
