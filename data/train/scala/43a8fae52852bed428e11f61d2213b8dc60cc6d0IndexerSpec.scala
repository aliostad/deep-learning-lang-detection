package org.codefirst.shimbashishelf.search
import org.scalatest.Spec
import org.scalatest.matchers.ShouldMatchers
import java.io.{FileWriter,File}
import org.codefirst.shimbashishelf.util.FileUtil
import org.scalatest.BeforeAndAfterEach

class IndexerSpec extends Spec with ShouldMatchers with BeforeAndAfterEach {
  val IndexFile = new File("test_index/index")
  val SampleFile = new File("test_index/index_test1.txt")
  val AnotherFile = new File("test_index/index_test2.txt")

  override def beforeEach() {
    IndexFile.mkdirs()
    FileUtil.touch(SampleFile,"hello")
    FileUtil.touch(AnotherFile,"hi")
  }

  override def afterEach() {
    FileUtil.delete(new File("test_index"))
  }

  describe("index管理"){
    def indexer = {
      val indexer = Indexer(IndexFile)
      indexer.index(SampleFile)
      indexer
    }

    it("indexに追加できる") {
      val _ = indexer
      println("hi")
      println(Searcher(IndexFile).searchByPath(SampleFile.getAbsolutePath()))
      Searcher(IndexFile).searchByPath(SampleFile.getPath()) should not be (None)
    }

    it("indexから削除できる") {
      indexer.delete(SampleFile)
      Searcher(IndexFile).searchByPath(SampleFile.getAbsolutePath()) should be (None)
    }
  }

  describe("管理番号") {
    it("管理番号が振られる") {
      val indexer = Indexer(IndexFile)
      indexer.index(SampleFile)
      indexer.index(AnotherFile)

      val doc1 = Searcher(IndexFile).searchByPath(SampleFile.getPath()).orNull
      val doc2 = Searcher(IndexFile).searchByPath(AnotherFile.getPath()).orNull

      doc1.metadata.manageID should not be(doc2.metadata.manageID)
    }

    it("管理番号が引きつがれる") {
      val indexer = Indexer(IndexFile)
      indexer.index(SampleFile)
      val doc1 = Searcher(IndexFile).searchByPath(SampleFile.getPath()).orNull

      indexer.index(SampleFile)
      val doc2 = Searcher(IndexFile).searchByPath(SampleFile.getPath()).orNull

      println(doc1)
      println(doc2)
      doc1.metadata.manageID should be (doc2.metadata.manageID)
    }
  }

  describe("ファイルリスト") {
    it ("一覧を取得する") {
      val xs = Indexer.allFiles(new File("test_index"))
      xs should contain (SampleFile)
      xs should contain (AnotherFile)
    }
  }
}
