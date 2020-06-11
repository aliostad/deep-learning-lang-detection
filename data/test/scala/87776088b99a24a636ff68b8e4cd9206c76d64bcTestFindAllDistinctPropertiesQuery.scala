package query

import core.globals.KnowledgeGraphs
import core.query.specific.QueryFactory
import core.dump.DumpObject
import org.scalatest.FunSuite
import org.scalatest.tagobjects.Slow
import tags.ActiveTag
/**
  * Created by Espen on 02.11.2016.
  */
class TestFindAllDistinctPropertiesQuery extends FunSuite{
  implicit val knowledgeGraph = KnowledgeGraphs.wikidata
  val filename = "/test/distinctPropertiesWikidata"
  test("In total there should be: # of properties", Slow) {
    val properties: List[String] = QueryFactory.findAllDistinctProperties
    DumpObject.dumpListString(properties, filename)
    assert(properties.length == 5379)
  }
  test("Same test, but reading from file", ActiveTag ) {
    val properties: List[String] = DumpObject.getListString(filename)
    assert(properties.length == 5379)
  }




}
