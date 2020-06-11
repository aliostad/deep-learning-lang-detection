package my.finder.search.service

import play.api.Play._
import org.apache.lucene.store.{FSDirectory, Directory}
import java.io.File
import org.apache.lucene.index.DirectoryReader
import org.apache.lucene.search.IndexSearcher
import play.api.libs.concurrent.Akka
import scala.concurrent.duration._
import scala.concurrent.ExecutionContext.Implicits.global
import scala.collection.mutable._

/**
 *
 */
object SearcherManager {
  val wordDir = current.configuration.getString("indexDir")
  val ddIndexDir = current.configuration.getString("ddIndexDir")
  val attrIndexDir = current.configuration.getString("attrIndexDir")
  val oldDir = current.configuration.getString("oldDir")
  private val dbQueue = Queue[IndexSearcher]()
  var ddSearcher:IndexSearcher = null
  var attrSearcher:IndexSearcher = null
  var oldIncSearcher:IndexSearcher = null
  var oldReader:DirectoryReader = null
  def dbSearcher = {
    dbQueue.last
  }
  def init = {
    val dir:Directory = FSDirectory.open(new File(wordDir.get))
    val reader = DirectoryReader.open(dir)
    val s = new IndexSearcher(reader)
    oldReader = reader
    dbQueue += s


    val ddDir:Directory = FSDirectory.open(new File(ddIndexDir.get));
    val ddReader = DirectoryReader.open(ddDir);
    ddSearcher  = new IndexSearcher(ddReader);

    val attrDir:Directory = FSDirectory.open(new File(attrIndexDir.get));
    val attrReader = DirectoryReader.open(attrDir);
    attrSearcher  = new IndexSearcher(attrReader);

    fn
  }
  def changeIncDD = {
    val newReader = DirectoryReader.openIfChanged(oldReader)
    if(newReader != null){
      val newSearcher = new IndexSearcher(newReader)
      dbQueue += newSearcher
      oldReader = newReader
      if(dbQueue.size > 3) {
        val old = dbQueue.dequeue
        old.getIndexReader.close
      }
    }
  }
  def fn = {
    Akka.system.scheduler.schedule(0 second,300 second) {
      changeIncDD
    }
  }
}
