package org.codefirst.shimbashishelf.search

import java.io.{File => JFile}
import java.io.IOException
import org.apache.lucene.analysis.cjk.CJKAnalyzer
import org.apache.lucene.store.Directory
import org.apache.lucene.store.FSDirectory
import org.apache.lucene.util.Version
import org.apache.lucene.index.{IndexWriterConfig, IndexWriter}
import org.apache.lucene.document.Field.{Index,Store}
import org.apache.lucene.analysis.SimpleAnalyzer
import net.reduls.gomoku.Tagger
import net.reduls.gomoku.analysis.ipadic.IpadicAnalyzer
import scala.collection.immutable.Stream
import org.codefirst.shimbashishelf._

trait IdGenerator {
  def generate(file : JFile, status : Status) : String
  def generate(file : String, status : Status) : String = generate(new JFile(file), status)
}

class SeqIdGenerator extends IdGenerator {
  def generate(file : JFile, status : Status) = {
    val id = status.safeInt("id").getOrElse(0)
    status("id") = id + 1
    id.toString
  }
}

object Indexer {
  def apply() = new Indexer(new JFile(INDEX_PATH), new SeqIdGenerator)
  def apply(path : JFile) = new Indexer(path, new SeqIdGenerator)

  def allFiles(file : JFile) : Stream[JFile] = {
    if (file.isFile()) {
      Stream.cons(file, Stream.empty)
    }else{
      for {
        sub  <- file.listFiles.toStream
        file <- allFiles(sub)
      } yield file
    }
  }
}

class Indexer(indexPath : JFile, idGenerator : IdGenerator) {
  import SLucene._

  private def withWriter(f : IndexWriter => Unit) {
    val analyzer = new IpadicAnalyzer(new Tagger())
    val config = new IndexWriterConfig(Version.LUCENE_31, analyzer)
    using(FSDirectory.open( indexPath )) { case dir =>
      using(new IndexWriter(dir, config)){ case writer =>
        f(writer) } }
  }

  private def index(path : String, text : String) {
    withWriter { writer =>
      Status.withDefault { case status => {
        val manageID = Searcher(indexPath).searchByPath(path) match {
          case Some(doc) =>
            doc.metadata.manageID
          case None =>
            idGenerator.generate(path, status)
        }
        writer.deleteDocuments(("path", path))
        val doc = new org.apache.lucene.document.Document()
        doc.add(("path"     , path,     Store.YES, Index.NOT_ANALYZED))
        doc.add(("manageID" , manageID, Store.YES, Index.NOT_ANALYZED))
        doc.add(("content"  , text,     Store.YES, Index.ANALYZED))
        doc.add(("file_path", path,     Store.YES, Index.ANALYZED))
        doc.add(("mimeType" , MimeDetector(new JFile(path)), Store.YES, Index.NOT_ANALYZED))
        try {
          writer.addDocument(doc)
        } catch { case _ =>
          doc.removeField("content")
          doc.add(("content", "<binary>", Store.YES, Index.ANALYZED))
          writer.addDocument(doc)
        }
      } } }
  }

  def index(file : JFile) {
    index(file.getPath(),
          TextExtractor.extract(file.getAbsolutePath()))
  }

  def delete(file : JFile) {
    withWriter { writer => writer.deleteDocuments(("path", file.getPath())) }
  }
}
