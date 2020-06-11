package knowbag.snippets.snippets

import java.io.FileNotFoundException

import knowbag.snippets.ManageResource
import org.scalatest.{Matchers, FlatSpec}

import scala.io.Source
import scala.util.control.NonFatal

/**
 * Created by feliperojas on 8/04/15.
 */
class TryCatchWithStructuralTypesLearn extends FlatSpec with Matchers {

  "scala has exceptions and" should "treated with pattern matching" in {
    getFileLinesSize("no-path") should be(-1)
    ManageResource(Source.fromFile("no-path")) { source =>
      source.size
    } should be(-1)
  }

  def getFileLinesSize(fileName: String): Int = {
    var source: Option[Source] = None
    try {
      source = Some(Source.fromFile(fileName))
      source.get.size
    } catch {
      case NonFatal(ex) => -1
    } finally {
      for (s <- source) s.close()
    }
  }

}
